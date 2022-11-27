// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:core/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';

class MockTopRatedMovieBloc extends Mock implements TopRatedMovieBloc {}

class TopRatedMovieMovieEventFake extends Fake implements TopRatedMovieEvent {}

class TopRatedMovieMovieStateFake extends Fake implements TopRatedMovieState {}

void main() {
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;

  setUp(() {
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: mockTopRatedMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
    when(() => mockTopRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(const TopRatedMovieHasData(<Movie>[])));
    when(() => mockTopRatedMovieBloc.state)
        .thenReturn(const TopRatedMovieHasData(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedMovieBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedMovieError('Error message')));
    when(() => mockTopRatedMovieBloc.state)
        .thenReturn(const TopRatedMovieError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
