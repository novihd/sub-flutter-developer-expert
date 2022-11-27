import 'package:core/features/series/data/models/next_episode_model.dart';
import 'package:core/features/series/domain/entities/next_episode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tNextEpisodeModel = NextEpisodeModel(
      airDate: 'airDate',
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: 'productionCode',
      seasonNumber: 1,
      showId: 1,
      voteAverage: 1,
      voteCount: 1);

  final tEpisode = NextEpisode(
      airDate: 'airDate',
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: 'productionCode',
      seasonNumber: 1,
      showId: 1,
      voteAverage: 1,
      voteCount: 1);

  test('should be a subclass of Next Episode entity', () async {
    final result = tNextEpisodeModel.toEntity();
    expect(result, tEpisode);
  });
}
