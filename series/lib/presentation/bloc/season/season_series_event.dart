part of 'season_series_bloc.dart';

abstract class SeasonSeriesEvent extends Equatable {
  const SeasonSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonSeries extends SeasonSeriesEvent {
  final String tvId;
  final String numberSeason;
  const FetchSeasonSeries({required this.tvId, required this.numberSeason});

  @override
  List<Object> get props => [tvId, numberSeason];
}
