import 'package:flutter/material.dart';
import 'package:pds/screens/MapPage.dart';
import 'package:pds/screens/drawer.dart';
import 'grid_view.dart';
import 'second_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Awesome GridView'),
        ),
        body:  TabBarView(
          children: [
            MyGridView(),
            MapPage(),
          ],
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),

          ],
        ),
      ),
    );
  }
}
