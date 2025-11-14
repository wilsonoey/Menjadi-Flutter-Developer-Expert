part of 'tv_series_search_bloc.dart';

abstract class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();
}

class OnTvSeriesQueryChanged extends TvSeriesSearchEvent {
  final String query;

  const OnTvSeriesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}