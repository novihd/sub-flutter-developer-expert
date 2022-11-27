// ignore_for_file: prefer_typing_uninitialized_variables

part of 'recommendation_series_bloc.dart';

abstract class RecommendationSeriesEvent extends Equatable {
  const RecommendationSeriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecommendationSeries extends RecommendationSeriesEvent {
  final seriesId;

  const FetchRecommendationSeries(this.seriesId);

  @override
  List<Object?> get props => [seriesId];
}
