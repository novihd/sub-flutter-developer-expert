// ignore_for_file: library_private_types_in_public_api

import 'package:core/pages/watchlist_page.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/movie_page.dart';
import 'package:series/presentation/pages/series_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  final List<BottomNavigationBarItem> _listBottomNavigation = [
    const BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movie'),
    const BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Series')
  ];
  final List<Widget> _listPage = [const MoviePage(), const SeriesPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  _bottomNavIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Series'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  _bottomNavIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              _bottomNavIndex == 0
                  ? Navigator.pushNamed(context, SEARCH_MOVIE_ROUTE)
                  : Navigator.pushNamed(context, SEARCH_SERIES_ROUTE);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: _listPage[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _listBottomNavigation,
        currentIndex: _bottomNavIndex,
        onTap: (value) {
          setState(() {
            _bottomNavIndex = value;
          });
        },
      ),
    );
  }
}
