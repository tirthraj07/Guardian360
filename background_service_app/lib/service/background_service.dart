import 'dart:async';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> initService() async {
  final service = FlutterBackgroundService();
  await service.configure(iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration
        (
          onStart: onStart,
          isForegroundMode: true,
          autoStart: true
        )
    );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();


  if (service is AndroidServiceInstance){
    // Making the app run in foreground mode so that app is not killed
    service.setAsForegroundService();

    service.on('setAsForeground').listen((event){
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event){
      service.setAsBackgroundService();
    });

  }
  service.on('stopService').listen((event){
    service.stopSelf();
  });

  // Changed interval from 1s → 5s to prevent rate limiting & battery drain
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    Position? position = await getCurrentLocation();
    if (position != null) {
      print("User Location: Lat: ${position.latitude}, Lng: ${position.longitude}");
      await _sendLocationToWebhook(position, 27);
    }
  });

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

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

Future<void> _sendLocationToWebhook(Position position, int userID) async {
  try {
    final url = Uri.parse(
        'http://143.110.177.251/travel-service/location/$userID');
    final headers = {
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String()
    });
    final response = await http.post(url, headers: headers, body: body);
    print("Status code : ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Sent Location to Backend");
      print("Data : $data");
    } else {
      print("Failed to send location: ${response.statusCode}");
    }
  }
  catch (e) {
    print("Error sending location: $e");
  }
  }