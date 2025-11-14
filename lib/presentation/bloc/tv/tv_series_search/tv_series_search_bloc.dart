import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../domain/entities/tv/tv_series.dart';
import '../../../../domain/usecases/tv/search_tv_series.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTVSeries searchTvSeries;

  TvSeriesSearchBloc(this.searchTvSeries) : super(TvSeriesSearchLoading()) {
    on<OnTvSeriesQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onQueryChanged(
    OnTvSeriesQueryChanged event,
    Emitter<TvSeriesSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(TvSeriesSearchEmpty());
      return;
    }

    emit(TvSeriesSearchLoading());

    final result = await searchTvSeries.execute(query);

    result.fold(
      (failure) => emit(TvSeriesSearchError(failure.message)),
      (tvSeries) => emit(TvSeriesSearchLoaded(tvSeries)),
    );
  }
}