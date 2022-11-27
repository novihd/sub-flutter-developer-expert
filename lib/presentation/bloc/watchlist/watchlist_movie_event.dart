part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistMovie extends WatchlistMovieEvent {
  const FetchWatchlistMovie();

  @override
  List<Object?> get props => [];
}

class StatusWatchlistMovie extends WatchlistMovieEvent {
  final int id;
  const StatusWatchlistMovie(this.id);

  @override
  List<Object?> get props => [];
}

class AddWatchlistMovie extends WatchlistMovieEvent {
  final MovieDetail movie;
  const AddWatchlistMovie(this.movie);

  @override
  List<Object?> get props => [];
}

class RemoveWatchlistMovie extends WatchlistMovieEvent {
  final MovieDetail movie;
  const RemoveWatchlistMovie(this.movie);

  @override
  List<Object?> get props => [];
}
