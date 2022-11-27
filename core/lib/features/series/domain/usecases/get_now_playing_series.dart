import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';

class GetNowPlayingSeries {
  final SeriesRepository repository;

  GetNowPlayingSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getNowPlayingSeries();
  }
}
