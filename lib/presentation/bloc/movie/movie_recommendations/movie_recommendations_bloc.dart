import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/movie/movie.dart';
import '../../../../domain/usecases/movie/get_movie_recommendations.dart';

part 'movie_recommendations_event.dart';
part 'movie_recommendations_state.dart';

class MovieRecommendationsBloc extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationsBloc(this.getMovieRecommendations) : super(MovieRecommendationsLoading()) {
    on<FetchMovieRecommendations>(_onFetchMovieRecommendations);
  }

  Future<void> _onFetchMovieRecommendations(
    FetchMovieRecommendations event,
    Emitter<MovieRecommendationsState> emit,
  ) async {
    emit(MovieRecommendationsLoading());

    final result = await getMovieRecommendations.execute(event.id);

    result.fold(
      (failure) => emit(MovieRecommendationsError(failure.message)),
      (movies) => emit(MovieRecommendationsLoaded(movies)),
    );
  }
}