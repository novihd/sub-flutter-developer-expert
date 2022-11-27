import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:series/presentation/bloc/now_playing/now_playing_series_bloc.dart';
import 'package:series/presentation/pages/now_playing_series_page.dart';
import 'package:series/presentation/pages/popular_series_page.dart';
import 'package:series/presentation/pages/series_detail_page.dart';
import 'package:series/presentation/pages/top_rated_series_page.dart';

import '../bloc/popular/popular_series_bloc.dart';
import '../bloc/top_rated/top_rated_series_bloc.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingSeriesBloc>().add(const FetchNowPlayingSeries());
      context.read<TopRatedSeriesBloc>().add(const FetchTopRatedSeries());
      context.read<PopularSeriesBloc>().add(const FetchPopularSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
                title: 'Now Playing',
                onTap: () {
                  Navigator.pushNamed(context, NowPlayingSeriesPage.ROUTE_NAME);
                }),
            BlocBuilder<NowPlayingSeriesBloc, NowPlayingSeriesState>(
                builder: (context, state) {
              if (state is NowPlayingSeriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is NowPlayingSeriesHasData) {
                return SeriesList(state.result);
              } else if (state is NowPlayingSeriesError) {
                return Text(state.message);
              } else if (state is NowPlayingSeriesEmpty) {
                return Container();
              } else {
                return Container();
              }
            }),
            _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, PopularSeriesPage.ROUTE_NAME);
                }),
            BlocBuilder<PopularSeriesBloc, PopularSeriesState>(
                builder: (context, state) {
              if (state is NowPlayingSeriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularSeriesHasData) {
                return SeriesList(state.result);
              } else if (state is PopularSeriesError) {
                return Text(state.message);
              } else if (state is PopularSeriesEmpty) {
                return Container();
              } else {
                return Container();
              }
            }),
            _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, TopRatedSeriesPage.ROUTE_NAME);
                }),
            BlocBuilder<TopRatedSeriesBloc, TopRatedSeriesState>(
                builder: (context, state) {
              if (state is TopRatedSeriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopRatedSeriesHasData) {
                return SeriesList(state.result);
              } else if (state is TopRatedSeriesError) {
                return Text(state.message);
              } else if (state is TopRatedSeriesEmpty) {
                return Container();
              } else {
                return Container();
              }
            }),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class SeriesList extends StatelessWidget {
  final List<Series> series;

  const SeriesList(this.series, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = series[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SeriesDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: series.length,
      ),
    );
  }
}
