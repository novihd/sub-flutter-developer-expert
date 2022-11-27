import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/recommendation/recommendation_movie_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late RecommendationMovieBloc popularMovieBloc;
  late MockGetMovieRecommendations mockRecommendationMovies;

  setUp(() {
    mockRecommendationMovies = MockGetMovieRecommendations();
    popularMovieBloc = RecommendationMovieBloc(mockRecommendationMovies);
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
  const idMovie = 557;

  blocTest<RecommendationMovieBloc, RecommendationMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockRecommendationMovies.execute(idMovie))
          .thenAnswer((_) async => Right(tMovieList));
      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationMovie(idMovie)),
    expect: () => [
      RecommendationMovieLoading(),
      RecommendationMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockRecommendationMovies.execute(idMovie));
    },
  );

  blocTest<RecommendationMovieBloc, RecommendationMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockRecommendationMovies.execute(idMovie))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationMovie(idMovie)),
    expect: () => [
      RecommendationMovieLoading(),
      const RecommendationMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockRecommendationMovies.execute(idMovie));
    },
  );
}
