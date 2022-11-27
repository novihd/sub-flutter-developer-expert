import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/season_detail.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class GetSeriesSeason {
  final SeriesRepository repository;

  GetSeriesSeason(this.repository);

  Future<Either<Failure, List<SeasonDetail>>> execute(
      String tvId, String numberSeason) {
    return repository.getSeriesSeason(tvId, numberSeason);
  }
}
