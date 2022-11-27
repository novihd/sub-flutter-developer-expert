// ignore_for_file: prefer_typing_uninitialized_variables

part of 'detail_series_bloc.dart';

abstract class DetailSeriesEvent extends Equatable {
  const DetailSeriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchDetailSeries extends DetailSeriesEvent {
  final seriesId;

  const FetchDetailSeries(this.seriesId);

  @override
  List<Object?> get props => [seriesId];
}
