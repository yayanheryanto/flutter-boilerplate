import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

class DevFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Replace with actual values from Firebase Console (dev project)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_DEV_ANDROID_API_KEY',
    appId: 'YOUR_DEV_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_DEV_MESSAGING_SENDER_ID',
    projectId: 'YOUR_DEV_PROJECT_ID',
    storageBucket: 'YOUR_DEV_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_DEV_IOS_API_KEY',
    appId: 'YOUR_DEV_IOS_APP_ID',
    messagingSenderId: 'YOUR_DEV_MESSAGING_SENDER_ID',
    projectId: 'YOUR_DEV_PROJECT_ID',
    storageBucket: 'YOUR_DEV_STORAGE_BUCKET',
    iosBundleId: 'com.yayan.boilerplate.dev',
  );
}
