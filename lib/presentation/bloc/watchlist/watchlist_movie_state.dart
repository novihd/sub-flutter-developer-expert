part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();
  @override
  List<Object?> get props => [];
}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieEmpty extends WatchlistMovieState {}

class WatchlistMovieHasData extends WatchlistMovieState {
  final List<Movie> result;

  const WatchlistMovieHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistMovieIsAdded extends WatchlistMovieState {
  final bool isAdded;

  const WatchlistMovieIsAdded(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}

class WatchlistMovieMessage extends WatchlistMovieState {
  final String message;

  const WatchlistMovieMessage(this.message);

  @override
  List<Object?> get props => [message];
}
