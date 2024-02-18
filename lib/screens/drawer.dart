import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            currentAccountPicture: CircleAvatar(
              backgroundImage:AssetImage("assets/avatar.jpg") , // Load from user's photoURL or provide a placeholder
            ),
            accountName: Text(name),
            accountEmail: Text(email),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Add your action when Item 1 is tapped
              Navigator.pop(context);
            },
          ),
          ListTile(
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

