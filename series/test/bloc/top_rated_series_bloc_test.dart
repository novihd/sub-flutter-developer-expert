import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:series/presentation/bloc/top_rated/top_rated_series_bloc.dart';
import '../test_helper.mocks.dart';

void main() {
  late TopRatedSeriesBloc topRatedSeriesBloc;
  late MockGetTopRatedSeries mockTopRatedSeries;

  setUp(() {
    mockTopRatedSeries = MockGetTopRatedSeries();
    topRatedSeriesBloc = TopRatedSeriesBloc(mockTopRatedSeries);
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

  blocTest<TopRatedSeriesBloc, TopRatedSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedSeries()),
    expect: () => [
      TopRatedSeriesLoading(),
      TopRatedSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockTopRatedSeries.execute());
    },
  );

  blocTest<TopRatedSeriesBloc, TopRatedSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedSeries()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedSeriesLoading(),
      const TopRatedSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockTopRatedSeries.execute());
    },
  );
}
