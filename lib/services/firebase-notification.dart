import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/notifications.dart';

class FirebaseApi {
  static final CollectionReference ref =
  FirebaseFirestore.instance.collection("notifications");

  static Future initialize(navigatorKey) async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _showNotificationDialog(message, navigatorKey);
    });
  }

  static void subscribeToTopic(String topic) async {
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static void unsubscribeFromTopic(String topic) async {
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
  static void _showNotificationDialog(RemoteMessage message , navigatorKey) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? ''),
        content: Text(message.notification?.body ?? ''),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const Notifications()));
            },
            child: const Text('View'),
          ),

        ],
      ),
    );
  }
}

