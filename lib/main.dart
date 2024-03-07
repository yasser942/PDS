import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini_flutter/gemini_flutter.dart';
import 'consts.dart';
import 'screens/app.dart';
import 'firebase_options.dart';

void main() async {
  GeminiHandler().initialize(apiKey: GEM);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(MyApp());
}

