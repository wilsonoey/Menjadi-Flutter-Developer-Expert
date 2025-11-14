part of 'on_the_air_tv_series_bloc.dart';

abstract class OnTheAirTvSeriesEvent extends Equatable {
  const OnTheAirTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirTvSeries extends OnTheAirTvSeriesEvent {}