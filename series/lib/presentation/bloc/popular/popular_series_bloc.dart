import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/usecases/get_popular_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_series_event.dart';
part 'popular_series_state.dart';

class PopularSeriesBloc extends Bloc<PopularSeriesEvent, PopularSeriesState> {
  final GetPopularSeries _getPopularSeries;

  PopularSeriesBloc(this._getPopularSeries) : super(PopularSeriesEmpty()) {
    on<FetchPopularSeries>((event, emit) async {
      emit(PopularSeriesLoading());
      final result = await _getPopularSeries.execute();

      result.fold(
          (l) => emit(PopularSeriesError(l.message)),
          (r) =>
              emit(r.isEmpty ? PopularSeriesEmpty() : PopularSeriesHasData(r)));
    });
  }
}
