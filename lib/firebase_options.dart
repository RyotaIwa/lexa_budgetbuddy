import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR-WEB-API-KEY',
    appId: '1:YOUR-PROJECT-NUMBER:web:YOUR-APP-ID',
    messagingSenderId: 'YOUR-PROJECT-NUMBER',
    projectId: 'bagsdrop-56b3d',
    authDomain: 'bagsdrop-56b3d.firebaseapp.com',
    storageBucket: 'bagsdrop-56b3d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdMlZe6ZVK6O7Rmonnlc6yCRRsUzenA3Y',
    appId: '1:716093056147:android:d569b42d97379733535966',
    messagingSenderId: '716093056147',
    projectId: 'budgetbuddy-43bd9',
    storageBucket: 'budgetbuddy-43bd9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-IOS-API-KEY',
    appId: '1:YOUR-PROJECT-NUMBER:ios:YOUR-APP-ID',
    messagingSenderId: 'YOUR-PROJECT-NUMBER',
    projectId: 'bagsdrop-56b3d',
    storageBucket: 'bagsdrop-56b3d.appspot.com',
    iosBundleId: 'com.example.bagsdrop',
  );
}
