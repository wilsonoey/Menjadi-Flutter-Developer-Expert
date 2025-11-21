import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/movie/movie_detail.dart';
import '../../../../domain/usecases/movie/get_movie_detail.dart';
import '../../../../domain/usecases/movie/get_watchlist_status.dart';
import '../../../../domain/usecases/movie/save_watchlist.dart';
import '../../../../domain/usecases/movie/remove_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailLoading()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveMovieFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(const MovieDetailLoading());

    final detailResult = await getMovieDetail.execute(event.id);
    final watchlistStatus = await getWatchListStatus.execute(event.id);

    detailResult.fold(
      (failure) => emit(MovieDetailError(failure.message)),
      (movie) => emit(MovieDetailLoaded(movie, isAddedToWatchlist: watchlistStatus)),
    );
  }

  Future<void> _onAddMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final currentState = state;
    
    final result = await saveWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        // Emit error if no loaded state, otherwise emit message with current state
        if (currentState is MovieDetailLoaded) {
          emit(MovieWatchlistMessage(
            failure.message,
            movie: currentState.movie,
            isAddedToWatchlist: currentState.isAddedToWatchlist,
          ));
        } else {
          emit(MovieDetailError(failure.message));
        }
      },
      (successMessage) async {
        // Update watchlist status
        final updatedStatus = await getWatchListStatus.execute(event.movie.id);
        
        // Emit loaded state dengan status terbaru
        // Hapus pengecekan currentState is MovieDetailLoaded
        // Gunakan event.movie agar state tetap terupdate meskipun state sebelumnya adalah MovieWatchlistMessage
        emit(MovieDetailLoaded(
          event.movie,
          isAddedToWatchlist: updatedStatus,
        ));
        
        // Kemudian emit message tanpa data
        emit(MovieWatchlistMessage(successMessage));
      },
    );
  }

  Future<void> _onRemoveMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final currentState = state;
    
    final result = await removeWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        // Emit error if no loaded state, otherwise emit message with current state
        if (currentState is MovieDetailLoaded) {
          emit(MovieWatchlistMessage(
            failure.message,
            movie: currentState.movie,
            isAddedToWatchlist: currentState.isAddedToWatchlist,
          ));
        } else {
          emit(MovieDetailError(failure.message));
        }
      },
      (successMessage) async {
        // Update watchlist status
        final updatedStatus = await getWatchListStatus.execute(event.movie.id);
        
        // Emit loaded state dengan status terbaru
        // Hapus pengecekan currentState is MovieDetailLoaded
        // Gunakan event.movie agar state tetap terupdate meskipun state sebelumnya adalah MovieWatchlistMessage
        emit(MovieDetailLoaded(
          event.movie,
          isAddedToWatchlist: updatedStatus,
        ));
        
        // Kemudian emit message tanpa data
        emit(MovieWatchlistMessage(successMessage));
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final status = await getWatchListStatus.execute(event.id);
    
    if (state is MovieDetailLoaded) {
      emit((state as MovieDetailLoaded).copyWith(isAddedToWatchlist: status));
    }
  }
}