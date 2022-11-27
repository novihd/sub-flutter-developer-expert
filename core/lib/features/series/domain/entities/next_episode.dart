import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class NextEpisode extends Equatable {
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

  NextEpisode(
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
