import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/entities/movie_detail.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:core/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:core/features/movies/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _statusWatchlistMovie;
  final RemoveWatchlist _removeWatchlistMovie;
  final SaveWatchlist _addWatchlistMovie;

  WatchlistMovieBloc(this._getWatchlistMovies, this._statusWatchlistMovie,
      this._removeWatchlistMovie, this._addWatchlistMovie)
      : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovie>(
      (event, emit) async {
        emit(WatchlistMovieLoading());
        final result = await _getWatchlistMovies.execute();
        result.fold(
            (l) => emit(WatchlistMovieError(l.message)),
            (r) => emit(
                r.isEmpty ? WatchlistMovieEmpty() : WatchlistMovieHasData(r)));
      },
    );
    on<AddWatchlistMovie>(
      (event, emit) async {
        emit(WatchlistMovieLoading());
        final result = await _addWatchlistMovie.execute(event.movie);
        result.fold((l) => emit(WatchlistMovieError(l.message)),
            (r) => emit(WatchlistMovieMessage(r)));
      },
    );
    on<RemoveWatchlistMovie>(
      (event, emit) async {
        emit(WatchlistMovieLoading());
        final result = await _removeWatchlistMovie.execute(event.movie);
        result.fold((l) => emit(WatchlistMovieError(l.message)),
            (r) => emit(WatchlistMovieMessage(r)));
      },
    );
    on<StatusWatchlistMovie>(
      (event, emit) async {
        final result = await _statusWatchlistMovie.execute(event.id);
        emit(WatchlistMovieIsAdded(result));
      },
    );
  }
}
