import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/usecases/get_series_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recommendation_series_event.dart';
part 'recommendation_series_state.dart';

class RecommendationSeriesBloc
    extends Bloc<RecommendationSeriesEvent, RecommendationSeriesState> {
  final GetSeriesRecommendations _getSeriesRecommendations;

  RecommendationSeriesBloc(this._getSeriesRecommendations)
      : super(RecommendationSeriesEmpty()) {
    on<FetchRecommendationSeries>(
      (event, emit) async {
        final int id = int.parse(event.seriesId.toString());
        emit(RecommendationSeriesLoading());
        final result = await _getSeriesRecommendations.execute(id);
        result.fold(
            (l) => emit(RecommendationSeriesError(l.message)),
            (r) => emit(r.isEmpty
                ? RecommendationSeriesEmpty()
                : RecommendationSeriesHasData(r)));
      },
    );
  }
}
