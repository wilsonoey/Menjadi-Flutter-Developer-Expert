part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object?> get props => [];
}

class TvSeriesDetailEmpty extends TvSeriesDetailState {
  const TvSeriesDetailEmpty();
}

class TvSeriesDetailLoading extends TvSeriesDetailState {
  const TvSeriesDetailLoading();
}

class TvSeriesDetailLoaded extends TvSeriesDetailState {
  final TVSeriesDetail tvSeries;
  final bool isAddedToWatchlist;

  const TvSeriesDetailLoaded(this.tvSeries, {required this.isAddedToWatchlist});

  TvSeriesDetailLoaded copyWith({
    TVSeriesDetail? tvSeries,
    bool? isAddedToWatchlist,
  }) {
    return TvSeriesDetailLoaded(
      tvSeries ?? this.tvSeries,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [tvSeries, isAddedToWatchlist];
}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  const TvSeriesDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvSeriesWatchlistMessage extends TvSeriesDetailState {
  final String message;
  final TVSeriesDetail? tvSeries;
  final bool? isAddedToWatchlist;

  const TvSeriesWatchlistMessage(
    this.message, {
      this.tvSeries,
      this.isAddedToWatchlist
    }
  );

  @override
  List<Object?> get props => [message, tvSeries, isAddedToWatchlist];
}