part of 'watchlist_series_bloc.dart';

abstract class WatchlistSeriesEvent extends Equatable {
  const WatchlistSeriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistSeries extends WatchlistSeriesEvent {
  const FetchWatchlistSeries();

  @override
  List<Object?> get props => [];
}

class StatusWatchlistSeries extends WatchlistSeriesEvent {
  final int id;
  const StatusWatchlistSeries(this.id);

  @override
  List<Object?> get props => [];
}

class AddWatchlistSeries extends WatchlistSeriesEvent {
  final SeriesDetail series;
  const AddWatchlistSeries(this.series);

  @override
  List<Object?> get props => [];
}

class RemovedWatchlistSeries extends WatchlistSeriesEvent {
  final SeriesDetail series;
  const RemovedWatchlistSeries(this.series);

  @override
  List<Object?> get props => [];
}
