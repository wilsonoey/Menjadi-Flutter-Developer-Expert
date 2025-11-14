part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {
  const MovieDetailEmpty();
}

class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final bool isAddedToWatchlist;

  const MovieDetailLoaded(this.movie, {required this.isAddedToWatchlist});

  MovieDetailLoaded copyWith({
    MovieDetail? movie,
    bool? isAddedToWatchlist,
  }) {
    return MovieDetailLoaded(
      movie ?? this.movie,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [movie, isAddedToWatchlist];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieWatchlistMessage extends MovieDetailState {
  final String message;
  final MovieDetail? movie;
  final bool? isAddedToWatchlist;

  const MovieWatchlistMessage(
    this.message, {
    this.movie,
    this.isAddedToWatchlist,
  });

  @override
  List<Object?> get props => [message, movie, isAddedToWatchlist];
}