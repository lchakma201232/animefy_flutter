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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDCK1JBUYs6vgeNpoUt7RyJtL5gJqlMSEE',
    appId: '1:464032562133:web:fdf3ac53f4a8cd0edbdb5c',
    messagingSenderId: '464032562133',
    projectId: 'animefy-c5d92',
    authDomain: 'animefy-c5d92.firebaseapp.com',
    storageBucket: 'animefy-c5d92.appspot.com',
    measurementId: 'G-WYV5FZV5S4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvTBpkNcCZmpZef_TiWO9PkS5uarDfgAE',
    appId: '1:464032562133:android:f2121e76122b0161dbdb5c',
    messagingSenderId: '464032562133',
    projectId: 'animefy-c5d92',
    storageBucket: 'animefy-c5d92.appspot.com',
  );
}
