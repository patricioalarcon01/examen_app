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
    apiKey: 'AIzaSyDZwAJQjqfpDrI-Hkk5qgIX7P9R6CKgBPs',
    appId: '1:1029377803649:web:13697b2be7b3d8f4315480',
    messagingSenderId: '1029377803649',
    projectId: 'examen-cb29e',
    authDomain: 'examen-cb29e.firebaseapp.com',
    storageBucket: 'examen-cb29e.firebasestorage.app',
    measurementId: 'G-MPHCDYS20Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZ4yCFfYCavEobOdnRvhB7YyXqoOVOY_E',
    appId: '1:1029377803649:android:678ba947ce907e99315480',
    messagingSenderId: '1029377803649',
    projectId: 'examen-cb29e',
    storageBucket: 'examen-cb29e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsSEEL4XM_svzIpuEF75fGxXZqAucbGhw',
    appId: '1:1029377803649:ios:09634cdfd095f976315480',
    messagingSenderId: '1029377803649',
    projectId: 'examen-cb29e',
    storageBucket: 'examen-cb29e.firebasestorage.app',
    iosBundleId: 'com.example.examenApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsSEEL4XM_svzIpuEF75fGxXZqAucbGhw',
    appId: '1:1029377803649:ios:09634cdfd095f976315480',
    messagingSenderId: '1029377803649',
    projectId: 'examen-cb29e',
    storageBucket: 'examen-cb29e.firebasestorage.app',
    iosBundleId: 'com.example.examenApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDZwAJQjqfpDrI-Hkk5qgIX7P9R6CKgBPs',
    appId: '1:1029377803649:web:29b4d240ba131d02315480',
    messagingSenderId: '1029377803649',
    projectId: 'examen-cb29e',
    authDomain: 'examen-cb29e.firebaseapp.com',
    storageBucket: 'examen-cb29e.firebasestorage.app',
    measurementId: 'G-8B8SLMX99Y',
  );
}
