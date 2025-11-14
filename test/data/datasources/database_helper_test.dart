import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie/movie_table.dart';
import 'package:ditonton/data/models/tv/tv_series_table.dart';
import 'dart:io';
import 'package:path/path.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper', () {
    late DatabaseHelper databaseHelper;

    setUp(() async {
      // Reset singleton before each test
      DatabaseHelper.resetInstance();
      databaseHelper = DatabaseHelper();
    });

    tearDown(() async {
      // Close database connection
      final db = await databaseHelper.database;
      await db?.close();
      
      // Clean up database file
      try {
        final dbPath = await getDatabasesPath();
        final file = File(join(dbPath, 'ditonton.db'));
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
    });

    group('Singleton Pattern', () {
      test('factory constructor returns same instance', () {
        final instance1 = DatabaseHelper();
        final instance2 = DatabaseHelper();
        expect(identical(instance1, instance2), true);
      });
    });

    group('Movie Watchlist Operations', () {
      late MovieTable movieTable;

      setUp(() {
        movieTable = MovieTable(
          id: 1,
          title: 'Test Movie',
          overview: 'Test Overview',
          posterPath: '/test.jpg',
        );
      });

      test('insertWatchlist should return row id', () async {
        final result = await databaseHelper.insertWatchlist(movieTable);
        expect(result, isA<int>());
        expect(result, greaterThan(0));
      });

      test('getMovieById should return movie when exists', () async {
        await databaseHelper.insertWatchlist(movieTable);
        final result = await databaseHelper.getMovieById(1);
        
        expect(result, isNotNull);
        expect(result!['id'], 1);
        expect(result['title'], 'Test Movie');
        expect(result['overview'], 'Test Overview');
        expect(result['posterPath'], '/test.jpg');
      });

      test('getMovieById should return null when movie does not exist', () async {
        final result = await databaseHelper.getMovieById(999);
        expect(result, isNull);
      });

      test('getWatchlistMovies should return list of movies', () async {
        await databaseHelper.insertWatchlist(movieTable);
        
        final movie2 = MovieTable(
          id: 2,
          title: 'Test Movie 2',
          overview: 'Test Overview 2',
          posterPath: '/test2.jpg',
        );
        await databaseHelper.insertWatchlist(movie2);

        final result = await databaseHelper.getWatchlistMovies();
        
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 2);
      });

      test('getWatchlistMovies should return empty list when no movies', () async {
        final result = await databaseHelper.getWatchlistMovies();
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 0);
      });

      test('removeWatchlist should delete movie', () async {
        await databaseHelper.insertWatchlist(movieTable);
        var result = await databaseHelper.getMovieById(1);
        expect(result, isNotNull);

        await databaseHelper.removeWatchlist(movieTable);
        result = await databaseHelper.getMovieById(1);
        expect(result, isNull);
      });

      test('removeWatchlist should return affected rows', () async {
        await databaseHelper.insertWatchlist(movieTable);
        final result = await databaseHelper.removeWatchlist(movieTable);
        expect(result, 1);
      });
    });

    group('TV Series Watchlist Operations', () {
      late TVSeriesTable tvSeriesTable;

      setUp(() {
        tvSeriesTable = TVSeriesTable(
          id: 1,
          name: 'Test TV Series',
          overview: 'Test Overview',
          posterPath: '/test.jpg',
        );
      });

      test('insertTVSeriesWatchlist should return row id', () async {
        final result = await databaseHelper.insertTVSeriesWatchlist(tvSeriesTable);
        expect(result, isA<int>());
        expect(result, greaterThan(0));
      });

      test('getTVSeriesById should return tv series when exists', () async {
        await databaseHelper.insertTVSeriesWatchlist(tvSeriesTable);
        final result = await databaseHelper.getTVSeriesById(1);
        
        expect(result, isNotNull);
        expect(result!['id'], 1);
        expect(result['name'], 'Test TV Series');
        expect(result['overview'], 'Test Overview');
        expect(result['posterPath'], '/test.jpg');
      });

      test('getTVSeriesById should return null when tv series does not exist', () async {
        final result = await databaseHelper.getTVSeriesById(999);
        expect(result, isNull);
      });

      test('getWatchlistTVSeries should return list of tv series', () async {
        await databaseHelper.insertTVSeriesWatchlist(tvSeriesTable);
        
        final tvSeries2 = TVSeriesTable(
          id: 2,
          name: 'Test TV Series 2',
          overview: 'Test Overview 2',
          posterPath: '/test2.jpg',
        );
        await databaseHelper.insertTVSeriesWatchlist(tvSeries2);

        final result = await databaseHelper.getWatchlistTVSeries();
        
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 2);
      });

      test('getWatchlistTVSeries should return empty list when no tv series', () async {
        final result = await databaseHelper.getWatchlistTVSeries();
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 0);
      });

      test('removeTVSeriesWatchlist should delete tv series', () async {
        await databaseHelper.insertTVSeriesWatchlist(tvSeriesTable);
        var result = await databaseHelper.getTVSeriesById(1);
        expect(result, isNotNull);

        await databaseHelper.removeTVSeriesWatchlist(tvSeriesTable);
        result = await databaseHelper.getTVSeriesById(1);
        expect(result, isNull);
      });

      test('removeTVSeriesWatchlist should return affected rows', () async {
        await databaseHelper.insertTVSeriesWatchlist(tvSeriesTable);
        final result = await databaseHelper.removeTVSeriesWatchlist(tvSeriesTable);
        expect(result, 1);
      });
    });

    group('Database Initialization', () {
      test('database getter should initialize database lazily', () async {
        final db = await databaseHelper.database;
        
        expect(db, isNotNull);
        expect(db!.isOpen, true);
      });

      test('database getter should return same instance on multiple calls', () async {
        final db1 = await databaseHelper.database;
        final db2 = await databaseHelper.database;
        
        expect(identical(db1, db2), true);
      });
    });
  });
}