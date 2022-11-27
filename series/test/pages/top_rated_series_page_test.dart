// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:core/features/series/domain/entities/series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/presentation/bloc/top_rated/top_rated_series_bloc.dart';
import 'package:series/presentation/pages/top_rated_series_page.dart';

class MockTopRatedSeriesBloc extends Mock implements TopRatedSeriesBloc {}

class TopRatedSeriesSeriesEventFake extends Fake
    implements TopRatedSeriesEvent {}

class TopRatedSeriesSeriesStateFake extends Fake
    implements TopRatedSeriesState {}

void main() {
  late MockTopRatedSeriesBloc mockTopRatedSeriesBloc;

  setUp(() {
    mockTopRatedSeriesBloc = MockTopRatedSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedSeriesBloc>.value(
      value: mockTopRatedSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => mockTopRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedSeriesHasData(<Series>[])));
    when(() => mockTopRatedSeriesBloc.state)
        .thenReturn(const TopRatedSeriesHasData(<Series>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedSeriesError('Error message')));
    when(() => mockTopRatedSeriesBloc.state)
        .thenReturn(const TopRatedSeriesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
