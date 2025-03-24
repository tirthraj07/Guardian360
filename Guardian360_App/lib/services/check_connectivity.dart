import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardians_app/services/sms_service.dart';

import 'cache_service.dart';

class InternetConnectivityInApp {
  static final InternetConnectivityInApp _instance = InternetConnectivityInApp._internal();

  factory InternetConnectivityInApp() {
    return _instance;
  }

  InternetConnectivityInApp._internal();

  final Connectivity _connectivity = Connectivity();
  DateTime? disconnectedSince;

  void listenToConnectivity(BuildContext context) {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      checkConnectivity(results, context);
    });
  }

  Timer? disconnectTimer; // To keep track of the timer instance

  void checkConnectivity(List<ConnectivityResult> results, BuildContext context) {
    if (!context.mounted) return;

    bool isConnected = results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi);

    if (!isConnected) {
      if (disconnectedSince == null) {
        disconnectedSince = DateTime.now(); // Record the disconnection time

        // Start a timer to print the disconnected time every second
        disconnectTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
          if (disconnectedSince != null) {
            print("Disconnected since: $disconnectedSince (${DateTime.now().difference(disconnectedSince!).inSeconds} seconds ago)");
          }

          if (DateTime.now().difference(disconnectedSince!).inMinutes >= 5) {
            showSnackbar(context, "Internet has been disconnected for 5 minutes", Colors.orange);

            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) return;

            LocationPermission permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied) return;
            }

            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);

            await Future.delayed(Duration(milliseconds: 1500));
            String? userDataString = await CacheService().getData("user_data");

            if (userDataString == null || userDataString.isEmpty) {
              userDataString = '{}'; // Set default empty JSON if no data is found
            }
            print("\n\n");
            var userData = jsonDecode(jsonDecode(userDataString));

            print("\nFETCHING FRIEND");

            var battery = Battery();
            var userBattery = await battery.batteryLevel;

            String messageToSend = """Guardian360-${userData['userID']}-{"LAT":"${position.latitude}","LONG":"${position.longitude}","TYPE":"WIFI_LOST", "BATTERY" : "$userBattery%"}""";

            SmsService().sendMessage(['+918767945245'], messageToSend);

            timer.cancel();
          }
        });
      }

      showSnackbar(context, "No Internet Connection", Colors.red);
    } else {
      disconnectedSince = null; // Reset if reconnected
      disconnectTimer?.cancel(); // Stop the timer
      showSnackbar(context, "Connected to the Internet", Colors.green);
    }
  }

  void showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
