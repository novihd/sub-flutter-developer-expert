import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/domain/usecases/search_series.dart';

part 'search_series_event.dart';
part 'search_series_state.dart';

class SearchSeriesBloc extends Bloc<SearchSeriesEvent, SearchSeriesState> {
  final SearchSeries _searchSeries;

  SearchSeriesBloc(this._searchSeries) : super(SearchSeriesEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchSeriesLoading());
      final result = await _searchSeries.execute(query);

      result.fold(
        (failure) {
          emit(SearchSeriesError(failure.message));
        },
        (data) {
          emit(data.isEmpty ? SearchSeriesEmpty() : SearchSeriesHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
