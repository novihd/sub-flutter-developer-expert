// ignore_for_file: prefer_typing_uninitialized_variables

part of 'detail_movie_bloc.dart';

abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchDetailMovie extends DetailMovieEvent {
  final movieId;

  const FetchDetailMovie(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
