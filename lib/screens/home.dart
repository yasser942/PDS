import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pds/screens/drawer.dart';
import 'package:pds/screens/gemini.dart';
import 'package:pds/screens/general_weather.dart';
import 'package:pds/widgets/charts/line_chart_sample2.dart';
import 'grid_view.dart';
import 'notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final Map<Widget, Map<String, dynamic>> _screens = {
    //Test(): 'Test',
    MyGridView(): {
      'title': 'Available Parks',
    },
    const ThingSpeak(): {
      'title': 'Statistics',
    },
    const GeneralWeather(): {
      'title': 'Weather',
    },
    GeminiChatUI(): {
      'title': 'Gemini',
    },
  }; // Store screens for easier reference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Notifications(),
                ),
              );
                  },
          ),
        ],
        title: Text(_screens.values.toList()[_selectedIndex]['title']),
      ),
      body: _screens.keys.toList()[_selectedIndex],
      drawer: MyDrawer(),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: GNav(
          backgroundColor: Theme.of(context).colorScheme.background,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black,
          tabs: const [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.barChart,
              text: 'Statistics',
            ),
            GButton(
              icon: LineIcons.sun,
              text: 'Weather',
            ),
            GButton(
              icon: LineIcons.facebookMessenger,
              text: 'Gemini',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
