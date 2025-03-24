import 'package:flutter/cupertino.dart';

bool travel_mode = false;
Map<String, dynamic> travel_details = {
  "location_details": {
    "source": {
      "latitude": 0,
      "longitude": 0
    },
    "destination": {
      "latitude": 0,
      "longitude": 0
    },
    "notification_frequency": 0
  },
  "vehicle_details": {
    "mode_of_travel": "",
    "vehicle_number": ""
  }
};

int notif_no = 0;

BuildContext? contextOfTravelPage;
