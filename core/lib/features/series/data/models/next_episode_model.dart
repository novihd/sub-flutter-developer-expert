import 'package:equatable/equatable.dart';

import '../../domain/entities/next_episode.dart';

// ignore: must_be_immutable
class NextEpisodeModel extends Equatable {
  String? airDate;
  int? episodeNumber;
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? seasonNumber;
  int? showId;
  num? voteAverage;
  num? voteCount;

  NextEpisodeModel(
      {required this.airDate,
      required this.episodeNumber,
      required this.id,
      required this.name,
      required this.overview,
      required this.productionCode,
      required this.seasonNumber,
      required this.showId,
      required this.voteAverage,
      required this.voteCount});

  factory NextEpisodeModel.fromJson(Map<String, dynamic> json) =>
      NextEpisodeModel(
        airDate: json['air_date'],
        episodeNumber: json['episode_number'],
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        productionCode: json['production_code'],
        seasonNumber: json['season_number'],
        showId: json['show_id'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count'],
      );

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episode_number': episodeNumber,
        'id': id,
        'name': name,
        'overview': overview,
        'production_code': productionCode,
        'season_number': seasonNumber,
        'show_id': showId,
        'vote_average': voteAverage,
        'vote_count': voteCount
      };

  NextEpisode toEntity() {
    return NextEpisode(
        airDate: airDate,
        episodeNumber: episodeNumber,
        id: id,
        name: name,
        overview: overview,
        productionCode: productionCode,
        seasonNumber: seasonNumber,
        showId: showId,
        voteAverage: voteAverage,
        voteCount: voteCount);
  }

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        productionCode,
        seasonNumber,
        showId,
        voteAverage,
        voteCount
      ];
}
