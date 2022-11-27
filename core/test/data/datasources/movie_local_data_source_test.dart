import 'package:core/core.dart';
import 'package:core/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:core/features/movies/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  const testMovieCache = MovieTable(
      id: 557,
      overview:
          'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
      posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
      title: 'Spider-Man');
  final testMovieCacheMap = {
    'id': 557,
    'overview':
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    'title': 'Spider-Man',
  };

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistMovie(testMovieTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistMovie(testMovieTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistMovie(testMovieTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlist(testMovieTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistMovie(testMovieTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Movie Detail By Id', () {
    const tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getMovieById(tId))
          .thenAnswer((_) async => testMovieMap);
      // act
      final result = await dataSource.getMovieById(tId);
      // assert
      expect(result, testMovieTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getMovieById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getMovieById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieMap]);
      // act
      final result = await dataSource.getWatchlistMovies();
      // assert
      expect(result, [testMovieTable]);
    });
  });

  group('Cache Now Playing Movies', () {
    test('should call database helper to save data', () async {
      when(mockDatabaseHelper.clearCache('now playing'))
          .thenAnswer((_) async => 1);

      await dataSource.cacheNowPlayingMovies([testMovieCache]);
      verify(mockDatabaseHelper.clearCache('now playing'));

      verify(mockDatabaseHelper
          .insertCacheTransaction([testMovieCache], 'now playing'));
    });

    test('should return list of movies from db when data exist', () async {
      when(mockDatabaseHelper.getCacheMovies('now playing'))
          .thenAnswer((realInvocation) async => [testMovieCacheMap]);
      final result = await dataSource.getCachedNowPlayingMovies();
      expect(result, [testMovieCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      when(mockDatabaseHelper.getCacheMovies('now playing'))
          .thenAnswer((realInvocation) async => []);

      final call = dataSource.getCachedNowPlayingMovies();
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('Cache Popular Movie', () {
    test('should call database helper to save data', () async {
      when(mockDatabaseHelper.clearCache('popular')).thenAnswer((_) async => 1);

      await dataSource.cachePopularMovies([testMovieCache]);
      verify(mockDatabaseHelper.clearCache('popular'));

      verify(mockDatabaseHelper
          .insertCacheTransaction([testMovieCache], 'popular'));
    });

    test('should return list of movies from db when data exist', () async {
      when(mockDatabaseHelper.getCacheMovies('popular'))
          .thenAnswer((realInvocation) async => [testMovieCacheMap]);
      final result = await dataSource.getCachedPopularMovies();
      expect(result, [testMovieCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      when(mockDatabaseHelper.getCacheMovies('popular'))
          .thenAnswer((realInvocation) async => []);

      final call = dataSource.getCachedPopularMovies();
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('Cache Top Rated Movie', () {
    test('should call database helper to save data', () async {
      when(mockDatabaseHelper.clearCache('top')).thenAnswer((_) async => 1);

      await dataSource.cacheTopMovies([testMovieCache]);
      verify(mockDatabaseHelper.clearCache('top'));

      verify(
          mockDatabaseHelper.insertCacheTransaction([testMovieCache], 'top'));
    });

    test('should return list of movies from db when data exist', () async {
      when(mockDatabaseHelper.getCacheMovies('top'))
          .thenAnswer((realInvocation) async => [testMovieCacheMap]);
      final result = await dataSource.getCachedTopMovies();
      expect(result, [testMovieCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      when(mockDatabaseHelper.getCacheMovies('top'))
          .thenAnswer((realInvocation) async => []);

      final call = dataSource.getCachedTopMovies();
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
