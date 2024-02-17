import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pds/screens/auth/LoginPage.dart';
import 'package:pds/user-auth/firebase-auth-services.dart';

import '../widgets/loading-indicator.dart';
import 'auth/on-boarding-slider.dart';

class MyDrawer extends StatelessWidget {
   MyDrawer({super.key});
  var userEmail = FirebaseAuth.instance.currentUser?.email;
  var name = FirebaseAuth.instance.currentUser?.displayName;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              name!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
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
            onTap: () async{
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
