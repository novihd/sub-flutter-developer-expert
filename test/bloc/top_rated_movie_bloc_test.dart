import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_movie_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late TopRatedMovieBloc topRatedMovieBloc;
  late MockGetTopRatedMovies mockTopRatedMovies;

  setUp(() {
    mockTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieBloc = TopRatedMovieBloc(mockTopRatedMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedMovie()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieLoading(),
      const TopRatedMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockTopRatedMovies.execute());
    },
  );
}
