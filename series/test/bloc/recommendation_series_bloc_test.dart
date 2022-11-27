import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:series/presentation/bloc/recommendation/recommendation_series_bloc.dart';

import '../test_helper.mocks.dart';

void main() {
  late RecommendationSeriesBloc popularSeriesBloc;
  late MockGetSeriesRecommendations mockRecommendationSeries;

  setUp(() {
    mockRecommendationSeries = MockGetSeriesRecommendations();
    popularSeriesBloc = RecommendationSeriesBloc(mockRecommendationSeries);
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
  const idSeries = 14017;

  blocTest<RecommendationSeriesBloc, RecommendationSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockRecommendationSeries.execute(idSeries))
          .thenAnswer((_) async => Right(tSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationSeries(idSeries)),
    expect: () => [
      RecommendationSeriesLoading(),
      RecommendationSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockRecommendationSeries.execute(idSeries));
    },
  );

  blocTest<RecommendationSeriesBloc, RecommendationSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockRecommendationSeries.execute(idSeries))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationSeries(idSeries)),
    expect: () => [
      RecommendationSeriesLoading(),
      const RecommendationSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockRecommendationSeries.execute(idSeries));
    },
  );
}
