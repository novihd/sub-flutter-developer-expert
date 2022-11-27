part of 'watchlist_series_bloc.dart';

abstract class WatchlistSeriesState extends Equatable {
  const WatchlistSeriesState();
  @override
  List<Object?> get props => [];
}

class WatchlistSeriesLoading extends WatchlistSeriesState {}

class WatchlistSeriesEmpty extends WatchlistSeriesState {}

class WatchlistSeriesHasData extends WatchlistSeriesState {
  final List<Series> result;

  const WatchlistSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class WatchlistSeriesError extends WatchlistSeriesState {
  final String message;

  const WatchlistSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistSeriesIsAdded extends WatchlistSeriesState {
  final bool isAdded;

  const WatchlistSeriesIsAdded(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}

class WatchlistSeriesMessage extends WatchlistSeriesState {
  final String message;

  const WatchlistSeriesMessage(this.message);

  @override
  List<Object?> get props => [message];
}
