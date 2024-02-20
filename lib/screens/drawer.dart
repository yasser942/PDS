import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pds/screens/MapPage.dart';
import 'package:pds/screens/grid_view.dart';
import 'package:pds/screens/weather.dart';
import 'package:pds/user-auth/firebase-auth-services.dart';

import '../widgets/loading-indicator.dart';
import 'auth/on-boarding-slider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pds/user-auth/firebase-auth-services.dart';

import '../widgets/loading-indicator.dart';
import 'auth/on-boarding-slider.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final String name = user?.displayName ?? 'User Name';
    final String email = user?.email ?? 'user@example.com';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/runze-shi-1kIyfRdLMxI-unsplash.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage:AssetImage("assets/avatar.jpg") , // Load from user's photoURL or provide a placeholder
            ),
            accountName: Text(name),
            accountEmail: Text(email),
          ),
          ListTile(
            leading: const Icon(Icons.home,),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              //Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyGridView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              //Navigator.push(context, MaterialPageRoute(builder: (context) =>  MapPage()));

            },
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: const Text('Weather'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
             // Navigator.push(context, MaterialPageRoute(builder: (context) =>  WeatherPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              //Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyGridView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () async {
              loadingIndicator(context);
              await FirebaseAuthentication().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const onBoardingSlider()));
            },
          ),
          // Add more list tiles as needed
        ],
      ),
    );
  }
}

