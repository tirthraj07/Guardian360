import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardians_app/auth_wrapper.dart';
import 'package:guardians_app/firebase_options.dart';
import 'package:guardians_app/providers/location_provider.dart';
import 'package:guardians_app/screens/adhar_upload_page.dart';
import 'package:guardians_app/screens/friend_pages/contact_page.dart';
import 'package:guardians_app/screens/home_screen.dart';
import 'package:guardians_app/services/background_service.dart';
import 'package:guardians_app/services/cache_service.dart';
import 'package:guardians_app/services/device_token_service.dart';
import 'package:guardians_app/utils/global_variable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/base_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessagingHelper().initNotifications();



  await requestPermissions();
  disableBatteryOptimization();

  runApp(
    ChangeNotifierProvider<LocationProvider>.value(
      value: LocationProvider.instance, // Ensure using the singleton
      child: MyApp(),
    ),
  );



  String? userDataString = await CacheService().getData("user_data");
  var userData = {};

  if (userDataString != null && userDataString.isNotEmpty) {
    try {
      userData = jsonDecode(jsonDecode(userDataString));
      print("User ID FETCHED IN MAIN : ${userData['userID']}");
    } catch (e) {
      print("Error parsing user data: $e");
    }
  }

  print(userData['userID']);

  await getTravelDetails();

  if(userData['userID'] != null){
    Future.delayed(Duration.zero, () async {
      await initService();
    });
  }
  else{
    print("Skipping Bakcground Service since not Authenticated");
  }

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
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final manufacturer = androidInfo.manufacturer.toLowerCase();
  final model = androidInfo.model.toLowerCase();

  // Check if battery optimization is already disabled
  bool isIgnoringBatteryOptimizations = await Permission.ignoreBatteryOptimizations.isGranted;

  if (!isIgnoringBatteryOptimizations) {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
      data: 'com.ameyTech.guardians_app', // Replace with your actual package name
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }
}

Future<void> getTravelDetails() async {
  print("Fetching Travel Details IN MAIN");
  var travel_mode_nullable = (await CacheService().getTravelmode(
      'travel_mode'));

  var data = await CacheService().getData('travel_details');

  if(data != null){
    travel_details = jsonDecode(data);
  }


  print("RECEIVED TRAVEL MODE  : $travel_mode_nullable");

  print("Data FETCHED FROM CACHE ON PAGE LOAD");

  if (travel_mode_nullable != null) {
    travel_mode = travel_mode_nullable;
    LocationProvider.instance.updateTravelMode(travel_mode);
    FlutterBackgroundService().invoke("updateTravelMode",
        {"travel_mode": travel_mode, "travel_details": travel_details});
    print("Function invoked");
  }
  else {
    print("Cache was null");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690), // Your design size
      builder: (_, child) => MaterialApp(
        title: 'Guardians',
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(), // Ensure you're using AuthWrapper as the home widget
      ),
    );
  }
}

