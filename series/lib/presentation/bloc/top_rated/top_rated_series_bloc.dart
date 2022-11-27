import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/usecases/get_top_rated_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_series_event.dart';
part 'top_rated_series_state.dart';

class TopRatedSeriesBloc
    extends Bloc<TopRatedSeriesEvent, TopRatedSeriesState> {
  final GetTopRatedSeries _getTopRatedSeriess;

  TopRatedSeriesBloc(this._getTopRatedSeriess) : super(TopRatedSeriesEmpty()) {
    on<FetchTopRatedSeries>(
      (event, emit) async {
        emit(TopRatedSeriesLoading());
        final result = await _getTopRatedSeriess.execute();
        result.fold(
            (l) => emit(TopRatedSeriesError(l.message)),
            (r) => emit(
                r.isEmpty ? TopRatedSeriesEmpty() : TopRatedSeriesHasData(r)));
      },
    );
  }
}
