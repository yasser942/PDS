import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/loading-indicator.dart';
import 'auth/on-boarding-slider.dart';

class MyDrawer extends StatelessWidget {
  final Function(int) onSelectItem;

  MyDrawer({super.key, required this.onSelectItem});

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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/avatar.jpg"), // Load from user's photoURL or provide a placeholder
            ),
            accountName: Text(name),
            accountEmail: Text(email),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              onSelectItem(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.sunny),
            title: const Text('Weather'),
            onTap: () {
              Navigator.pop(context);
              onSelectItem(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Gemini'),
            onTap: () {
              Navigator.pop(context);
              onSelectItem(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              onSelectItem(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
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
                          MaterialPageRoute(
                              builder: (context) => const onBoardingSlider()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
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
