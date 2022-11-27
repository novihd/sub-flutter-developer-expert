// ignore_for_file: must_be_immutable

import 'package:core/features/series/domain/entities/genre.dart';
import 'package:core/features/series/domain/entities/next_episode.dart';
import 'package:core/features/series/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class SeriesDetail extends Equatable {
  String? backdropPath;
  List<int>? episodeRunTime;
  String? firstAirDate;
  List<Genre>? genres;
  String? homepage;
  int? id;
  List<String>? languages;
  String? lastAirDate;
  String? name;
  NextEpisode? nextEpisodeToAir;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  List<Season>? seasons;
  double? voteAverage;
  int? voteCount;

  SeriesDetail(
      {required this.backdropPath,
      required this.episodeRunTime,
      required this.firstAirDate,
      required this.genres,
      required this.homepage,
      required this.id,
      required this.languages,
      required this.lastAirDate,
      required this.name,
      required this.nextEpisodeToAir,
      required this.numberOfEpisodes,
      required this.numberOfSeasons,
      required this.originalName,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.seasons,
      required this.voteAverage,
      required this.voteCount});

  @override
  List<Object?> get props => [
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        homepage,
        id,
        languages,
        lastAirDate,
        name,
        nextEpisodeToAir,
        numberOfEpisodes,
        numberOfSeasons,
        originalName,
        overview,
        popularity,
        posterPath,
        seasons,
        voteAverage,
        voteCount
      ];
}
