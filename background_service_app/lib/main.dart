import 'package:flutter/material.dart';
import 'package:background_service_app/service/background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  disableBatteryOptimization();
  await initService();
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  // Request location permission
  var locationStatus = await Permission.location.request();
  if (locationStatus.isDenied) {
    // Handle the case when the user denies the permission
    print("Location permission denied");
  }

  // Request location always permission
  var locationAlwaysStatus = await Permission.locationAlways.request();
  if (locationAlwaysStatus.isDenied) {
    print("Location always permission denied");
  }

  // Request notification permission
  var notificationStatus = await Permission.notification.request();
  if (notificationStatus.isDenied) {
    print("Notification permission denied");
  }
}

Future<void> disableBatteryOptimization() async {
  // Launch the intent to disable battery optimization
  final AndroidIntent intent = AndroidIntent(
    action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
  );
  await intent.launch();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Guardian360 Project',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
