import 'package:flutter/cupertino.dart';
import 'package:flutter_background_messenger/flutter_background_messenger.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

// add packages

class SmsService {

  final messenger = FlutterBackgroundMessenger();

  Future<void> sendMessage(String phoneNumber, String message) async {
    debugPrint("Inside sendMessage function. Received $phoneNumber and message: $message");
    if (Platform.isAndroid) {
      try {
        final success = await messenger.sendSMS(
          phoneNumber: phoneNumber,
          message: message,
        );

        if (success) {
          print('SMS sent successfully to $phoneNumber');
        } else {
          print('Failed to send SMS to $phoneNumber');
        }
      } catch (e) {
        print('Error sending SMS: $e');
      }
    }
  }
}
