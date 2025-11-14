part of 'tv_series_recommendations_bloc.dart';

abstract class TvSeriesRecommendationsEvent extends Equatable {
  const TvSeriesRecommendationsEvent();
}

class FetchTvSeriesRecommendations extends TvSeriesRecommendationsEvent {
  final int id;

  const FetchTvSeriesRecommendations(this.id);

  @override
  List<Object> get props => [id];
}