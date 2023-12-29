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
    apiKey: 'AIzaSyB-SY_D23TR1DDkxUtIeyRP75JOuHmJdbQ',
    appId: '1:517410568677:web:143e16b38145d2772d570c',
    messagingSenderId: '517410568677',
    projectId: 'quizup-cb656',
    authDomain: 'quizup-cb656.firebaseapp.com',
    storageBucket: 'quizup-cb656.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCO1ig9VaLoeY33SnvA8C9wQLhvgjb7To',
    appId: '1:517410568677:android:c9cb495c6ab7f4902d570c',
    messagingSenderId: '517410568677',
    projectId: 'quizup-cb656',
    storageBucket: 'quizup-cb656.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDC-eqZl1aa5Z90iRqtH_sLkPWeLwHA7Lw',
    appId: '1:517410568677:ios:230f32eda3a5321f2d570c',
    messagingSenderId: '517410568677',
    projectId: 'quizup-cb656',
    storageBucket: 'quizup-cb656.appspot.com',
    iosBundleId: 'com.example.quizup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDC-eqZl1aa5Z90iRqtH_sLkPWeLwHA7Lw',
    appId: '1:517410568677:ios:0ddf472fa01896862d570c',
    messagingSenderId: '517410568677',
    projectId: 'quizup-cb656',
    storageBucket: 'quizup-cb656.appspot.com',
    iosBundleId: 'com.example.quizup.RunnerTests',
  );
}
