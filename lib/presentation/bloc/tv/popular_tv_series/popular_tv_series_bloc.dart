import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/tv/get_popular_tv_series.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTVSeries getPopularTvSeries;

  PopularTvSeriesBloc(this.getPopularTvSeries) : super(PopularTvSeriesLoading()) {
    on<FetchPopularTvSeries>(_onFetchPopularTvSeries);
  }

  Future<void> _onFetchPopularTvSeries(
    FetchPopularTvSeries event,
    Emitter<PopularTvSeriesState> emit,
  ) async {
    emit(PopularTvSeriesLoading());

    final result = await getPopularTvSeries.execute();

    result.fold(
      (failure) => emit(PopularTvSeriesError(failure.message)),
      (tvSeries) => emit(PopularTvSeriesLoaded(tvSeries)),
    );
  }
}