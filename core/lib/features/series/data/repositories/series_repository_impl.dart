import 'dart:io';
import 'package:core/core.dart';
import 'package:core/features/series/data/datasources/series_remote_data_source.dart';
import 'package:core/features/series/data/models/series_table.dart';
import 'package:core/features/series/domain/entities/season_detail.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../utils/network_info.dart';
import '../../domain/entities/series.dart';
import '../datasources/series_local_data_source.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  final SeriesRemoteDataSource remoteDataSource;
  final SeriesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  SeriesRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Series>>> getNowPlayingSeries() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getNowPlayingSeries();
        localDataSource.cacheNowPlayingSeries(
            result.map((e) => SeriesTable.fromDTO(e)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {
      try {
        final result = await localDataSource.getCachedNowPlayingSeries();
        return Right(result.map((e) => e.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Series>>> getPopularSeries() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPopularSeries();
        localDataSource.cachePopularSeries(
            result.map((e) => SeriesTable.fromDTO(e)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {
      try {
        final result = await localDataSource.getCachedPopularSeries();
        return Right(result.map((e) => e.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, SeriesDetail>> getSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Series>>> getTopRatedSeries() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTopRatedSeries();
        localDataSource
            .cacheTopSeries(result.map((e) => SeriesTable.fromDTO(e)).toList());
        return Right(result.map((e) => e.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {
      try {
        final result = await localDataSource.getCachedTopSeries();
        return Right(result.map((e) => e.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Series>>> searchSeries(String query) async {
    try {
      final result = await remoteDataSource.searchSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<SeasonDetail>>> getSeriesSeason(
      String tvId, String seasonNumber) async {
    try {
      final result = await remoteDataSource.getSeriesSeason(tvId, seasonNumber);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Series>>> getWatchlistSeries() async {
    try {
      final result = await localDataSource.getWatchlistSeries();
      return Right(result.map((e) => e.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlistSeries(int id) async {
    final result = await localDataSource.getSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlistSeries(
      SeriesDetail series) async {
    try {
      final result = await localDataSource
          .removeWatchlistSeries(SeriesTable.fromEntity(series));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlistSeries(
      SeriesDetail series) async {
    try {
      final result = await localDataSource
          .insertWatchlistSeries(SeriesTable.fromEntity(series));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, List<Series>>> getSeriesRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getSeriesRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
