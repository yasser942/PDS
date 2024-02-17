// Import the required libraries
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Define the class
class FirebaseAuthentication {
  // Create a firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Get the user credential from firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Return the user
      return userCredential.user;
    } catch (e) {
      // Handle any errors
      print(e);
      return null;
    }
  }

  // Sign up with email and password
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      // Create a new user in firebase
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Return the user
      return userCredential.user;
    } catch (e) {
      // Handle any errors
      print(e);

      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from firebase
      await _auth.signOut();
    } catch (e) {
      // Handle any errors
      print(e);
    }
  }
}
