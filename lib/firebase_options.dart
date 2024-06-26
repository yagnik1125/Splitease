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
    apiKey: 'AIzaSyBUu4YNj4wMXFSUOpJkNSrmS2EnR5UFRCQ',
    appId: '1:136201669514:web:0946efeb45959233111673',
    messagingSenderId: '136201669514',
    projectId: 'auhackathon-38707',
    authDomain: 'auhackathon-38707.firebaseapp.com',
    storageBucket: 'auhackathon-38707.appspot.com',
    measurementId: 'G-PTLJWG25Z8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6_eFbrT3gxR9Kvc-T7Ft2HUrYmRUOe1g',
    appId: '1:136201669514:android:cdb4ab941a0212b5111673',
    messagingSenderId: '136201669514',
    projectId: 'auhackathon-38707',
    storageBucket: 'auhackathon-38707.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPLY86NM35mqqDerCT8vrEviphnLO1gSM',
    appId: '1:136201669514:ios:053d0dcecf39310b111673',
    messagingSenderId: '136201669514',
    projectId: 'auhackathon-38707',
    storageBucket: 'auhackathon-38707.appspot.com',
    iosBundleId: 'com.example.auhackathon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPLY86NM35mqqDerCT8vrEviphnLO1gSM',
    appId: '1:136201669514:ios:98d6d084ee8fffa3111673',
    messagingSenderId: '136201669514',
    projectId: 'auhackathon-38707',
    storageBucket: 'auhackathon-38707.appspot.com',
    iosBundleId: 'com.example.auhackathon.RunnerTests',
  );
}
