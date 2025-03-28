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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyB78A5CZZ6UygiRsOfroNzh0knciZqiPrs',
    appId: '1:967060972030:web:6105350a40959defa360af',
    messagingSenderId: '967060972030',
    projectId: 'todotask-c81ce',
    authDomain: 'todotask-c81ce.firebaseapp.com',
    storageBucket: 'todotask-c81ce.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmVS7P3y8H4pVeToNTnJJ4HAXJAASa2mw',
    appId: '1:967060972030:android:631a1918d06ed73aa360af',
    messagingSenderId: '967060972030',
    projectId: 'todotask-c81ce',
    storageBucket: 'todotask-c81ce.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCE9Pl0dAEFN1X_e9IRJIh4Fi7H4cZtwsw',
    appId: '1:967060972030:ios:9e893bfb0982d530a360af',
    messagingSenderId: '967060972030',
    projectId: 'todotask-c81ce',
    storageBucket: 'todotask-c81ce.firebasestorage.app',
    iosBundleId: 'com.example.todoTask',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCE9Pl0dAEFN1X_e9IRJIh4Fi7H4cZtwsw',
    appId: '1:967060972030:ios:9e893bfb0982d530a360af',
    messagingSenderId: '967060972030',
    projectId: 'todotask-c81ce',
    storageBucket: 'todotask-c81ce.firebasestorage.app',
    iosBundleId: 'com.example.todoTask',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB78A5CZZ6UygiRsOfroNzh0knciZqiPrs',
    appId: '1:967060972030:web:6f8900ea8f216895a360af',
    messagingSenderId: '967060972030',
    projectId: 'todotask-c81ce',
    authDomain: 'todotask-c81ce.firebaseapp.com',
    storageBucket: 'todotask-c81ce.firebasestorage.app',
  );
}
