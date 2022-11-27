import 'package:core/features/movies/data/models/movie_table.dart';
import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:core/features/movies/domain/entities/movie_detail.dart';
import 'package:core/features/series/data/models/series_table.dart';
import 'package:core/features/series/domain/entities/genre.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testMovieFromCache = Movie.watchlist(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testSeries = Series(
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    popularity: 2106.129,
    id: 1402,
    backdropPath: '/zaulpwl355dlKkvtAiSBE5LaoWA.jpg',
    voteAverage: 8.1,
    overview:
        "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
    firstAirDate: '2010-10-31',
    originCountry: const ["US"],
    originalLanguage: 'en',
    genreIds: const [10759, 18, 10765],
    voteCount: 14017,
    name: 'The Walking Dead',
    originalName: 'The Walking Dead');

final testSeriesList = [testSeries];

const testSeriesTable = SeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testWatchlistSeries = Series.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

final testSeriesFromCache = Series.watchlist(
  id: 1402,
  overview:
      "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
  posterPath: "/rweIrveL43TaxUN0akQEaAXL6x0.jpg",
  name: "The Walking Dead",
);

final testSeriesDetail = SeriesDetail(
    backdropPath: 'backdropPath',
    episodeRunTime: const [1, 2],
    firstAirDate: 'firstAirDate',
    genres: const [Genre(id: 1, name: 'Action')],
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
