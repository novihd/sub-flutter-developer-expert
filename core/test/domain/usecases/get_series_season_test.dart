import 'package:core/features/series/domain/entities/season_detail.dart';
import 'package:core/features/series/domain/usecases/get_series_season.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeriesSeason usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = GetSeriesSeason(mockSeriesRepository);
  });

  final tSeriesSeason = <SeasonDetail>[];

  test('should get list of season series from the repository', () async {
    // arrange
    when(mockSeriesRepository.getSeriesSeason('1', '1'))
        .thenAnswer((_) async => Right(tSeriesSeason));
    // act
    final result = await usecase.execute('1', '1');
    // assert
    expect(result, Right(tSeriesSeason));
  });
}
