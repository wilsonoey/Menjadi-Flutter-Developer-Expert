#!/usr/bin/env bash

# https://medium.com/@nocnoc/combined-code-coverage-for-flutter-and-dart-237b9563ecf8

# remember some failed commands and report on exit
error=false
LOG_FILE="log_test.txt"
FAILED_LOG_FILE="failed_tests.txt"
FAILED_TESTS_DIR="failed_tests_output"

show_help() {
  printf "usage: $0 [--help]
Tool for running all unit and widget tests with code coverage and automatically generated if lcov is installed.

(run from root of repo)
where:
    --help
        print this message
"
  exit 1
}

# run unit and widget tests
runTests() {
  cd $1
  if [ -f "pubspec.yaml" ] && [ -d "test" ]; then
    echo "running tests in $1" | tee -a "$3/$LOG_FILE"
    flutter pub get 2>&1 | tee -a "$3/$LOG_FILE"

    escapedPath="$(echo $1 | sed 's/\//\\\//g')"

    # run tests with coverage
    if grep flutter pubspec.yaml >/dev/null; then
      echo "run flutter tests" | tee -a "$3/$LOG_FILE"
      if [ -f "test/all_tests.dart" ]; then
        flutter test --coverage test/all_tests.dart 2>&1 | tee -a "$3/$LOG_FILE" || error=true
      else
        flutter test --coverage 2>&1 | tee -a "$3/$LOG_FILE" || error=true
      fi

      if [ -d "coverage" ]; then
        # combine line coverage info from package tests to a common file
        sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >>$2/coverage/test.info
        rm -f coverage/lcov.info
      fi
    else
      echo "not a flutter package, skipping" | tee -a "$3/$LOG_FILE"
    fi
  fi
  cd - >/dev/null
}

