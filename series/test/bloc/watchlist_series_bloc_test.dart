import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/genre.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:series/presentation/bloc/watchlist/watchlist_series_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late WatchlistSeriesBloc nowPlayingSeriesBloc;
  late MockGetWatchlistSeries mockWatchlistSeries;
  late MockSaveWatchlistSeries mockAddWatchlistSeries;
  late MockRemoveWatchlistSeries mockRemoveWatchlistSeries;
  late MockGetWatchlistSeriesStatus mockGetWatchListSeriesStatus;

  setUp(() {
    mockWatchlistSeries = MockGetWatchlistSeries();
    mockAddWatchlistSeries = MockSaveWatchlistSeries();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    mockGetWatchListSeriesStatus = MockGetWatchlistSeriesStatus();
    nowPlayingSeriesBloc = WatchlistSeriesBloc(
        mockWatchlistSeries,
        mockGetWatchListSeriesStatus,
        mockRemoveWatchlistSeries,
        mockAddWatchlistSeries);
  });

  final tSeriesModel = Series(
      posterPath: "/rweIrveL43TaxUN0akQEaAXL6x0.jpg",
      popularity: 2106.129,
      id: 1402,
      backdropPath: "/zaulpwl355dlKkvtAiSBE5LaoWA.jpg",
      voteAverage: 8.1,
      overview:
          "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
      firstAirDate: '2010-10-31',
      originCountry: const ["US"],
      originalLanguage: "en",
      genreIds: const [10759, 18, 10765],
      voteCount: 14017,
      name: "The Walking Dead",
      originalName: "The Walking Dead");

  final tSeriesDetail = SeriesDetail(
      backdropPath: '/zaulpwl355dlKkvtAiSBE5LaoWA',
      episodeRunTime: const [1, 2],
      firstAirDate: '2010-10-31',
      genres: const [Genre(id: 1, name: 'Action')],
      homepage: 'homepage',
      id: 1402,
      languages: const ['en'],
      lastAirDate: 'lastAirDate',
      name: 'The Walking Dead',
      nextEpisodeToAir: null,
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originalName: 'The Walking Dead',
      overview:
          "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
      popularity: 2106.129,
      posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0',
      seasons: null,
      voteAverage: 8.1,
      voteCount: 14017);

  final tSeriesList = <Series>[tSeriesModel];
  const idSeries = 557;

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockWatchlistSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistSeries()),
    expect: () => [
      WatchlistSeriesLoading(),
      WatchlistSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockWatchlistSeries.execute());
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockWatchlistSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchWatchlistSeries()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistSeriesLoading(),
      const WatchlistSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockWatchlistSeries.execute());
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Message] when data is removed successfully',
    build: () {
      when(mockRemoveWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => const Right(removedFromWatchlistMessage));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(RemovedWatchlistSeries(tSeriesDetail)),
    expect: () => [
      WatchlistSeriesLoading(),
      const WatchlistSeriesMessage(removedFromWatchlistMessage),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistSeries.execute(tSeriesDetail));
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Error] when data is removed unsuccessfull',
    build: () {
      when(mockRemoveWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(RemovedWatchlistSeries(tSeriesDetail)),
    expect: () => [
      WatchlistSeriesLoading(),
      const WatchlistSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistSeries.execute(tSeriesDetail));
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Message] when data is added successfully',
    build: () {
      when(mockAddWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => const Right(addedToWatchlistMessage));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(AddWatchlistSeries(tSeriesDetail)),
    expect: () => [
      WatchlistSeriesLoading(),
      const WatchlistSeriesMessage(addedToWatchlistMessage),
    ],
    verify: (bloc) {
      verify(mockAddWatchlistSeries.execute(tSeriesDetail));
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit [Loading, Error] when data is added unsuccessfull',
    build: () {
      when(mockAddWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(AddWatchlistSeries(tSeriesDetail)),
    expect: () => [
      WatchlistSeriesLoading(),
      const WatchlistSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockAddWatchlistSeries.execute(tSeriesDetail));
    },
  );

  blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
    'Should emit status watchlist series',
    build: () {
      when(mockGetWatchListSeriesStatus.execute(idSeries))
          .thenAnswer((_) async => true);
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(const StatusWatchlistSeries(idSeries)),
    expect: () => [
      const WatchlistSeriesIsAdded(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListSeriesStatus.execute(idSeries));
    },
  );
}
