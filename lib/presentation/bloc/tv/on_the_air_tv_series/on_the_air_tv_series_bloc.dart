import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/tv/get_on_the_air_tv_series.dart';

part 'on_the_air_tv_series_event.dart';
part 'on_the_air_tv_series_state.dart';

class OnTheAirTvSeriesBloc extends Bloc<OnTheAirTvSeriesEvent, OnTheAirTvSeriesState> {
  final GetOnTheAirTVSeries getOnTheAirTvSeries;

  OnTheAirTvSeriesBloc(this.getOnTheAirTvSeries) : super(OnTheAirTvSeriesLoading()) {
    on<FetchOnTheAirTvSeries>(_onFetchOnTheAirTvSeries);
  }

  Future<void> _onFetchOnTheAirTvSeries(
    FetchOnTheAirTvSeries event,
    Emitter<OnTheAirTvSeriesState> emit,
  ) async {
    emit(OnTheAirTvSeriesLoading());

    final result = await getOnTheAirTvSeries.execute();

    result.fold(
      (failure) => emit(OnTheAirTvSeriesError(failure.message)),
      (tvSeries) => emit(OnTheAirTvSeriesLoaded(tvSeries)),
    );
  }
}