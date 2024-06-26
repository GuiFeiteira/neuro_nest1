// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyBqV9pbT7-jXGep6bdAXpvgumn1rCMnwEY',
    appId: '1:1007455009767:web:00203f0fd961b3d0ed1b42',
    messagingSenderId: '1007455009767',
    projectId: 'neuro-nes',
    authDomain: 'neuro-nes.firebaseapp.com',
    storageBucket: 'neuro-nes.appspot.com',
    measurementId: 'G-XW8QLL6G4X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxSmhtoPF6gTiW9zCn5m7hL86-Ezff3Qs',
    appId: '1:1007455009767:android:bf14c86e7fbf5979ed1b42',
    messagingSenderId: '1007455009767',
    projectId: 'neuro-nes',
    storageBucket: 'neuro-nes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDApBKBYrx90Kv_AWzy0zbqp7VnY7egro4',
    appId: '1:1007455009767:ios:8234d85775fbed76ed1b42',
    messagingSenderId: '1007455009767',
    projectId: 'neuro-nes',
    storageBucket: 'neuro-nes.appspot.com',
    iosBundleId: 'com.example.neuroNest1',
  );
}
