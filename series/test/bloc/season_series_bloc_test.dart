import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/season_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:series/presentation/bloc/season/season_series_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late SeasonSeriesBloc seasonSeriesBloc;
  late MockGetSeriesSeason mockSeasonSeries;

  setUp(() {
    mockSeasonSeries = MockGetSeriesSeason();
    seasonSeriesBloc = SeasonSeriesBloc(mockSeasonSeries);
  });

  final tSeasonDetail = SeasonDetail(
      airDate: 'airDate',
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: 'productionCode',
      seasonNumber: 1,
      stillPath: 'stillPath',
      voteAverage: 1,
      voteCount: 1);
  final tSeasonList = <SeasonDetail>[tSeasonDetail];

  blocTest<SeasonSeriesBloc, SeasonSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSeasonSeries.execute('1', '1'))
          .thenAnswer((_) async => Right(tSeasonList));
      return seasonSeriesBloc;
    },
    act: (bloc) =>
        bloc.add(const FetchSeasonSeries(tvId: '1', numberSeason: '1')),
    expect: () => [
      SeasonSeriesLoading(),
      SeasonSeriesHasData(tSeasonList),
    ],
    verify: (bloc) {
      verify(mockSeasonSeries.execute('1', '1'));
    },
  );

  blocTest<SeasonSeriesBloc, SeasonSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSeasonSeries.execute('1', '1'))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seasonSeriesBloc;
    },
    act: (bloc) =>
        bloc.add(const FetchSeasonSeries(tvId: '1', numberSeason: '1')),
    expect: () => [
      SeasonSeriesLoading(),
      const SeasonSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSeasonSeries.execute('1', '1'));
    },
  );
}
