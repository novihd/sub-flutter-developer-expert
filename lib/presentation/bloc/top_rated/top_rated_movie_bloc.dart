import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies) : super(TopRatedMovieEmpty()) {
    on<FetchTopRatedMovie>(
      (event, emit) async {
        emit(TopRatedMovieLoading());
        final result = await _getTopRatedMovies.execute();
        result.fold((l) => emit(TopRatedMovieError(l.message)),
            (r) => emit(TopRatedMovieHasData(r)));
      },
    );
  }
}
