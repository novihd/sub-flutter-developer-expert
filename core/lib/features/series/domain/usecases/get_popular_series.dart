import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class GetPopularSeries {
  final SeriesRepository repository;

  GetPopularSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getPopularSeries();
  }
}
