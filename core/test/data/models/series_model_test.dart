import 'package:core/features/series/data/models/series_model.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeriesModel = SeriesModel(
    posterPath: 'posterPath',
    popularity: 1,
    id: 1,
    backdropPath: 'backdropPath',
    voteAverage: 2,
    overview: 'Overview',
    firstAirDate: 'releaseData',
    originCountry: ['US'],
    genreIds: [1, 2, 3],
    originalLanguage: 'en',
    voteCount: 1,
    name: 'name',
    originalName: 'Original Name',
  );

  final tSeries = Series(
    posterPath: 'posterPath',
    popularity: 1,
    id: 1,
    backdropPath: 'backdropPath',
    voteAverage: 2,
    overview: 'Overview',
    firstAirDate: 'releaseData',
    originCountry: const ['US'],
    genreIds: const [1, 2, 3],
    originalLanguage: 'en',
    voteCount: 1,
    name: 'name',
    originalName: 'Original Name',
  );

  test('should be a subclass of Series entity', () async {
    final result = tSeriesModel.toEntity();
    expect(result, tSeries);
  });
}
