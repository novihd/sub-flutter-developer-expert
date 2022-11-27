import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/entities/movie_detail.dart';
import 'package:core/features/series/domain/entities/genre.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/detail/detail_movie_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late DetailMovieBloc detailMovieBloc;
  late MockGetMovieDetail mockDetailMovies;

  setUp(() {
    mockDetailMovies = MockGetMovieDetail();
    detailMovieBloc = DetailMovieBloc(mockDetailMovies);
  });

  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om',
    genres: [Genre(id: 14, name: 'Action')],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  const idMovie = 557;

  blocTest<DetailMovieBloc, DetailMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockDetailMovies.execute(idMovie))
          .thenAnswer((_) async => const Right(tMovieDetail));
      return detailMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailMovie(idMovie)),
    expect: () => [
      DetailMovieLoading(),
      const DetailMovieHasData(tMovieDetail),
    ],
    verify: (bloc) {
      verify(mockDetailMovies.execute(idMovie));
    },
  );

  blocTest<DetailMovieBloc, DetailMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockDetailMovies.execute(idMovie))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailMovie(idMovie)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailMovieLoading(),
      const DetailMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockDetailMovies.execute(idMovie));
    },
  );
}
