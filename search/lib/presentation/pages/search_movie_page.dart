// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

import '../bloc/search_bloc.dart';

class SearchMoviePage extends StatelessWidget {
  static const ROUTE_NAME = '/search_movie';

  const SearchMoviePage({super.key});

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
                context.read<SearchBloc>().add(OnQueryChanged(query));
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
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = result[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchEmpty) {
                  return Expanded(
                    child: ListView(
                      children: [
                        Lottie.asset('assets/not_found_lottie.json',
                            width: 250, height: 250),
                        const Center(child: Text('Movie not found')),
                      ],
                    ),
                  );
                } else if (state is SearchError) {
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
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
