part of 'season_series_bloc.dart';

abstract class SeasonSeriesState extends Equatable {
  const SeasonSeriesState();

  @override
  List<Object> get props => [];
}

class SeasonSeriesLoading extends SeasonSeriesState {}

class SeasonSeriesEmpty extends SeasonSeriesState {}

class SeasonSeriesHasData extends SeasonSeriesState {
  final List<SeasonDetail> result;

  const SeasonSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class SeasonSeriesError extends SeasonSeriesState {
  final String message;

  const SeasonSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
