import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:series/presentation/bloc/popular/popular_series_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late PopularSeriesBloc popularSeriesBloc;
  late MockGetPopularSeries mockPopularSeries;

  setUp(() {
    mockPopularSeries = MockGetPopularSeries();
    popularSeriesBloc = PopularSeriesBloc(mockPopularSeries);
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

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockPopularSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularSeries()),
    expect: () => [
      PopularSeriesLoading(),
      PopularSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockPopularSeries.execute());
    },
  );

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'Should emit [Loading, Error] when get series is unsuccessful',
    build: () {
      when(mockPopularSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularSeries()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularSeriesLoading(),
      const PopularSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockPopularSeries.execute());
    },
  );
}
