import 'dart:convert';
import 'package:core/features/series/data/models/series_model.dart';
import 'package:core/features/series/data/models/series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

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
  const tSeriesResponseModel =
      SeriesResponse(seriesList: <SeriesModel>[tSeriesModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_series.json'));
      // act
      final result = SeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "backdropPath",
            "first_air_date": "releaseData",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "name": "name",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1,
            "poster_path": "posterPath",
            "vote_average": 2,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
