part of 'now_playing_series_bloc.dart';

abstract class NowPlayingSeriesEvent extends Equatable {
  const NowPlayingSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingSeries extends NowPlayingSeriesEvent {
  const FetchNowPlayingSeries();

  @override
  List<Object> get props => [];
}
