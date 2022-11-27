import 'dart:io';
import 'package:core/core.dart';
import 'package:core/features/series/data/models/genre_model.dart';
import 'package:core/features/series/data/models/season_detail_model.dart';
import 'package:core/features/series/data/models/series_detail_response.dart';
import 'package:core/features/series/data/models/series_model.dart';
import 'package:core/features/series/data/models/series_table.dart';
import 'package:core/features/series/data/repositories/series_repository_impl.dart';
import 'package:core/features/series/domain/entities/season_detail.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesRepositoryImpl repository;
  late MockSeriesRemoteDataSource mockRemoteDataSource;
  late MockSeriesLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockSeriesRemoteDataSource();
    mockLocalDataSource = MockSeriesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SeriesRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
    when(mockNetworkInfo.isConnected)
        .thenAnswer((realInvocation) async => true);
  });

  const tSeriesModel = SeriesModel(
      posterPath: "/rweIrveL43TaxUN0akQEaAXL6x0.jpg",
      popularity: 2106.129,
      id: 1402,
      backdropPath: "/zaulpwl355dlKkvtAiSBE5LaoWA.jpg",
      voteAverage: 8.1,
      overview:
          "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
      firstAirDate: '2010-10-31',
      originCountry: ["US"],
      originalLanguage: 'en',
      genreIds: [10759, 18, 10765],
      voteCount: 14017,
      name: "The Walking Dead",
      originalName: "The Walking Dead");

  final tSeries = Series(
      posterPath: "/rweIrveL43TaxUN0akQEaAXL6x0.jpg",
      popularity: 2106.129,
      id: 1402,
      backdropPath: "/zaulpwl355dlKkvtAiSBE5LaoWA.jpg",
      voteAverage: 8.1,
      overview:
          "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
      firstAirDate: '2010-10-31',
      originCountry: const ["US"],
      originalLanguage: "en",
      genreIds: const [10759, 18, 10765],
      voteCount: 14017,
      name: "The Walking Dead",
      originalName: "The Walking Dead");

  const testSeriesCache = SeriesTable(
      id: 1402,
      overview:
          "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
      posterPath: "/rweIrveL43TaxUN0akQEaAXL6x0.jpg",
      name: "The Walking Dead");

  final tSeriesModelList = <SeriesModel>[tSeriesModel];
  final tSeriesList = <Series>[tSeries];

  group('Now Playing Series', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockRemoteDataSource.getNowPlayingSeries())
          .thenAnswer((realInvocation) async => []);
      //act
      await repository.getNowPlayingSeries();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingSeries())
            .thenAnswer((_) async => tSeriesModelList);
        // act
        final result = await repository.getNowPlayingSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingSeries());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tSeriesList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getNowPlayingSeries())
            .thenAnswer((realInvocation) async => tSeriesModelList);
        //act
        await repository.getNowPlayingSeries();
        //assert
        verify(mockRemoteDataSource.getNowPlayingSeries());
        verify(mockLocalDataSource.cacheNowPlayingSeries([testSeriesCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingSeries())
            .thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingSeries();
        // assert
        verify(mockRemoteDataSource.getNowPlayingSeries());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingSeries())
            .thenAnswer((_) async => [testSeriesCache]);
        // act
        final result = await repository.getNowPlayingSeries();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testSeriesFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        when(mockLocalDataSource.getCachedNowPlayingSeries())
            .thenThrow(CacheException('No Cache'));
        final result = await repository.getNowPlayingSeries();
        verify(mockLocalDataSource.getCachedNowPlayingSeries());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular Series', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockRemoteDataSource.getPopularSeries())
          .thenAnswer((realInvocation) async => []);
      //act
      await repository.getPopularSeries();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test('should return series list when call to data source is success',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularSeries())
            .thenAnswer((_) async => tSeriesModelList);
        // act
        final result = await repository.getPopularSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tSeriesList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getPopularSeries())
            .thenAnswer((realInvocation) async => tSeriesModelList);
        //act
        await repository.getPopularSeries();
        //assert
        verify(mockRemoteDataSource.getPopularSeries());
        verify(mockLocalDataSource.cachePopularSeries([testSeriesCache]));
      });

      test(
          'should return server failure when call to data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularSeries())
            .thenThrow(ServerException());
        // act
        final result = await repository.getPopularSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      });
    });
    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return cached data popular series when device is offline',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularSeries())
            .thenAnswer((_) async => [testSeriesCache]);
        // act
        final result = await repository.getPopularSeries();
        // assert
        verify(mockLocalDataSource.getCachedPopularSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testSeriesFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        when(mockLocalDataSource.getCachedPopularSeries())
            .thenThrow(CacheException('No Cache'));
        final result = await repository.getPopularSeries();
        verify(mockLocalDataSource.getCachedPopularSeries());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Top Rated Series', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      when(mockRemoteDataSource.getTopRatedSeries())
          .thenAnswer((realInvocation) async => []);
      //act
      await repository.getTopRatedSeries();
      //assert
      verify(mockNetworkInfo.isConnected);
    });
    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test('should return series list when call to data source is success',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedSeries())
            .thenAnswer((_) async => tSeriesModelList);
        // act
        final result = await repository.getTopRatedSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tSeriesList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getTopRatedSeries())
            .thenAnswer((realInvocation) async => tSeriesModelList);
        //act
        await repository.getTopRatedSeries();
        //assert
        verify(mockRemoteDataSource.getTopRatedSeries());
        verify(mockLocalDataSource.cacheTopSeries([testSeriesCache]));
      });

      test(
          'should return server failure when call to data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedSeries())
            .thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      });
    });
    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return cached data popular series when device is offline',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedTopSeries())
            .thenAnswer((_) async => [testSeriesCache]);
        // act
        final result = await repository.getTopRatedSeries();
        // assert
        verify(mockLocalDataSource.getCachedTopSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testSeriesFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        when(mockLocalDataSource.getCachedTopSeries())
            .thenThrow(CacheException('No Cache'));
        final result = await repository.getTopRatedSeries();
        verify(mockLocalDataSource.getCachedTopSeries());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Get Series Detail', () {
    const tId = 1;
    final tSeriesResponse = SeriesDetailResponse(
        backdropPath: 'backdropPath',
        episodeRunTime: const [1, 2],
        firstAirDate: 'firstAirDate',
        genres: const [GenreModel(id: 1, name: 'Action')],
        homepage: 'homepage',
        id: 1,
        languages: const ['en'],
        lastAirDate: 'lastAirDate',
        name: 'name',
        nextEpisodeToAir: null,
        numberOfEpisodes: 1,
        numberOfSeasons: 1,
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1.1,
        posterPath: 'posterPath',
        seasons: null,
        voteAverage: 1.1,
        voteCount: 1);

    test(
        'should return Series data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenAnswer((_) async => tSeriesResponse);
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Right(testSeriesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Series Season', () {
    const tId = 1;
    final tSeasonResponse = SeasonDetailModel(
        airDate: 'airDate',
        episodeNumber: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        productionCode: 'productionCode',
        seasonNumber: 1,
        stillPath: 'stillPath',
        voteAverage: 1,
        voteCount: 1);
    final tSeasonDetail = SeasonDetail(
        airDate: 'airDate',
        episodeNumber: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        productionCode: 'productionCode',
        seasonNumber: 1,
        stillPath: 'stillPath',
        voteAverage: 1,
        voteCount: 1);
    final tSeasonList = <SeasonDetail>[tSeasonDetail];

    test('should return series list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesSeason(tId.toString(), tId.toString()))
          .thenAnswer((_) async => [tSeasonResponse]);
      // act
      final result =
          await repository.getSeriesSeason(tId.toString(), tId.toString());
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeasonList);
    });
    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesSeason(tId.toString(), tId.toString()))
          .thenThrow(ServerException());
      // act
      final result =
          await repository.getSeriesSeason(tId.toString(), tId.toString());
      // assert
      verify(
          mockRemoteDataSource.getSeriesSeason(tId.toString(), tId.toString()));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesSeason(tId.toString(), tId.toString()))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result =
          await repository.getSeriesSeason(tId.toString(), tId.toString());
      // assert
      verify(
          mockRemoteDataSource.getSeriesSeason(tId.toString(), tId.toString()));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Series Recommendations', () {
    final tSeriesList = <SeriesModel>[];
    const tId = 1;

    test('should return data (series list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenAnswer((_) async => tSeriesList);
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tSeriesList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getSeriesRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Series', () {
    const tQuery = 'The Walking Dead';

    test('should return series list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchSeries(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchSeries(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistSeries(testSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistSeries(testSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistSeries(testSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistSeries(testSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistSeries(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist series', () {
    test('should return list of Series', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistSeries())
          .thenAnswer((_) async => [testSeriesTable]);
      // act
      final result = await repository.getWatchlistSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistSeries]);
    });
  });
}
