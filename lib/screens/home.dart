import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pds/screens/drawer.dart';
import 'package:pds/screens/gemini.dart';
import 'package:pds/screens/general_weather.dart';
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
    MyGridView(): {
      'title': 'Available Parks',
    },
    const GeneralWeather(): {
      'title': 'General Weather',
    },
    const GeminiChatUI(): {
      'title': 'Gemini Chat',
    },
    const Notifications(): {
      'title': 'Notifications',
    },
  }; // Store screens for easier reference

  void _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(_screens.values.toList()[_selectedIndex]['title']),
      ),
      body: _screens.keys.toList()[_selectedIndex],
      drawer: MyDrawer(onSelectItem: _onSelectItem),
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
              icon: LineIcons.sun,
              text: 'Weather',
            ),
            GButton(
              icon: LineIcons.facebookMessenger,
              text: 'Gemini',
            ),
            GButton(
              icon: LineIcons.bell,
              text: 'Notifications',
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
