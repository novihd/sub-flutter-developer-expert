// ignore_for_file: constant_identifier_names
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';
const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
const BASE_URL = 'https://api.themoviedb.org/3';

const String addedToWatchlistMessage = 'Added to Watchlist';
const String removedFromWatchlistMessage = 'Removed from Watchlist';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
