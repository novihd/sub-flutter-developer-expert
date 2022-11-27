import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveWatchlistSeries {
  final SeriesRepository repository;

  RemoveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.removeWatchlistSeries(series);
  }
}
