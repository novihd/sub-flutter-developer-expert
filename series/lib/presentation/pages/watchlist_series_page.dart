// ignore_for_file: library_private_types_in_public_api, constant_identifier_names

import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:series/presentation/bloc/watchlist/watchlist_series_bloc.dart';
import 'package:series/presentation/widgets/series_card_list.dart';

class WatchlistSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-series';

  const WatchlistSeriesPage({super.key});

  @override
  _WatchlistSeriesPageState createState() => _WatchlistSeriesPageState();
}

class _WatchlistSeriesPageState extends State<WatchlistSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistSeriesBloc>().add(const FetchWatchlistSeries()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistSeriesBloc>().add(const FetchWatchlistSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistSeriesBloc, WatchlistSeriesState>(
          builder: (context, state) {
            if (state is WatchlistSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return SeriesCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistSeriesEmpty) {
              return Center(
                child: Column(
                  children: [
                    Lottie.asset('assets/not_found_lottie.json',
                        width: 250, height: 250),
                    const Center(child: Text('Series not found')),
                  ],
                ),
              );
            } else if (state is WatchlistSeriesError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
