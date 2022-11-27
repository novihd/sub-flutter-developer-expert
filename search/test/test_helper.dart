import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([MovieRepository, SeriesRepository],
    customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {}
