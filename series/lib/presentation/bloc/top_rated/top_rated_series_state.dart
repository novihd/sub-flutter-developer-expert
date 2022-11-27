part of 'top_rated_series_bloc.dart';

abstract class TopRatedSeriesState extends Equatable {
  const TopRatedSeriesState();
  @override
  List<Object?> get props => [];
}

class TopRatedSeriesLoading extends TopRatedSeriesState {}

class TopRatedSeriesEmpty extends TopRatedSeriesState {}

class TopRatedSeriesHasData extends TopRatedSeriesState {
  final List<Series> result;

  const TopRatedSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class TopRatedSeriesError extends TopRatedSeriesState {
  final String message;

  const TopRatedSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
