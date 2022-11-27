import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:core/features/series/domain/usecases/get_watchlist_series.dart';
import 'package:core/features/series/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/features/series/domain/usecases/remove_watchlist_series.dart';
import 'package:core/features/series/domain/usecases/save_watchlist_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_series_event.dart';
part 'watchlist_series_state.dart';

class WatchlistSeriesBloc
    extends Bloc<WatchlistSeriesEvent, WatchlistSeriesState> {
  final GetWatchlistSeries _getWatchlistSeries;
  final GetWatchlistSeriesStatus _statusWatchlistSeries;
  final RemoveWatchlistSeries _removeWatchlistSeries;
  final SaveWatchlistSeries _addWatchlistSeries;

  WatchlistSeriesBloc(this._getWatchlistSeries, this._statusWatchlistSeries,
      this._removeWatchlistSeries, this._addWatchlistSeries)
      : super(WatchlistSeriesEmpty()) {
    on<FetchWatchlistSeries>(
      (event, emit) async {
        emit(WatchlistSeriesLoading());
        final result = await _getWatchlistSeries.execute();
        result.fold(
            (l) => emit(WatchlistSeriesError(l.message)),
            (r) => emit(r.isEmpty
                ? WatchlistSeriesEmpty()
                : WatchlistSeriesHasData(r)));
      },
    );
    on<AddWatchlistSeries>(
      (event, emit) async {
        emit(WatchlistSeriesLoading());
        final result = await _addWatchlistSeries.execute(event.series);
        result.fold((l) => emit(WatchlistSeriesError(l.message)),
            (r) => emit(WatchlistSeriesMessage(r)));
      },
    );
    on<RemovedWatchlistSeries>(
      (event, emit) async {
        emit(WatchlistSeriesLoading());
        final result = await _removeWatchlistSeries.execute(event.series);
        result.fold((l) => emit(WatchlistSeriesError(l.message)),
            (r) => emit(WatchlistSeriesMessage(r)));
      },
    );
    on<StatusWatchlistSeries>(
      (event, emit) async {
        final result = await _statusWatchlistSeries.execute(event.id);
        emit(WatchlistSeriesIsAdded(result));
      },
    );
  }
}
