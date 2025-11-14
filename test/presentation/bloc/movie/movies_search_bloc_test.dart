import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/movie_search_bloc.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import 'movies_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc movieSearchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(mockSearchMovies);
  });

  tearDown(() {
    movieSearchBloc.close();
  });

  group('MovieSearchBloc', () {
    test('initial state is MovieSearchLoading', () {
      expect(movieSearchBloc.state, isA<MovieSearchLoading>());
    });

      blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [MovieSearchLoading, MovieSearchLoaded] when SearchMoviesEvent is added',
      build: () {
        when(mockSearchMovies.execute(any))
            .thenAnswer((_) async => Right(testMovieList));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged('spider')),
        wait: const Duration(milliseconds: 500),
        expect: () => [
        MovieSearchLoading(),
        MovieSearchLoaded(testMovieList),
        ],
      );

      blocTest<MovieSearchBloc, MovieSearchState>(
        'emits [MovieSearchLoading, MovieSearchError] when search fails',
      build: () {
        when(mockSearchMovies.execute(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged('test')),
        wait: const Duration(milliseconds: 500),
        expect: () => [
        MovieSearchLoading(),
          isA<MovieSearchError>(),
        ],
      );

      blocTest<MovieSearchBloc, MovieSearchState>(
      'emits MovieSearchEmpty when query is empty',
      build: () => movieSearchBloc,
      act: (bloc) => bloc.add(const OnQueryChanged('')),
        wait: const Duration(milliseconds: 500),
        expect: () => [
        MovieSearchEmpty(),
      ],
    );
  });
}