// ignore_for_file: depend_on_referenced_packages

import 'package:core/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:core/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/features/series/data/datasources/db/database_helper.dart';
import 'package:core/features/series/data/datasources/series_local_data_source.dart';
import 'package:core/features/series/data/datasources/series_remote_data_source.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:core/utils/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  SeriesRepository,
  SeriesRemoteDataSource,
  SeriesLocalDataSource,
  DatabaseHelper,
  NetworkInfo
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
