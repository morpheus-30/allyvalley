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
    apiKey: 'AIzaSyCeO6G5lmJlf02XLYqtR7QFo7UZ0EjZXWk',
    appId: '1:647979977158:web:28723a091a4f3cc58fcac7',
    messagingSenderId: '647979977158',
    projectId: 'allyvalley-83',
    authDomain: 'allyvalley-83.firebaseapp.com',
    storageBucket: 'allyvalley-83.appspot.com',
    measurementId: 'G-G72JHL9YB4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCykhjpeEYeFanVgSOsW4TnpjEsMtIidH4',
    appId: '1:647979977158:android:c672747c6c865c778fcac7',
    messagingSenderId: '647979977158',
    projectId: 'allyvalley-83',
    storageBucket: 'allyvalley-83.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzSgPW-UbGW-pHJsx5pPIQPP5UV5IS0Mo',
    appId: '1:647979977158:ios:b10d62213ab3aa088fcac7',
    messagingSenderId: '647979977158',
    projectId: 'allyvalley-83',
    storageBucket: 'allyvalley-83.appspot.com',
    iosBundleId: 'com.example.allyvalley',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzSgPW-UbGW-pHJsx5pPIQPP5UV5IS0Mo',
    appId: '1:647979977158:ios:d7e71a0e7ccc2fe58fcac7',
    messagingSenderId: '647979977158',
    projectId: 'allyvalley-83',
    storageBucket: 'allyvalley-83.appspot.com',
    iosBundleId: 'com.example.allyvalley.RunnerTests',
  );
}