import 'package:core/features/series/domain/entities/series.dart';
import 'package:core/features/series/domain/usecases/get_now_playing_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'now_playing_series_event.dart';
part 'now_playing_series_state.dart';

class NowPlayingSeriesBloc
    extends Bloc<NowPlayingSeriesEvent, NowPlayingSeriesState> {
  final GetNowPlayingSeries _getNowPlayingSeries;

  NowPlayingSeriesBloc(this._getNowPlayingSeries)
      : super(NowPlayingSeriesEmpty()) {
    on<FetchNowPlayingSeries>((event, emit) async {
      emit(NowPlayingSeriesLoading());
      final result = await _getNowPlayingSeries.execute();

      result.fold(
          (l) => emit(NowPlayingSeriesError(l.message)),
          (r) => emit(r.isEmpty
              ? NowPlayingSeriesEmpty()
              : NowPlayingSeriesHasData(r)));
    });
  }
}
