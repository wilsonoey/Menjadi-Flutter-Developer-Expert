part of 'on_the_air_tv_series_bloc.dart';

abstract class OnTheAirTvSeriesState extends Equatable {
  const OnTheAirTvSeriesState();

  @override
  List<Object> get props => [];
}

class OnTheAirTvSeriesEmpty extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesLoading extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesLoaded extends OnTheAirTvSeriesState {
  final List<TVSeries> tvSeries;

  const OnTheAirTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class OnTheAirTvSeriesError extends OnTheAirTvSeriesState {
  final String message;

  const OnTheAirTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}