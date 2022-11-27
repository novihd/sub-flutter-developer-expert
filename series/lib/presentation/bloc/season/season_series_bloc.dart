import 'package:core/features/series/domain/entities/season_detail.dart';
import 'package:core/features/series/domain/usecases/get_series_season.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'season_series_event.dart';
part 'season_series_state.dart';

class SeasonSeriesBloc extends Bloc<SeasonSeriesEvent, SeasonSeriesState> {
  final GetSeriesSeason _getSeasonSeries;

  SeasonSeriesBloc(this._getSeasonSeries) : super(SeasonSeriesEmpty()) {
    on<FetchSeasonSeries>((event, emit) async {
      emit(SeasonSeriesLoading());
      final result =
          await _getSeasonSeries.execute(event.tvId, event.numberSeason);

      result.fold(
          (l) => emit(SeasonSeriesError(l.message)),
          (r) =>
              emit(r.isEmpty ? SeasonSeriesEmpty() : SeasonSeriesHasData(r)));
    });
  }
}
