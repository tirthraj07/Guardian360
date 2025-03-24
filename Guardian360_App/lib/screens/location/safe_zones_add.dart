import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardians_app/config/base_config.dart';
import 'package:guardians_app/config/travel_alert_service.dart';
import 'package:guardians_app/utils/asset_suppliers/location_page_assets.dart';
import 'package:guardians_app/utils/colors.dart';
import 'package:guardians_app/utils/text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/asset_suppliers/contacts_page_assets.dart';
import '../../utils/asset_suppliers/onboarding_page_assets.dart';

class SafeZonesView extends StatefulWidget {
  final int userID;

  const SafeZonesView({super.key, required this.userID});
  @override
  _SafeZonesViewState createState() => _SafeZonesViewState();
}

class _SafeZonesViewState extends State<SafeZonesView> {
  late GoogleMapController _mapController;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _placeNameController = TextEditingController();
  String placeName = "";
  List<dynamic> _knownPlaces = [];

  Set<Marker> _markers = {};
  late LatLng _selectedLocation = LatLng(18.45751793433902, 73.8508179296451);

  bool addPlace = false;

  void toggleAddPlace() {
    addPlace = !addPlace;
    setState(() {});
  }

  void setCameraToCurrentView() {}

  Future<void> getPlaces() async {
    String url =
        "${DevConfig().travelAlertServiceBaseUrl}safe-places/${widget.userID}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _knownPlaces = List.from(data); // Make sure it's a list

        // Clear existing markers and add new ones
        _markers.clear();

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

  Future<void> createSafePlace() async {
    String url = TravelAlertService.createKnownPlace;

    Map<String, dynamic> requestBody = {
      "userID": widget.userID,
      "location": {
        "latitude": _selectedLocation.latitude,
        "longitude": _selectedLocation.longitude
      },
      "location_name": placeName,
      "place_nick_name": _placeNameController.text
    };

    print("Sending request to: $url");
    print("Request Body: ${jsonEncode(requestBody)}");
    bool isCreated = false;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody), // Send JSON data
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print("Success: $data");

        isCreated = true;
      } else {
        print('Failed to submit form: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      isCreated = false;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          backgroundColor: Colors.white, // White background
          child: Container(
            height: 240.0, // Set height to 200px
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                Text(
                  isCreated ? 'Created' : "Not Created",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Image.asset(
                    isCreated
                        ? ContactsPageAssets.verifiedImage
                        : OnBoardingPageAssets.rejectedImage,
                    height: 150.0), // Add your tick mark image
              ],
            ),
          ),
        );
      },
    );

    _placeNameController.clear();
    _searchController.clear();
    _searchResults = [];
    getPlaces();
    toggleAddPlace();
  }

  final String apiKey = "AIzaSyAVv-fXnoWeN6LG3c7RqAXykXtIUq4scnE";
  List<dynamic> _searchResults = [];

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
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
        _searchResults = results;
      });

      print(_searchResults);
    } else {
      throw Exception('Failed to load places');
    }
  }

  void _selectPlace(LatLng latLng, String placeName) {
    setState(() {
      _selectedLocation = latLng;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(placeName),
        position: latLng,
        infoWindow: InfoWindow(title: placeName),
      ));
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    getPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final bool isVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    if (isVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isVisible;
      });
    }

    return Scaffold(
        backgroundColor: AppColors.darkBlue,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Known Places",
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
                      visible: addPlace,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search for a location",
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
                          _searchPlace(text);
                        },
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (_searchResults.isNotEmpty)
                      Container(
                        height: 150,
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final place = _searchResults[index];
                            final location = place['geometry']['location'];
                            final latLng = LatLng(location['lat'], location['lng']);
                            return ListTile(
                              title: Text(place['name'],
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text(place['formatted_address'],
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                _selectPlace(latLng, place['name']);
                                placeName = place['name'];
                              },
                            );
                          },
                        ),
                      ),
            
                    Visibility(visible: addPlace, child: SizedBox(height: 20)),
                    Visibility(
                      visible: addPlace,
                      child: TextField(
                        controller: _placeNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Place Name",
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
                      ),
                    ),
                    Visibility(visible: addPlace, child: SizedBox(height: 20)),
                    Container(
                      height: 300,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation,
                          zoom: 12,
                        ),
                        markers: _markers,
                        mapType: MapType.normal,
                        onTap: (LatLng latLng) {
                          setState(() {
                            _selectedLocation = latLng;
                            _markers.add(Marker(
                              markerId: MarkerId("selectedLocation"),
                              position: _selectedLocation,
                            ));
                          });
                        },
                      ),
                    ),
                    Visibility(
                        visible: addPlace,
                        child: SizedBox(
                          height: 20,
                        )),
                    Visibility(
                      visible: addPlace,
                      child: ElevatedButton(
                        onPressed: () {
                          createSafePlace();
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
                            child: Text(
                              "Add Place",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 300,
                  child: ListView.builder(
                      itemCount: _knownPlaces.length,
                      itemBuilder: (context, index) {
                        var place = _knownPlaces[index];
                        return InkWell(
                          onTap: () {
                            _focusOnLoc(index);
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: Colors.black38, fontSize: 15),
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
              ],
            ),
          ),
        ),
        floatingActionButton: addPlace == false
            ? FloatingActionButton(
                backgroundColor: AppColors.orange,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  toggleAddPlace();
                })
            : SizedBox.shrink());
  }
}
