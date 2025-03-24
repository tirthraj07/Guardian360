import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardians_app/config/base_config.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../providers/location_provider.dart';
import '../utils/global_variable.dart'; // For encoding data into JSON

class LocationService {
  static Timer? _locationTimer;
  final int userID;

  LocationService({required this.userID});

  Future<Map<String, double?>> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {'latitude': null, 'longitude': null};
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return {'latitude': null, 'longitude': null};
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return {'latitude': position.latitude, 'longitude': position.longitude};
  }

  Future<void> startTracking(BuildContext context) async {
    print("Tracking started...");

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      print("Location permission denied.");
      return;
    }

    // Start sending location every 2 seconds
    _locationTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _sendLocationToFriend(position, context);
    });
  }

  Future<void> stopTracking() async {
    _locationTimer?.cancel();
    print("Tracking stopped.");
  }

  Future<void> _sendLocationToFriend(Position position, BuildContext context) async {
    try {
      final url = Uri.parse('${DevConfig().travelAlertServiceBaseUrl}location/$userID'); // Replace with actual URL

      final headers = {
        'Content-Type': 'application/json',
      };

      if(travel_mode){
        double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            travel_details["location_details"]['destination']['latitude'],
            travel_details["location_details"]['destination']['longitude']
        );

        print("\ndistance : $distance");
        travel_details['distance_to_destination'] = distance;
      }

      var body = json.encode({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().toIso8601String(),
        if (travel_mode) "travel_details": travel_details,
      });

      // print("Sending location: $body");
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        travel_mode = data['travel_mode'];
        print(travel_mode);

        Provider.of<LocationProvider>(context, listen: false).updateTravelMode(data['travel_mode']);

      } else {
        print("Failed to send location: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending location: $e");
    }
  }
}

// Map<String, dynamic> travel_details = {
//   "location_details": {
//     "source": {
//       "latitude": 0,
//       "longitude": 0
//     },
//     "destination": {
//       "latitude": 0,
//       "longitude": 0
//     },
//     "notification_frequency": 0
//   },
//   "vehicle_details": {
//     "mode_of_travel": "",
//     "vehicle_number": ""
//   }
// };
//
