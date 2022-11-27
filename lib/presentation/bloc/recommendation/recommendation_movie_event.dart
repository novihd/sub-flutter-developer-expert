// ignore_for_file: prefer_typing_uninitialized_variables

part of 'recommendation_movie_bloc.dart';

abstract class RecommendationMovieEvent extends Equatable {
  const RecommendationMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecommendationMovie extends RecommendationMovieEvent {
  final movieId;

  const FetchRecommendationMovie(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
