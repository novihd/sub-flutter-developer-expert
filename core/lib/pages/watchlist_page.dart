// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:series/presentation/pages/watchlist_series_page.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-page';
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final List<Widget> _listTabBarIcon = [
    const Tab(text: 'Movie'),
    const Tab(text: 'TV Series')
  ];
  final List<Widget> _listTabBarView = [
    const WatchlistMoviesPage(),
    const WatchlistSeriesPage()
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: TabBar(tabs: _listTabBarIcon, indicatorColor: kPrussianBlue),
        ),
        body: TabBarView(children: _listTabBarView),
      ),
    );
  }
}
