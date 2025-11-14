import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/tv/tv_series.dart';
import '../../../../domain/usecases/tv/get_tv_series_recommendations.dart';

part 'tv_series_recommendations_event.dart';
part 'tv_series_recommendations_state.dart';

class TvSeriesRecommendationsBloc extends Bloc<TvSeriesRecommendationsEvent, TvSeriesRecommendationsState> {
  final GetTVSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesRecommendationsBloc(this.getTvSeriesRecommendations) : super(TvSeriesRecommendationsLoading()) {
    on<FetchTvSeriesRecommendations>(_onFetchTvSeriesRecommendations);
  }

  Future<void> _onFetchTvSeriesRecommendations(
    FetchTvSeriesRecommendations event,
    Emitter<TvSeriesRecommendationsState> emit,
  ) async {
    emit(TvSeriesRecommendationsLoading());

    final result = await getTvSeriesRecommendations.execute(event.id);

    result.fold(
      (failure) => emit(TvSeriesRecommendationsError(failure.message)),
      (tvSeries) => emit(TvSeriesRecommendationsLoaded(tvSeries)),
    );
  }
}