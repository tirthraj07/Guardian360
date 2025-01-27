import 'package:flutter_background_messenger/flutter_background_messenger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

// add packages

class SmsService {

  final messenger = FlutterBackgroundMessenger();

  Future<void> sendMessage(List<String> phoneNumbers, String message) async {
    if (Platform.isAndroid) {
        try {

          for(int i=0;i<phoneNumbers.length;i++){
            final success = await messenger.sendSMS(
              phoneNumber: phoneNumbers[i],
              message: message,
            );

            if (success) {
              print('SMS sent successfully');
            } else {
              print('Failed to send SMS');
            }
          }

        } catch (e) {
          print('Error sending SMS: $e');
        }
    } else if (Platform.isIOS) {

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumbers[0],
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        print("Could not launch SMS app");
      }
    }
  }
}
