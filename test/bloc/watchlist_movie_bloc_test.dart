import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/entities/movie_detail.dart';
import 'package:core/features/series/domain/entities/genre.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movie_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late WatchlistMovieBloc nowPlayingMovieBloc;
  late MockGetWatchlistMovies mockWatchlistMovies;
  late MockSaveWatchlist mockAddWatchlistMovie;
  late MockRemoveWatchlist mockRemoveWatchlistMovie;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockWatchlistMovies = MockGetWatchlistMovies();
    mockAddWatchlistMovie = MockSaveWatchlist();
    mockRemoveWatchlistMovie = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    nowPlayingMovieBloc = WatchlistMovieBloc(
        mockWatchlistMovies,
        mockGetWatchListStatus,
        mockRemoveWatchlistMovie,
        mockAddWatchlistMovie);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14],
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
  final tMovieList = <Movie>[tMovieModel];
  const idMovie = 557;

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistMovie()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Message] when data is removed successfully',
    build: () {
      when(mockRemoveWatchlistMovie.execute(tMovieDetail))
          .thenAnswer((_) async => const Right(removedFromWatchlistMessage));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(const RemoveWatchlistMovie(tMovieDetail)),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieMessage(removedFromWatchlistMessage),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovie.execute(tMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Error] when data is removed unsuccessfull',
    build: () {
      when(mockRemoveWatchlistMovie.execute(tMovieDetail))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(const RemoveWatchlistMovie(tMovieDetail)),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovie.execute(tMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Message] when data is added successfully',
    build: () {
      when(mockAddWatchlistMovie.execute(tMovieDetail))
          .thenAnswer((_) async => const Right(addedToWatchlistMessage));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(const AddWatchlistMovie(tMovieDetail)),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieMessage(addedToWatchlistMessage),
    ],
    verify: (bloc) {
      verify(mockAddWatchlistMovie.execute(tMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Error] when data is added unsuccessfull',
    build: () {
      when(mockAddWatchlistMovie.execute(tMovieDetail))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(const AddWatchlistMovie(tMovieDetail)),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockAddWatchlistMovie.execute(tMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit status watchlist movie',
    build: () {
      when(mockGetWatchListStatus.execute(idMovie))
          .thenAnswer((_) async => true);
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(const StatusWatchlistMovie(idMovie)),
    expect: () => [
      const WatchlistMovieIsAdded(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(idMovie));
    },
  );
}
