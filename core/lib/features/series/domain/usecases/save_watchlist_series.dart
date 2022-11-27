import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class SaveWatchlistSeries {
  final SeriesRepository repository;

  SaveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.saveWatchlistSeries(series);
  }
}
