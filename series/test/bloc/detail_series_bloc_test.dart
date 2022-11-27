import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/genre.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:series/presentation/bloc/detail/detail_series_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late DetailSeriesBloc detailSeriesBloc;
  late MockGetSeriesDetail mockDetailSeries;

  setUp(() {
    mockDetailSeries = MockGetSeriesDetail();
    detailSeriesBloc = DetailSeriesBloc(mockDetailSeries);
  });

  final testSeriesDetail = SeriesDetail(
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

  const idSeries = 1402;

  blocTest<DetailSeriesBloc, DetailSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockDetailSeries.execute(idSeries))
          .thenAnswer((_) async => Right(testSeriesDetail));
      return detailSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailSeries(idSeries)),
    expect: () => [
      DetailSeriesLoading(),
      DetailSeriesHasData(testSeriesDetail),
    ],
    verify: (bloc) {
      verify(mockDetailSeries.execute(idSeries));
    },
  );

  blocTest<DetailSeriesBloc, DetailSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockDetailSeries.execute(idSeries))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailSeries(idSeries)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailSeriesLoading(),
      const DetailSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockDetailSeries.execute(idSeries));
    },
  );
}
