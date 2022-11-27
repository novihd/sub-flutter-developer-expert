// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:series/presentation/bloc/season/season_series_bloc.dart';
import 'package:series/presentation/widgets/season_card_list.dart';

class SeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/season-detail';
  final String tvId;
  final String numberSeason;

  const SeasonDetailPage(
      {super.key, required this.tvId, required this.numberSeason});

  @override
  _SeasonDetailPageState createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SeasonSeriesBloc>().add(
        FetchSeasonSeries(
            tvId: widget.tvId, numberSeason: widget.numberSeason)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodes of Season ${widget.numberSeason}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SeasonSeriesBloc, SeasonSeriesState>(
          builder: (context, state) {
            if (state is SeasonSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SeasonSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return SeasonCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is SeasonSeriesEmpty) {
              return Container();
            } else if (state is SeasonSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
