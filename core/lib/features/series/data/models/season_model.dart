// ignore_for_file: must_be_immutable

import 'package:core/features/series/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class SeasonsModel extends Equatable {
  String? airDate;
  int? episodeCount;
  int? id;
  String? name;
  String? overview;
  String? posterPath;
  int? seasonNumber;

  SeasonsModel(
      {this.airDate,
      this.episodeCount,
      this.id,
      this.name,
      this.overview,
      this.posterPath,
      this.seasonNumber});

  factory SeasonsModel.fromJson(Map<String, dynamic> json) => SeasonsModel(
        airDate: json['air_date'],
        episodeCount: json['episode_count'],
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
      );

  Season toEntity() {
    return Season(
        airDate: airDate,
        episodeCount: episodeCount,
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        seasonNumber: seasonNumber);
  }

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episode_count': episodeCount,
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'season_number': seasonNumber
      };

  @override
  List<Object?> get props =>
      [airDate, episodeCount, id, name, overview, posterPath, seasonNumber];
}
