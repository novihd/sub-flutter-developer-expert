import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recommendation_movie_event.dart';
part 'recommendation_movie_state.dart';

class RecommendationMovieBloc
    extends Bloc<RecommendationMovieEvent, RecommendationMovieState> {
  final GetMovieRecommendations _getMovieRecommendations;

  RecommendationMovieBloc(this._getMovieRecommendations)
      : super(RecommendationMovieEmpty()) {
    on<FetchRecommendationMovie>(
      (event, emit) async {
        final int id = int.parse(event.movieId.toString());
        emit(RecommendationMovieLoading());
        final result = await _getMovieRecommendations.execute(id);
        result.fold((l) => emit(RecommendationMovieError(l.message)),
            (r) => emit(RecommendationMovieHasData(r)));
      },
    );
  }
}
