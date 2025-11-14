import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/tv/tv_series_detail.dart';
import '../../../../domain/usecases/tv/get_tv_series_detail.dart';
import '../../../../domain/usecases/tv/get_watchlist_tv_series_status.dart';
import '../../../../domain/usecases/tv/save_watchlist_tv_series.dart';
import '../../../../domain/usecases/tv/remove_watchlist_tv_series.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTVSeriesDetail getTvSeriesDetail;
  final GetWatchListTVSeriesStatus getWatchlistTvSeriesStatus;
  final SaveWatchlistTVSeries saveWatchlistTvSeries;
  final RemoveWatchlistTVSeries removeWatchlistTvSeries;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getWatchlistTvSeriesStatus,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(TvSeriesDetailLoading()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<AddTvSeriesToWatchlist>(_onAddTvSeriesToWatchlist);
    on<RemoveTvSeriesFromWatchlist>(_onRemoveTvSeriesFromWatchlist);
    on<LoadTvSeriesWatchlistStatus>(_onLoadTvSeriesWatchlistStatus);
  }

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(TvSeriesDetailLoading());

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final watchlistStatus = await getWatchlistTvSeriesStatus.execute(event.id);

    detailResult.fold(
      (failure) => emit(TvSeriesDetailError(failure.message)),
      (tvSeries) => emit(TvSeriesDetailLoaded(tvSeries, isAddedToWatchlist: watchlistStatus)),
    );
  }

  Future<void> _onAddTvSeriesToWatchlist(
    AddTvSeriesToWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final currentState = state;
    
    final result = await saveWatchlistTvSeries.execute(event.tvSeries);

    await result.fold(
      (failure) async {
        if (currentState is TvSeriesDetailLoaded) {
          emit(TvSeriesWatchlistMessage(
            failure.message,
            tvSeries: currentState.tvSeries,
            isAddedToWatchlist: currentState.isAddedToWatchlist,
          ));
        } else {
          emit(TvSeriesDetailError(failure.message));
        }
      },
      (successMessage) async {
        if (currentState is TvSeriesDetailLoaded && !emit.isDone) {
          final updatedStatus = await getWatchlistTvSeriesStatus.execute(event.tvSeries.id);
          emit(TvSeriesDetailLoaded(
            currentState.tvSeries,
            isAddedToWatchlist: updatedStatus,
          ));
          if (!emit.isDone) {
            emit(TvSeriesWatchlistMessage(successMessage));
          }
        }
      },
    );
  }

  Future<void> _onRemoveTvSeriesFromWatchlist(
    RemoveTvSeriesFromWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final currentState = state;

    final result = await removeWatchlistTvSeries.execute(event.tvSeries);

    await result.fold(
      (failure) async {
        if (currentState is TvSeriesDetailLoaded) {
          emit(TvSeriesWatchlistMessage(
            failure.message,
            tvSeries: currentState.tvSeries,
            isAddedToWatchlist: currentState.isAddedToWatchlist,
          ));
        } else {
          emit(TvSeriesDetailError(failure.message));
        }
      },
      (successMessage) async {
        if (currentState is TvSeriesDetailLoaded && !emit.isDone) {
          final updatedStatus = await getWatchlistTvSeriesStatus.execute(event.tvSeries.id);
          emit(TvSeriesDetailLoaded(
            currentState.tvSeries,
            isAddedToWatchlist: updatedStatus,
          ));
          if (!emit.isDone) {
            emit(TvSeriesWatchlistMessage(successMessage));
          }
        }
      },
    );
  }

  Future<void> _onLoadTvSeriesWatchlistStatus(
    LoadTvSeriesWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final status = await getWatchlistTvSeriesStatus.execute(event.id);
    
    if (state is TvSeriesDetailLoaded) {
      emit((state as TvSeriesDetailLoaded).copyWith(isAddedToWatchlist: status));
    }
  }
}