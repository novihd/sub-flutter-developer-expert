// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';
import 'package:series/presentation/widgets/series_card_list.dart';

class SearchSeriesPage extends StatelessWidget {
  static const ROUTE_NAME = '/search_series';

  const SearchSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchSeriesBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchSeriesBloc, SearchSeriesState>(
              builder: (context, state) {
                if (state is SearchSeriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchSeriesHasData) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final series = state.result[index];
                        return SeriesCard(series);
                      },
                      itemCount: state.result.length,
                    ),
                  );
                } else if (state is SearchSeriesEmpty) {
                  return Expanded(
                    child: ListView(
                      children: [
                        Lottie.asset('assets/not_found_lottie.json',
                            width: 250, height: 250),
                        const Center(child: Text('Series not found')),
                      ],
                    ),
                  );
                } else if (state is SearchSeriesError) {
                  if (state.message == '') {
                    return Container();
                  } else {
                    return Expanded(
                      child: ListView(
                        children: [
                          Lottie.asset('assets/no_internet_lottie.json',
                              width: 250, height: 250),
                          Center(child: Text(state.message)),
                        ],
                      ),
                    );
                  }
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
