import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(this._getPopularMovies) : super(PopularMovieEmpty()) {
    on<FetchPopularMovie>((event, emit) async {
      emit(PopularMovieLoading());
      final result = await _getPopularMovies.execute();

      result.fold(
          (l) => emit(PopularMovieError(l.message)),
          (r) =>
              emit(r.isEmpty ? PopularMovieEmpty() : PopularMovieHasData(r)));
    });
  }
}
