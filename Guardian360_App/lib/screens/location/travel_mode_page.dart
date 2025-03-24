import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:guardians_app/services/cache_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../config/base_config.dart';
import '../../config/travel_alert_service.dart';
import '../../providers/location_provider.dart';
import '../../services/background_service.dart';
import '../../services/location_service.dart';
import '../../utils/asset_suppliers/contacts_page_assets.dart';
import '../../utils/asset_suppliers/location_page_assets.dart';
import '../../utils/asset_suppliers/onboarding_page_assets.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

import 'package:guardians_app/utils/global_variable.dart';

class TravelModePage extends StatefulWidget {
  final int userID;
  const TravelModePage({super.key, required this.userID});

  @override
  State<TravelModePage> createState() => _TravelModePageState();
}

class _TravelModePageState extends State<TravelModePage> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  GoogleMapController? mapController;
  LatLng? sourceLatLng;
  LatLng? destinationLatLng;
  List<LatLng> polylineCoordinates = [];
  String estimatedTime = "";
  int estimatedTimeInMinutes = 0;
  int notificationFrequency = 0;

  Map<String, double?> currentlocationData = {};

  double distance_left_to_destination = 10000;


  bool viewDestination = false;
  bool viewSource = false;

  final String apiKey =
      "AIzaSyAVv-fXnoWeN6LG3c7RqAXykXtIUq4scnE"; // Replace with your API Key

  // Function to fetch LatLng from address
  Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print("Error fetching LatLng: $e");
    }
    return null;
  }

  int calculateNotificationFrequency(int timeInMinutes) {
    if (timeInMinutes < 15) {
      return 1;
    } else if (timeInMinutes < 30) {
      return 15;
    } else if (timeInMinutes < 60) {
      return 30;
    } else if (timeInMinutes < 300) {
      return 45;
    } else {
      return 75;
    }
  }

  void calculateDistanceToDestination() {
      Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        Position? position = await getCurrentLocation();
        if (position != null && travel_mode == true) {
          double distance = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              travel_details["location_details"]['destination']['latitude'],
              travel_details["location_details"]['destination']['longitude']);

          print("DISTANCE TO DESTINATION LEFT: $distance");

          if(distance_left_to_destination < 50){
            print("TURNING OFF BY DISTANCE");

            turnOffTravelMode(LocationProvider.instance);

          }

          setState(() {
            distance_left_to_destination = distance;
          });
        }
      });
  }

  String formatDistance(double distance) {
    if (distance >= 1000) {
      double km = distance / 1000;
      return "${km.toStringAsFixed(2)} km";  // Format to 2 decimal places
    } else {
      return "${distance.toStringAsFixed(2)} m";
    }
  }

  // Function to fetch route and estimated time
  Future<void> getRoute(sourceLatLng, destinationLatLng, locationProvider) async {
    if (sourceLatLng == null || destinationLatLng == null) {
      print("Invalid source or destination");
      return;
    }

    _markers.clear();

    _markers.add(Marker(
      markerId: MarkerId("source"),
      position: sourceLatLng,
      infoWindow: InfoWindow(title: "Source"),
    ));

    _markers.add(Marker(
      markerId: MarkerId("destination"),
      position: destinationLatLng,
      infoWindow: InfoWindow(title: "Destination"),
    ));

    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${sourceLatLng.latitude},${sourceLatLng.longitude}&destination=${destinationLatLng.latitude},${destinationLatLng.longitude}&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["routes"].isNotEmpty) {
        final route = data["routes"][0];

        polylineCoordinates.clear();
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> result =
            polylinePoints.decodePolyline(route["overview_polyline"]["points"]);

        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        estimatedTime = route["legs"][0]["duration"]["text"];
        print(estimatedTime);

        estimatedTimeInMinutes = parseEstimatedTime(estimatedTime);
        print(estimatedTimeInMinutes);
        notificationFrequency = calculateNotificationFrequency(estimatedTimeInMinutes);
        print("Notification Freq : $notificationFrequency");

        // Adjust camera to fit the polyline route
        _adjustCameraToRoute();

        turnOnTravelMode(locationProvider);

        setState(() {});
      }
    } else {
      print("Error fetching route: ${response.body}");
    }
  }

  void _adjustCameraToRoute() {
    if (_mapController == null || polylineCoordinates.isEmpty) return;

    LatLngBounds bounds = _calculateBounds(polylineCoordinates);

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
          bounds, 50), // Reduced padding (50 instead of 100)
    );

    // Zoom in more if the route is short
    Future.delayed(Duration(milliseconds: 500), () async {
      double distance = _calculateRouteDistance(polylineCoordinates);
      if (distance < 5) {
        // If distance is less than 5 km, zoom in
        await _mapController!.animateCamera(CameraUpdate.zoomIn());
      }
    });
  }

  /// Function to calculate the route distance
  double _calculateRouteDistance(List<LatLng> points) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _getDistanceBetween(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  /// Haversine formula to calculate distance between two LatLng points (in km)
  double _getDistanceBetween(LatLng start, LatLng end) {
    const double R = 6371; // Radius of the Earth in km
    double lat1 = start.latitude * (pi / 180);
    double lon1 = start.longitude * (pi / 180);
    double lat2 = end.latitude * (pi / 180);
    double lon2 = end.longitude * (pi / 180);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  /// Function to calculate bounds for the polyline
  LatLngBounds _calculateBounds(List<LatLng> polylinePoints) {
    double minLat = polylinePoints.first.latitude;
    double minLng = polylinePoints.first.longitude;
    double maxLat = polylinePoints.first.latitude;
    double maxLng = polylinePoints.first.longitude;

    for (var point in polylinePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  late GoogleMapController _mapController;
  String placeName = "";

  TextEditingController _sourceSearchController = TextEditingController();
  TextEditingController _destinationSearchController = TextEditingController();

  List<dynamic> _knownPlaces = [];

  String modeText = 'Select Mode';

  Set<Marker> _markers = {};
  late LatLng _selectedSourceLocation =
      LatLng(18.45751793433902, 73.8508179296451);
  late LatLng _selectedDestinationLocation =
      LatLng(18.45751793433902, 73.8508179296451);

  void setCameraToCurrentView() {}

  Future<void> getPlaces() async {
    String url =
        "${DevConfig().travelAlertServiceBaseUrl}safe-places/${widget.userID}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _knownPlaces = List.from(data); // Make sure it's a list

        for (int i = 0; i < _knownPlaces.length; i++) {
          var place = _knownPlaces[i];
          _markers.add(Marker(
            markerId: MarkerId(place["place_nick_name"]),
            position: LatLng(place["latitude"], place["longitude"]),
          ));
        }

        // If there are any known places, animate camera to the first place
        if (_knownPlaces.isNotEmpty) {
          var firstPlace = _knownPlaces[0];
          _mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(firstPlace["latitude"], firstPlace["longitude"]),
            ),
          );
        }

        LocationService locationService = LocationService(userID: widget.userID);

        currentlocationData = await locationService.getCurrentLocation();;

        print(currentlocationData);

        setState(() {
          // Updates the state only once after all changes
        });

        print("Places Received");
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _focusOnLoc(int index) {
    final friendLocationLatitude = _knownPlaces[index]["latitude"];
    final friendLocationLongitude = _knownPlaces[index]["longitude"];
    if (friendLocationLatitude != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(friendLocationLatitude, friendLocationLongitude),
        ),
      );
    }
  }

  int parseEstimatedTime(String estimatedTime) {
    int totalMinutes = 0;


    List<String> parts = estimatedTime.split(" ");

    for (int i = 0; i < parts.length; i += 2) {
      int value = int.tryParse(parts[i]) ?? 0;
      String unit = parts[i + 1].toLowerCase();

      if (unit.contains("day")) {
        totalMinutes += value * 24 * 60; // Convert days to minutes
      } else if (unit.contains("hour")) {
        totalMinutes += value * 60; // Convert hours to minutes
      } else if (unit.contains("min")) {
        totalMinutes += value; // Already in minutes
      }
    }

    return totalMinutes;
  }

  List<dynamic> _sourceSearchResults = [];
  List<dynamic> _destinationSearchResults = [];

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchPlace(String query, String location) async {
    if (query.isEmpty) {
      setState(() {
        _sourceSearchResults = [];
        _destinationSearchResults = [];
      });
      return;
    }

    final response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      setState(() {
        if (location == "source") {
          _sourceSearchResults = results;
        } else {
          _destinationSearchResults = results;
        }
      });

      print(_sourceSearchResults);
      print(_destinationSearchResults);
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> turnOnTravelMode(locationProvider) async {

    print("Turning on Travel Mode . . . . . . . ");

    Map<String, dynamic> set_travel_details = {
      "location_details": {
        "source": {
          "latitude": sourceLatLng?.latitude,
          "longitude": sourceLatLng?.longitude
        },
        "destination": {
          "latitude": destinationLatLng?.latitude,
          "longitude": destinationLatLng?.longitude
        },
        "notification_frequency": notificationFrequency
      },
      "vehicle_details": {
        "mode_of_travel": modeText,
        "vehicle_number": vehicleNumberController.text
      }
    };

    travel_details = set_travel_details;

    print(travel_details);

    travel_mode = true;
    locationProvider.updateTravelMode(true);
    await CacheService().saveTravelDetails(travel_mode, jsonEncode(travel_details));
    FlutterBackgroundService().invoke("updateTravelMode", {"travel_mode": true, "travel_details" : travel_details});

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          backgroundColor: Colors.white, // White background
          child: Container(

            height: MediaQuery.of(context).size.height * 0.45,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                Text(
                  "Travel Mode On",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                if(modeText == "Taxi")
                Image.asset(
                    LocationPageAssets.taxi_icon,
                    height: 150.0),
                if(modeText == "Auto Rikshaw")
                  Image.asset(
                      LocationPageAssets.riksha_icon,
                      height: 150.0),
                if(modeText == "Bus")
                  Image.asset(
                      LocationPageAssets.bus_icon,
                      height: 150.0),
                if(modeText == "Metro")
                  Image.asset(
                      LocationPageAssets.metro_icon,
                      height: 150.0),

              SizedBox(height: 20,),

              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Travel Mode: ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                          ),
                          TextSpan(
                            text: modeText,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Estimated Time: ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                          ),
                          TextSpan(
                            text: estimatedTime,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Your Friends & Family will be notified after ",
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "$notificationFrequency mins ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "interval periodically",
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),// Add your tick mark image
              ],
            ),
          ),
        );
      },
    );

  }

  void _selectPlace(LatLng latLng, String placeName, String location) {
    setState(() {
      if (location == "source") {
        _selectedSourceLocation = latLng;
      } else {
        _selectedDestinationLocation = latLng;
      }
      _markers.clear();
      _markers.add(Marker(
  markerId: MarkerId(placeName),
  position: latLng,
  infoWindow: InfoWindow(title: placeName),
  ));
});

if (location == "source") {
_mapController.animateCamera(
CameraUpdate.newLatLng(_selectedSourceLocation),
);
} else {
_mapController.animateCamera(
CameraUpdate.newLatLng(_selectedDestinationLocation),
);
}
}



  Future<void> turnOffTravelMode(locationProvider) async {

    print("Turning OFF travel mode ...");

    final response = await http.get(
      Uri.parse("${DevConfig().travelAlertServiceBaseUrl}location/travel-mode-off/${widget.userID}"),
      headers: {
        "Content-Type": "application/json",  // Set the content type to application/json
      },
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print(data);

      setState(() {
      });
    } else {
      throw Exception('Failed to Turn of Travel Mode');
    }


    locationProvider.updateTravelMode(false);
    travel_mode = false;

    print(travel_mode);
    await CacheService().saveTravelDetails(travel_mode, jsonEncode(travel_details));

    FlutterBackgroundService().invoke("updateTravelMode", {"travel_mode": false, "travel_details" : travel_details});
    setState(() {

    });
  }

  Future<void> getTravelDetails() async {
    print("Fetching Travel Details");
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

    setState(() {

    });
  }


  @override
  void initState() {
    print("Page Loaded");
    getPlaces();
    getTravelDetails();
    calculateDistanceToDestination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print("UI REBUILDING");

    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child)
    {

      print("Travel Mode by Provider : ${locationProvider.travelMode}");
      return Scaffold(
        backgroundColor: AppColors.darkBlue,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: SizedBox.shrink(),
          title: Text(
            "Travel Mode Details",
            style: AppTextStyles.title.copyWith(color: AppColors.orange),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: !locationProvider.travelMode,
                  child: TextField(
                    controller: _sourceSearchController,
                    decoration: InputDecoration(
                      hintText: "Source Location",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.darkBlue,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      _searchPlace(text, "source");
                      viewSource = false;
                      setState(() {

                      });
                    },
                    onTap: () {
                      viewSource = true;
                      setState(() {

                      });
                    },
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (_sourceSearchResults.isNotEmpty)
                  Container(
                    height: 150,
                    child: ListView.builder(
                      itemCount: _sourceSearchResults.length,
                      itemBuilder: (context, index) {
                        final place = _sourceSearchResults[index];
                        final location = place['geometry']['location'];
                        final latLng = LatLng(location['lat'], location['lng']);
                        return ListTile(
                          title: Text(place['name'],
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(place['formatted_address'],
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            _selectPlace(latLng, place['name'], "source");
                            placeName = place['name'];
                            _sourceSearchController.text = placeName;
                            _sourceSearchResults = [];
                            sourceLatLng = latLng;
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                Visibility(visible: viewSource, child: SizedBox(height: 20)),
                Visibility(
                  visible: viewSource,
                  child: InkWell(
                    onTap: () {
                      print("Current : ");

                      viewSource = false;
                      setState(() {

                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        // Transparent fill color
                        border:
                        Border.all(color: Colors.blue, width: 1.5),
                        // Blue border
                        borderRadius: BorderRadius.circular(
                            10), // Rounded corners
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(height: 25,
                              child: Image(image: AssetImage(
                                  LocationPageAssets.curr_loc)),),
                            SizedBox(width: 10,),
                            Text(
                              "Current Location",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(visible: !travel_mode, child: SizedBox(height: 20)),

                Visibility(
                  visible: !travel_mode,
                  child: TextField(
                    controller: _destinationSearchController,
                    onTap: () {
                      viewDestination = true;
                      setState(() {

                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Destination Location",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.darkBlue,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      _searchPlace(text, "destination");
                      viewDestination = false;
                      setState(() {

                      });
                    },
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Visibility(
                    visible: viewDestination, child: SizedBox(height: 10,)),

                Visibility(
                  visible: viewDestination,
                  child: Container(
                    height: 200,
                    child: ListView.builder(
                        itemCount: _knownPlaces.length,
                        itemBuilder: (context, index) {
                          var place = _knownPlaces[index];
                          return InkWell(
                            onTap: () {
                              final friendLocationLatitude = _knownPlaces[index]["latitude"];
                              final friendLocationLongitude = _knownPlaces[index]["longitude"];

                              LatLng latLng = LatLng(friendLocationLatitude,
                                  friendLocationLongitude);

                              _selectPlace(latLng, place["place_nick_name"],
                                  "destination");
                              placeName = place["place_nick_name"];
                              _destinationSearchController.text = placeName;
                              _destinationSearchResults = [];
                              destinationLatLng = latLng;
                              viewDestination = false;

                              print(viewDestination);
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                // You can change this color if needed
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.orange,
                                    backgroundImage: AssetImage(
                                        LocationPageAssets.location_icon),
                                    radius: 30,
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          place["place_nick_name"],
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          place["location_name"],
                                          style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),

                if (_destinationSearchResults.isNotEmpty)
                  Container(
                    height: 150,
                    child: ListView.builder(
                      itemCount: _destinationSearchResults.length,
                      itemBuilder: (context, index) {
                        final place = _destinationSearchResults[index];
                        final location = place['geometry']['location'];
                        final latLng = LatLng(location['lat'], location['lng']);
                        return ListTile(
                          title: Text(place['name'],
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(place['formatted_address'],
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            _selectPlace(latLng, place['name'], "destination");
                            placeName = place['name'];
                            placeName = place['name'];
                            _destinationSearchController.text = placeName;
                            _destinationSearchResults = [];
                            destinationLatLng = latLng;
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                Visibility(visible: !travel_mode, child: SizedBox(height: 20)),
                Container(
                  height: 350,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _selectedSourceLocation,
                      zoom: 12,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("route"),
                        points: polylineCoordinates,
                        color: Colors.blue,
                        width: 5,
                      ),
                    },
                    markers: _markers,
                    mapType: MapType.normal,
                    onTap: (LatLng latLng) {
                      setState(() {
                        _selectedSourceLocation = latLng;
                        _markers.add(Marker(
                          markerId: MarkerId("selectedLocation"),
                          position: _selectedSourceLocation,
                        ));
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: !travel_mode,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: !travel_mode,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Travel Details",
                          style: AppTextStyles.bold.copyWith(fontSize: 17))),
                ),
                Visibility(
                  visible: !travel_mode,
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Visibility(
                  visible: !travel_mode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          modeText = "Taxi";
                          setState(() {});
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Image(
                              image: AssetImage(LocationPageAssets.taxi_icon)),
                          decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          modeText = "Auto Rikshaw";
                          setState(() {});
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 11),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(-1.0, 1.0, 1.0),
                            child: Image(
                                image: AssetImage(
                                    LocationPageAssets.riksha_icon)),
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          modeText = "Bus";
                          setState(() {});
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child:
                          Image(image: AssetImage(LocationPageAssets.bus_icon)),
                          decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          modeText = "Metro";
                          setState(() {});
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Image(
                              image: AssetImage(LocationPageAssets.metro_icon)),
                          decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !travel_mode,
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Visibility(
                  visible: !travel_mode,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Transparent fill color
                      border:
                      Border.all(color: Colors.blue, width: 1.5), // Blue border
                      borderRadius: BorderRadius.circular(
                          10), // Rounded corners
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        modeText,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Visibility(visible: !travel_mode, child: SizedBox(height: 20,)),
                Visibility(
                  visible: !travel_mode,
                  child: TextField(
                    controller: vehicleNumberController,
                    decoration: InputDecoration(
                      hintText: "Vehicle Number",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.darkBlue,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if(modeText == "Taxi" && travel_mode == true)
                  Image.asset(
                      LocationPageAssets.taxi_icon,
                      height: 200.0),
                if(modeText == "Auto Rikshaw" && travel_mode == true)
                  Image.asset(
                      LocationPageAssets.riksha_icon,
                      height: 200.0),
                if(modeText == "Bus" && travel_mode == true)
                  Image.asset(
                      LocationPageAssets.bus_icon,
                      height: 200.0),
                if(modeText == "Metro" && travel_mode == true)
                  Image.asset(
                      LocationPageAssets.metro_icon,
                      height: 200.0),
                Visibility(visible: travel_mode,
                    child: Text("Time : $estimatedTime",
                      style: AppTextStyles.bold.copyWith(
                          color: Colors.white, fontSize: 16),)),
                SizedBox(height: 20,),
                Visibility(visible: travel_mode,
                    child: Text("Distance to Destination : ${formatDistance(distance_left_to_destination)}",
                      style: AppTextStyles.bold.copyWith(
                          color: Colors.white, fontSize: 16),)),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    if (!travel_mode)
                      getRoute(sourceLatLng, destinationLatLng, locationProvider);
                    else {
                      turnOffTravelMode(locationProvider);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            travel_mode ? "Turn Off" : "Start Travel",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    );
  }
}
