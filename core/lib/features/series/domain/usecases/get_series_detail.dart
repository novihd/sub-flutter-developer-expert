import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class GetSeriesDetail {
  final SeriesRepository repository;

  GetSeriesDetail(this.repository);

  Future<Either<Failure, SeriesDetail>> execute(int id) {
    return repository.getSeriesDetail(id);
  }
}
