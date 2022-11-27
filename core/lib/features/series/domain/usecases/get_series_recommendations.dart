import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class GetSeriesRecommendations {
  final SeriesRepository repository;

  GetSeriesRecommendations(this.repository);

  Future<Either<Failure, List<Series>>> execute(int id) {
    return repository.getSeriesRecommendations(id);
  }
}
