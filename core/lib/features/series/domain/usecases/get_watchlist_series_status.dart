import 'package:core/features/series/domain/repositories/series_repository.dart';

class GetWatchlistSeriesStatus {
  final SeriesRepository repository;

  GetWatchlistSeriesStatus(this.repository);

  Future<bool> execute(id) {
    return repository.isAddedToWatchlistSeries(id);
  }
}
