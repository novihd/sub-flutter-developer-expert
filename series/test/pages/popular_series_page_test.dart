// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:core/features/series/domain/entities/series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/presentation/bloc/popular/popular_series_bloc.dart';
import 'package:series/presentation/pages/popular_series_page.dart';

class MockPopularSeriesBloc extends Mock implements PopularSeriesBloc {}

class PopularSeriesEventFake extends Fake implements PopularSeriesEvent {}

class PopularSeriesStateFake extends Fake implements PopularSeriesState {}

void main() {
  late MockPopularSeriesBloc mockPopularSeriesBloc;

  setUp(() {
    mockPopularSeriesBloc = MockPopularSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularSeriesBloc>.value(
      value: mockPopularSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => mockPopularSeriesBloc.state).thenReturn(PopularSeriesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesHasData(<Series>[])));
    when(() => mockPopularSeriesBloc.state)
        .thenReturn(const PopularSeriesHasData(<Series>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesError('Error message')));
    when(() => mockPopularSeriesBloc.state)
        .thenReturn(const PopularSeriesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
