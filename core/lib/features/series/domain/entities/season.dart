import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Season extends Equatable {
  String? airDate;
  int? episodeCount;
  int? id;
  String? name;
  String? overview;
  String? posterPath;
  int? seasonNumber;

  Season(
      {this.airDate,
      this.episodeCount,
      this.id,
      this.name,
      this.overview,
      this.posterPath,
      this.seasonNumber});

  @override
  List<Object?> get props =>
      [airDate, episodeCount, id, name, overview, posterPath, seasonNumber];
}
