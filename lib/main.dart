import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gemini_flutter/gemini_flutter.dart';
import 'package:pds/screens/notifications.dart';
import 'package:pds/services/firebase-notification.dart';
import 'consts.dart';
import 'screens/app.dart';
import 'firebase_options.dart';

void main() async {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GeminiHandler().initialize(apiKey: GEM);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 await FirebaseApi.initialize(
    navigatorKey,
  );
  FirebaseApi.subscribeToTopic('pds');

  runApp(MyApp(navigatorKey: navigatorKey,));
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

    navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const Notifications()));

  });
}

