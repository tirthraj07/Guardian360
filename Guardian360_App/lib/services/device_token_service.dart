import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guardians_app/services/cache_service.dart';

class FirebaseMessagingHelper {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    if (Platform.isIOS) {
      CacheService().savedeviceToken("");
      print("iOS detected, saving empty device token.");
      return;
    }

    try {
      await _firebaseMessaging.requestPermission();

      String? fcmToken = await _firebaseMessaging.getToken();

      CacheService().savedeviceToken(fcmToken ?? "");

      if (fcmToken != null && fcmToken.isNotEmpty) {
        print("Device Token: $fcmToken");
      } else {
        print("Failed to get FCM token, storing empty string.");
      }
    } catch (e) {
      print("Error getting FCM token: $e");
      CacheService().savedeviceToken("");
    }
  }
}
