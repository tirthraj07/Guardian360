import 'dart:async';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:guardians_app/config/base_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import '../utils/global_variable.dart';
import 'cache_service.dart';

Future<void> initService() async {
  print("Reached");
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));

  // ✅ Main Isolate listens for background updates
  service.on("updateTravelMode").listen((event) {
    bool updatedTravelMode = event?["travel_mode"] ?? false;

    print("🟠 UI Thread: Received travel mode update from background: $updatedTravelMode");

    // Update Provider in UI isolate
    LocationProvider.instance.updateTravelMode(updatedTravelMode);
  });
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // ✅ Background Isolate listens for main thread updates
  service.on("updateTravelMode").listen((event) {
    bool updatedMode = event?["travel_mode"] ?? false;
    travel_mode = updatedMode;
    travel_details = event?["travel_details"] ?? {};

    print("🟥 Background Isolate: Received travel_mode = $travel_mode");
    print("🟥 Background Isolate: Received travel_details = $travel_details");

    // Send data to main thread
    FlutterBackgroundService().invoke("updateTravelMode", {"travel_mode": travel_mode});
  });

  Future<void> fetchUserDataAndStartTracking() async {
    String? userDataString = await CacheService().getData("user_data");
    var userData = {};

    if (userDataString != null && userDataString.isNotEmpty) {
      try {
        userData = jsonDecode(jsonDecode(userDataString));
        print("User ID FETCHED IN BACKGROUND SERVICE : ${userData['userID']}");
      } catch (e) {
        print("Error parsing user data: $e");
      }
    }

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
      service.on('setAsForeground').listen((event) => service.setAsForegroundService());
      service.on('setAsBackground').listen((event) => service.setAsBackgroundService());
    }
    service.on('stopService').listen((event) => service.stopSelf());

    // Start periodic location updates after a delay to avoid UI blocking
    Future.delayed(const Duration(seconds: 2), () {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        Position? position = await getCurrentLocation();
        if (position != null) {
          print("User Location: Lat: ${position.latitude}, Lng: ${position.longitude}");
          await _sendLocationToFriend(position, int.tryParse(userData['userID']?.toString() ?? '0') ?? 0);
        }
      });
    });
  }

  fetchUserDataAndStartTracking();
}

Future<Position?> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permission denied");
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    print("Location permission permanently denied");
    return null;
  }

  try {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10));
  } catch (e) {
    print("Error getting current location, retrying: $e");
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

Future<void> _sendLocationToFriend(Position position, int userID) async {
  try {
    final url = Uri.parse('${DevConfig().travelAlertServiceBaseUrl}location/$userID');
    final headers = {'Content-Type': 'application/json'};
    print("Travel Mode : $travel_mode");

    double distance = 0;
    if (travel_mode) {
      print("Inside Travel Mode");

      distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          travel_details["location_details"]['destination']['latitude'],
          travel_details["location_details"]['destination']['longitude']);

      print("\ndistance : $distance");
      travel_details['distance_to_destination'] = distance;
    }

    var body = json.encode({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String(),
      if (travel_mode && distance > 50) "travel_details": travel_details,

    });

    print(jsonDecode(body));

    final response = await http.post(url, headers: headers, body: body);
    print("Status code : ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      travel_mode = data['travel_mode'];
      print("Travel Mode : $travel_mode");

      if(travel_mode != null){
        print("Recieved From Server : $travel_mode");
        await CacheService().saveTravelDetails(travel_mode, jsonEncode(travel_details));
        FlutterBackgroundService().invoke("updateTravelMode", {"travel_mode": travel_mode} );
      }
      print("Data : $data");
    } else {
      print("Failed to send location: ${response.statusCode}");
    }
  } catch (e) {
    print("Error sending location: $e");
  }
}
