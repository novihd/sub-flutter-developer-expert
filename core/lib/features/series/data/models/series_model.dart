import 'package:core/features/series/domain/entities/series.dart';
import 'package:equatable/equatable.dart';

class SeriesModel extends Equatable {
  final String? posterPath;
  final num? popularity;
  final int? id;
  final String? backdropPath;
  final num? voteAverage;
  final String? overview;
  final String? firstAirDate;
  final List<String>? originCountry;
  final List<int> genreIds;
  final String? originalLanguage;
  final num? voteCount;
  final String? name;
  final String? originalName;

  const SeriesModel(
      {required this.posterPath,
      required this.popularity,
      required this.id,
      required this.backdropPath,
      required this.voteAverage,
      required this.overview,
      required this.firstAirDate,
      required this.originCountry,
      required this.genreIds,
      required this.originalLanguage,
      required this.voteCount,
      required this.name,
      required this.originalName});

  factory SeriesModel.fromJson(Map<String, dynamic> json) => SeriesModel(
        posterPath: json['poster_path'],
        popularity: json['popularity'],
        id: json['id'],
        backdropPath: json['backdrop_path'],
        voteAverage: json['vote_average'],
        overview: json['overview'],
        firstAirDate: json['first_air_date'],
        originCountry: json['origin_country'].cast<String>(),
        genreIds: List<int>.from(json["genre_ids"].map((e) => e)),
        originalLanguage: json['original_language'],
        voteCount: json['vote_count'],
        name: json['name'],
        originalName: json['original_name'],
      );

  Map<String, dynamic> toJson() => {
        'poster_path': posterPath,
        'popularity': popularity,
        'id': id,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'overview': overview,
        'first_air_date': firstAirDate,
        'origin_country': originCountry,
        'genre_ids': List<dynamic>.from(genreIds.map((x) => x)),
        'original_language': originalLanguage,
        'vote_count': voteCount,
        'name': name,
        'original_name': originalName
      };

  Series toEntity() {
    return Series(
        posterPath: posterPath,
        popularity: popularity,
        id: id,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        overview: overview,
        firstAirDate: firstAirDate,
        originCountry: originCountry,
        originalLanguage: originalLanguage,
        genreIds: genreIds,
        voteCount: voteCount,
        name: name,
        originalName: originalName);
  }

  @override
  List<Object?> get props => [
        posterPath,
        popularity,
        id,
        backdropPath,
        voteAverage,
        overview,
        firstAirDate,
        originCountry,
        genreIds,
        originalLanguage,
        voteCount,
        name,
        originalName
      ];
}
