import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:series/presentation/bloc/now_playing/now_playing_series_bloc.dart';
import '../test_helper.mocks.dart';

void main() {
  late NowPlayingSeriesBloc nowPlayingSeriesBloc;
  late MockGetNowPlayingSeries mockNowPlayingSeries;

  setUp(() {
    mockNowPlayingSeries = MockGetNowPlayingSeries();
    nowPlayingSeriesBloc = NowPlayingSeriesBloc(mockNowPlayingSeries);
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
  final tSeriesList = <Series>[tSeriesModel];

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockNowPlayingSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchNowPlayingSeries()),
    expect: () => [
      NowPlayingSeriesLoading(),
      NowPlayingSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockNowPlayingSeries.execute());
    },
  );

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockNowPlayingSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchNowPlayingSeries()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingSeriesLoading(),
      const NowPlayingSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockNowPlayingSeries.execute());
    },
  );
}
