part of 'popular_movie_bloc.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieEmpty extends PopularMovieState {}

class PopularMovieHasData extends PopularMovieState {
  final List<Movie> result;

  const PopularMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}

class PopularMovieError extends PopularMovieState {
  final String message;

  const PopularMovieError(this.message);

  @override
  List<Object> get props => [message];
}
