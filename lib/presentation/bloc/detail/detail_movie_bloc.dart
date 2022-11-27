import 'package:core/features/movies/domain/entities/movie_detail.dart';
import 'package:core/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'detail_movie_event.dart';
part 'detail_movie_state.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail _getMovieDetail;

  DetailMovieBloc(this._getMovieDetail) : super(DetailMovieEmpty()) {
    on<FetchDetailMovie>((event, emit) async {
      emit(DetailMovieLoading());
      final int id = event.movieId;
      final result = await _getMovieDetail.execute(id);

      result.fold((l) => emit(DetailMovieError(l.message)),
          (r) => emit(DetailMovieHasData(r)));
    });
  }
}
