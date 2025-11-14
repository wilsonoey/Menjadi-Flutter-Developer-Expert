import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/tv/get_top_rated_tv_series.dart';

part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTVSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this.getTopRatedTvSeries) : super(TopRatedTvSeriesLoading()) {
    on<FetchTopRatedTvSeries>(_onFetchTopRatedTvSeries);
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeries event,
    Emitter<TopRatedTvSeriesState> emit,
  ) async {
    emit(TopRatedTvSeriesLoading());

    final result = await getTopRatedTvSeries.execute();

    result.fold(
      (failure) => emit(TopRatedTvSeriesError(failure.message)),
      (tvSeries) => emit(TopRatedTvSeriesLoaded(tvSeries)),
    );
  }
}