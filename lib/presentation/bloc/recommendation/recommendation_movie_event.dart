part of 'recommendation_movie_bloc.dart';

abstract class RecommendationMovieEvent extends Equatable {
  const RecommendationMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecommendationMovie extends RecommendationMovieEvent {
  final idMovie;

  const FetchRecommendationMovie(this.idMovie);

  @override
  List<Object?> get props => [idMovie];
}
