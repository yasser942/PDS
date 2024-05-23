import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
            decoration:  BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
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
              print("Sign Out");
              showDialog(context: context, builder: (context) => AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      loadingIndicator(context);
                      await _auth.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const onBoardingSlider()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Sign Out'),
                  ),


                ],

              ),);

              },
          ),
          // Add more list tiles as needed
          Column(


            children: <Widget>[
              const Divider(
                height: 10.0,
                thickness: 1.0,
              ),
              ListTile(
                title: const Center(child: Text('App Version 1.0.0')),
                onTap: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}