# Extract test file path dari log line
extractTestPath() {
  local line=$1
  
  # Pattern 1: path sebelum ".dart:" (contoh: test/path/to/file.dart 214:56)
  if [[ $line =~ (test/[^[:space:]]+\.dart) ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi
  
  # Pattern 2: "file:///path/to/test.dart"
  if [[ $line =~ file:///.*/(test/[^[:space:]]+\.dart) ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi
  
  # Pattern 3: D:/path/test/...
  if [[ $line =~ (test/[^[:space:]]+\.dart) ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi
  
  return 1
}

# Extract and format failed tests dengan menyimpan ke file sesuai path
extractFailedTests() {
  local logFile=$1
  local outputDir=$2
  
  # Buat direktori output jika belum ada
  mkdir -p "$outputDir"
  
  # Clear main failed tests file
  > "$outputDir/$FAILED_LOG_FILE"
  
  local currentTestFile=""
  local currentTestError=""
  local testCount=0
  
  while IFS= read -r line; do
    # Cari line dengan [E] - failed test
    if [[ $line =~ \[E\] ]]; then
      # Jika ada test sebelumnya, simpan terlebih dahulu
      if [ -n "$currentTestFile" ] && [ -n "$currentTestError" ]; then
        saveTestError "$outputDir" "$currentTestFile" "$currentTestError"
      fi
      
      # Extract test file path
      currentTestFile=$(extractTestPath "$line")
      
      if [ -z "$currentTestFile" ]; then
        currentTestFile="unknown_test_$testCount"
      fi
      
      testCount=$((testCount + 1))
      currentTestError="$line"
    elif [ -n "$currentTestFile" ] && [ -n "$line" ]; then
      # Accumulate error details sampai line baru yang tidak kosong
      if [[ $line =~ ^[0-9]{2}:[0-9]{2} ]]; then
        # Ini adalah line test berikutnya, jangan tambahkan
        if [[ $line =~ \[E\] ]]; then
          # Jika ada test sebelumnya, simpan terlebih dahulu
          if [ -n "$currentTestFile" ] && [ -n "$currentTestError" ]; then
            saveTestError "$outputDir" "$currentTestFile" "$currentTestError"
          fi
          
          currentTestFile=$(extractTestPath "$line")
          if [ -z "$currentTestFile" ]; then
            currentTestFile="unknown_test_$testCount"
          fi
          testCount=$((testCount + 1))
          currentTestError="$line"
        fi
      else
        currentTestError="$currentTestError"$'\n'"$line"
      fi
    fi
  done < "$logFile"
  
  # Simpan test terakhir
  if [ -n "$currentTestFile" ] && [ -n "$currentTestError" ]; then
    saveTestError "$outputDir" "$currentTestFile" "$currentTestError"
  fi
}

# Fungsi untuk menyimpan error ke file
saveTestError() {
  local outputDir=$1
  local testFile=$2
  local errorContent=$3
  
  # Convert test file path ke output file path
  # test/presentation/bloc/tv/tv_series_detail_bloc_test.dart -> test/presentation/bloc/tv/tv_series_detail_bloc_test.txt
  local outputFile="${outputDir}/${testFile%.dart}.txt"
  local outputFileDir=$(dirname "$outputFile")
  
  # Buat direktori jika belum ada
  mkdir -p "$outputFileDir"
  
  # Tulis error ke file
  {
    echo "$errorContent"
    echo "================================================================================"
  } >> "$outputFile"
  
  # Tulis juga ke main summary file
  {
    echo "$errorContent"
    echo "================================================================================"
  } >> "$outputDir/$FAILED_LOG_FILE"
}

runReport() {
  if [ -f "coverage/test.info" ] && ! [ "$TRAVIS" ]; then
      # Try to find genhtml in PATH or GENHTML environment variable
      GENHTML_PATH=$(command -v genhtml)
      
      if [ -z "$GENHTML_PATH" ] && [ -n "$GENHTML" ]; then
        GENHTML_PATH="$GENHTML"
      fi
      
      if [ -z "$GENHTML_PATH" ]; then
        echo "Warning: genhtml not found in PATH or GENHTML environment variable" | tee -a "$LOG_FILE"
        return
      fi

      "$GENHTML_PATH" coverage/test.info -o coverage --no-function-coverage --prefix $(pwd)

      if [ "$(uname)" == "Darwin" ]; then
        open coverage/index.html
      elif [ "$(uname)" == "MINGW64_NT" ] || [ "$(uname)" == "MSYS_NT" ]; then
        # Windows with Git Bash
        start "" coverage/index.html
      else
        start coverage/index.html
      fi
  fi
}

if ! [ -f "pubspec.yaml" ] || ! [ -d .git ]; then
  printf "\nError: not in root of repo\n"
  show_help
fi

case $1 in
--help)
  show_help
  ;;
*)
  currentDir=$(pwd)
  # Clear previous log file
  > "$currentDir/$LOG_FILE"
  echo "Test execution started at $(date)" >> "$currentDir/$LOG_FILE"
  
  # if no parameter passed
  if [ -z $1 ]; then
    if [ -d "coverage" ]; then
      rm -r coverage
    fi
    dirs=($(find . -maxdepth 2 -type d))
    for dir in "${dirs[@]}"; do
      runTests $dir $currentDir $currentDir
    done
  else
    if [[ -d "$1" ]]; then
      runTests $1 $currentDir $currentDir
    else
      printf "\nError: not a directory: $1\n"
      show_help
    fi
  fi
  
  # Extract failed tests
  echo ""
  echo "Extracting failed tests..."
  extractFailedTests "$currentDir/$LOG_FILE" "$currentDir/$FAILED_TESTS_DIR"
  echo "Failed tests summary saved to: $FAILED_TESTS_DIR/"
  echo ""
  
  # Tampilkan summary
  if [ -f "$currentDir/$FAILED_TESTS_DIR/$FAILED_LOG_FILE" ]; then
    echo "=== FAILED TESTS SUMMARY ==="
    cat "$currentDir/$FAILED_TESTS_DIR/$FAILED_LOG_FILE"
    echo ""
    echo "=== DETAILED FAILED TESTS BY FILE ==="
    find "$currentDir/$FAILED_TESTS_DIR" -name "*.txt" ! -name "$FAILED_LOG_FILE" -type f | sort | while read file; do
      echo ""
      echo "📄 File: $file"
      echo "---"
      cat "$file"
    done
  else
    echo "✓ No failed tests found!"
  fi
  
  runReport
  echo "Test execution completed at $(date)" >> "$currentDir/$LOG_FILE"
  ;;
esac

# Fail the build if there was an error
if [ "$error" = true ]; then
  exit -1
fi