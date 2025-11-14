import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/tv/tv_series.dart';
import '../../../../domain/usecases/tv/get_watchlist_tv_series.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTVSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this.getWatchlistTvSeries) : super(WatchlistTvSeriesLoading()) {
    on<FetchWatchlistTvSeries>(_onFetchWatchlistTvSeries);
  }

  Future<void> _onFetchWatchlistTvSeries(
    FetchWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(WatchlistTvSeriesLoading());

    final result = await getWatchlistTvSeries.execute();

    result.fold(
      (failure) => emit(WatchlistTvSeriesError(failure.message)),
      (tvSeries) => emit(WatchlistTvSeriesLoaded(tvSeries)),
    );
  }
}