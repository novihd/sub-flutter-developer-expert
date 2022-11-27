// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/features/series/domain/entities/genre.dart';
import 'package:core/features/series/domain/entities/series_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:series/presentation/bloc/detail/detail_series_bloc.dart';
import 'package:series/presentation/bloc/recommendation/recommendation_series_bloc.dart';
import 'package:series/presentation/bloc/watchlist/watchlist_series_bloc.dart';
import 'package:series/presentation/pages/season_detail_page.dart';
import 'package:intl/intl.dart';

class SeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail_series';

  final int id;
  const SeriesDetailPage({super.key, required this.id});

  @override
  _SeriesDetailPageState createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DetailSeriesBloc>().add(FetchDetailSeries(widget.id));
      context
          .read<RecommendationSeriesBloc>()
          .add(FetchRecommendationSeries(widget.id));
      context.read<WatchlistSeriesBloc>().add(StatusWatchlistSeries(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdded = context.select<WatchlistSeriesBloc, bool>((bloc) {
      if (bloc.state is WatchlistSeriesIsAdded) {
        return (bloc.state as WatchlistSeriesIsAdded).isAdded;
      }
      return false;
    });
    return Scaffold(
      body: BlocBuilder<DetailSeriesBloc, DetailSeriesState>(
        builder: (context, state) {
          if (state is DetailSeriesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailSeriesHasData) {
            final tv = state.result;
            return SafeArea(
              child: DetailContent(
                tv,
                isAdded,
              ),
            );
          } else if (state is DetailSeriesError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/no_internet_lottie.json',
                    width: 250, height: 250),
                Center(child: Text(state.message)),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final SeriesDetail series;
  final bool isAddedWatchlist;

  const DetailContent(this.series, this.isAddedWatchlist, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${series.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              series.name ?? '',
                              style: kHeading5,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (!isAddedWatchlist) {
                                      context
                                          .read<WatchlistSeriesBloc>()
                                          .add(AddWatchlistSeries(series));
                                    } else {
                                      context
                                          .read<WatchlistSeriesBloc>()
                                          .add(RemovedWatchlistSeries(series));
                                    }

                                    context
                                        .read<WatchlistSeriesBloc>()
                                        .add(StatusWatchlistSeries(series.id!));

                                    final state = context
                                        .read<WatchlistSeriesBloc>()
                                        .state;
                                    var message = '';

                                    if (state is WatchlistSeriesIsAdded) {
                                      final isAdded = state.isAdded;
                                      message = isAdded == false
                                          ? addedToWatchlistMessage
                                          : removedFromWatchlistMessage;
                                    } else {
                                      message = isAddedWatchlist
                                          ? addedToWatchlistMessage
                                          : removedFromWatchlistMessage;
                                    }
                                    if (message == addedToWatchlistMessage ||
                                        message ==
                                            removedFromWatchlistMessage) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(message)));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(message),
                                            );
                                          });
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAddedWatchlist
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.add),
                                      const Text('Watchlist'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                series.nextEpisodeToAir?.airDate == null
                                    ? Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: const Text('ENDED'),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                            color: Colors.yellowAccent,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Text(
                                          'NEW EPISODE ON ${_showDate(series.nextEpisodeToAir!.airDate.toString())}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ),
                              ],
                            ),
                            Text(
                              _showGenres(series.genres!),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: series.voteAverage! / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${series.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              series.overview == '' || series.overview == null
                                  ? 'Overview for ${series.name} is not available'
                                  : series.overview.toString(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          SeasonDetailPage.ROUTE_NAME,
                                          arguments: [
                                            series.id.toString(),
                                            series.seasons?[index].seasonNumber
                                                .toString()
                                          ],
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 150,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: series.seasons?[index]
                                                            .posterPath ==
                                                        null
                                                    ? 'https://user-images.githubusercontent.com/47315479/81145216-7fbd8700-8f7e-11ea-9d49-bd5fb4a888f1.png'
                                                    : '$BASE_IMAGE_URL${series.seasons?[index].posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                series.seasons?[index].name ??
                                                    '',
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: series.seasons?.length,
                              ),
                            ),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationSeriesBloc,
                                    RecommendationSeriesState>(
                                builder: (context, state) {
                              if (state is RecommendationSeriesLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is RecommendationSeriesError) {
                                return Text(state.message);
                              } else if (state is RecommendationSeriesHasData) {
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final series = state.result[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              SeriesDetailPage.ROUTE_NAME,
                                              arguments: series.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '$BASE_IMAGE_URL${series.posterPath}',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: state.result.length,
                                  ),
                                );
                              } else if (state is RecommendationSeriesEmpty) {
                                return Container();
                              } else {
                                return Container();
                              }
                            }),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDate(String date) {
    return DateFormat.EEEE()
        .format(DateFormat("yyyy-MM-dd").parse(date))
        .toUpperCase();
  }
}
