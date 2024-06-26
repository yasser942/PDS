// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCSem2YwSrrks_d632mbaB-ByVjV3UcawU',
    appId: '1:728714319042:web:9a4363994c91ea9ade175b',
    messagingSenderId: '728714319042',
    projectId: 'aipds-423dd',
    authDomain: 'aipds-423dd.firebaseapp.com',
    storageBucket: 'aipds-423dd.appspot.com',
    measurementId: 'G-8X538HSSHY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRJsSw-SNS6yOVxWN7-vGH1DepY1YkVLU',
    appId: '1:728714319042:android:aeb9a18494c01c70de175b',
    messagingSenderId: '728714319042',
    projectId: 'aipds-423dd',
    storageBucket: 'aipds-423dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4q0QU-yZxC1uch-g3ujou_MiFaKzaugo',
    appId: '1:728714319042:ios:2adffb9c8279d94dde175b',
    messagingSenderId: '728714319042',
    projectId: 'aipds-423dd',
    storageBucket: 'aipds-423dd.appspot.com',
    iosBundleId: 'com.example.pds',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4q0QU-yZxC1uch-g3ujou_MiFaKzaugo',
    appId: '1:728714319042:ios:7fdc6dd1e029e81fde175b',
    messagingSenderId: '728714319042',
    projectId: 'aipds-423dd',
    storageBucket: 'aipds-423dd.appspot.com',
    iosBundleId: 'com.example.pds.RunnerTests',
  );
}
