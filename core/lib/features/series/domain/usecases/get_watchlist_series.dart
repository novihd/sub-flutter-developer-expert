import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class GetWatchlistSeries {
  final SeriesRepository repository;

  GetWatchlistSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getWatchlistSeries();
  }
}
