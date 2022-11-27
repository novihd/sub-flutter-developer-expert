// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:core/features/series/domain/entities/series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/presentation/bloc/now_playing/now_playing_series_bloc.dart';
import 'package:series/presentation/pages/now_playing_series_page.dart';

class MockNowPlayingSeriesBloc extends Mock implements NowPlayingSeriesBloc {}

class NowPlayingSeriesEventFake extends Fake implements NowPlayingSeriesEvent {}

class NowPlayingSeriesStateFake extends Fake implements NowPlayingSeriesState {}

void main() {
  late MockNowPlayingSeriesBloc mockNowPlayingSeriesBloc;

  setUp(() {
    mockNowPlayingSeriesBloc = MockNowPlayingSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingSeriesBloc>.value(
      value: mockNowPlayingSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNowPlayingSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(NowPlayingSeriesLoading()));
    when(() => mockNowPlayingSeriesBloc.state)
        .thenReturn(NowPlayingSeriesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const NowPlayingSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const NowPlayingSeriesHasData(<Series>[])));
    when(() => mockNowPlayingSeriesBloc.state)
        .thenReturn(const NowPlayingSeriesHasData(<Series>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const NowPlayingSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const NowPlayingSeriesError('Error message')));
    when(() => mockNowPlayingSeriesBloc.state)
        .thenReturn(const NowPlayingSeriesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const NowPlayingSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
