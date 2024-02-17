import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import the firebase core plugin
import 'package:firebase_auth/firebase_auth.dart'; // Import the firebase auth plugin
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:pds/screens/auth/LoginPage.dart';
import 'package:pds/screens/auth/on-boarding-slider.dart';
import 'package:pds/screens/home.dart';

class MyApp extends StatelessWidget {

  var kColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 146, 227, 169),
  );

  var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 7, 84, 72),
  );

  // Create a firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      // Your MaterialApp configuration
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 16,
          ),
        ),
      ),
      // themeMode: ThemeMode.system, // default
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If the user is logged in, show the home screen
            return HomeScreen();
          } else {
            // If the user is not logged in, show the on-boarding slider
            return onBoardingSlider();
          }
        },
      ),
    );
  }
}