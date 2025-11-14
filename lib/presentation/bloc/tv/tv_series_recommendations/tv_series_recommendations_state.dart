part of 'tv_series_recommendations_bloc.dart';

abstract class TvSeriesRecommendationsState extends Equatable {
  const TvSeriesRecommendationsState();

  @override
  List<Object> get props => [];
}

class TvSeriesRecommendationsEmpty extends TvSeriesRecommendationsState {}

class TvSeriesRecommendationsLoading extends TvSeriesRecommendationsState {}

class TvSeriesRecommendationsLoaded extends TvSeriesRecommendationsState {
  final List<TVSeries> tvSeries;

  const TvSeriesRecommendationsLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesRecommendationsError extends TvSeriesRecommendationsState {
  final String message;

  const TvSeriesRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}