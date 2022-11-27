import 'package:core/features/series/data/models/genre_model.dart';
import 'package:core/features/series/data/models/next_episode_model.dart';
import 'package:core/features/series/data/models/season_model.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/series_detail.dart';

// ignore: must_be_immutable
class SeriesDetailResponse extends Equatable {
  String? backdropPath;
  List<int>? episodeRunTime;
  String? firstAirDate;
  List<GenreModel>? genres;
  String? homepage;
  int? id;
  List<String>? languages;
  String? lastAirDate;
  String? name;
  NextEpisodeModel? nextEpisodeToAir;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  List<SeasonsModel>? seasons;
  double? voteAverage;
  int? voteCount;

  SeriesDetailResponse(
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

  factory SeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeriesDetailResponse(
        backdropPath: json['backdrop_path'],
        episodeRunTime: json['episode_run_time'].cast<int>(),
        firstAirDate: json['first_air_date'],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json['homepage'],
        id: json['id'],
        languages: json['languages'].cast<String>(),
        lastAirDate: json['last_air_date'],
        name: json['name'],
        nextEpisodeToAir: json["next_episode_to_air"] != null
            ? NextEpisodeModel.fromJson(json["next_episode_to_air"])
            : null,
        numberOfEpisodes: json['number_of_episodes'],
        numberOfSeasons: json['number_of_seasons'],
        originalName: json['original_name'],
        overview: json['overview'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        seasons: List<SeasonsModel>.from(
            json["seasons"].map((x) => SeasonsModel.fromJson(x))),
        voteAverage: json['vote_average'],
        voteCount: json['vote_count'],
      );

  Map<String, dynamic> toJson() => {
        'backdrop_path': backdropPath,
        'episode_run_time': episodeRunTime,
        'first_air_date': firstAirDate,
        'genres': genres!.map((v) => v.toJson()).toList(),
        'homepage': homepage,
        'id': id,
        'languages': languages,
        'last_air_date': lastAirDate,
        'name': name,
        'next_episode_to_air': nextEpisodeToAir?.toJson(),
        'number_of_episodes': numberOfEpisodes,
        'number_of_seasons': numberOfSeasons,
        'original_name': originalName,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'seasons': seasons?.map((v) => v.toJson()).toList(),
        'vote_average': voteAverage,
        'vote_count': voteCount
      };

  SeriesDetail toEntity() {
    return SeriesDetail(
        backdropPath: backdropPath,
        episodeRunTime: episodeRunTime,
        firstAirDate: firstAirDate,
        genres: genres?.map((genre) => genre.toEntity()).toList(),
        homepage: homepage,
        id: id,
        languages: languages,
        lastAirDate: lastAirDate,
        name: name,
        nextEpisodeToAir: nextEpisodeToAir?.toEntity(),
        numberOfEpisodes: numberOfEpisodes,
        numberOfSeasons: numberOfSeasons,
        originalName: originalName,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        seasons: seasons?.map((e) => e.toEntity()).toList(),
        voteAverage: voteAverage,
        voteCount: voteCount);
  }

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
