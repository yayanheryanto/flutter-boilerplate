import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;

class StagingFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Not supported for this platform.');
    }
  }

  // TODO: Replace with actual staging Firebase values
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_STAGING_ANDROID_API_KEY',
    appId: 'YOUR_STAGING_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_STAGING_MESSAGING_SENDER_ID',
    projectId: 'YOUR_STAGING_PROJECT_ID',
    storageBucket: 'YOUR_STAGING_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_STAGING_IOS_API_KEY',
    appId: 'YOUR_STAGING_IOS_APP_ID',
    messagingSenderId: 'YOUR_STAGING_MESSAGING_SENDER_ID',
    projectId: 'YOUR_STAGING_PROJECT_ID',
    storageBucket: 'YOUR_STAGING_STORAGE_BUCKET',
    iosBundleId: 'com.yayan.boilerplate.staging',
  );
}
