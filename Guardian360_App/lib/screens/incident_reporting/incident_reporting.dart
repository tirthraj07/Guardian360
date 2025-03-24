import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardians_app/config/base_config.dart';
import 'package:guardians_app/config/incident_reporting_service.dart';
import 'package:guardians_app/utils/colors.dart';
import 'package:guardians_app/utils/text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/asset_suppliers/contacts_page_assets.dart';
import '../../utils/asset_suppliers/onboarding_page_assets.dart';

class IncidentReportingPage extends StatefulWidget {
  final int userID;

  const IncidentReportingPage({super.key, required this.userID});
  @override
  _IncidentReportingPageState createState() => _IncidentReportingPageState();
}

class _IncidentReportingPageState extends State<IncidentReportingPage> {
  late GoogleMapController _mapController;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Set<Marker> _markers = {};
  late LatLng _selectedLocation = LatLng(18.45751793433902, 73.8508179296451);

  final String apiKey = "AIzaSyAVv-fXnoWeN6LG3c7RqAXykXtIUq4scnE";
  List<dynamic> _searchResults = [];

  Map? selectedType;
  Map? selectedSubType;
  String? selectedPlace;
  List types = [];
  List subTypes =  [];

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

  Future<void> getTypes() async {
    print("HELLO");
    String url = IncidentReportingService.get_types;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        types = data['types'];

        setState(() {

        });

      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() {

    });
  }

  Future<void> getSubTypes() async {
    String url = "${DevConfig().incidentReportingServiceBaseUrl}incident/${selectedType?['typeID']}/subtypes";

    print(url);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        subTypes = data['sub_types'];

        setState(() {

        });

      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() {

    });
  }

  Future<void> submitFormToServer() async {
    String url = IncidentReportingService.createReport;


    Map<String, dynamic> requestBody = {
      "userID": widget.userID,
      "typeID": selectedType?['typeID'] ?? 1,
      "subtypeID": selectedSubType?['subtypeID'] ?? 1,
      "description": _descriptionController.text,
      "latitude": _selectedLocation.latitude,
      "longitude": _selectedLocation.longitude,
      "place_name": selectedPlace
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
            borderRadius: BorderRadius.circular(20.0),  // Rounded corners
          ),
          backgroundColor: Colors.white,  // White background
          child: Container(
            height: 240.0,  // Set height to 200px
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                Text(
                  isCreated ? 'Submitted' : "Not Submitted",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Image.asset( isCreated ? ContactsPageAssets.verifiedImage : OnBoardingPageAssets.rejectedImage, height: 150.0),  // Add your tick mark image
              ],
            ),
          ),
        );
      },
    );

    _descriptionController.clear();
    _searchController.clear();
  }

  void _submitForm() {

    submitFormToServer();
    // Send this data to your backend API
  }

  @override
  void initState() {
    getTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text(
          "Incident Reporting",
          style: AppTextStyles.title.copyWith(color: AppColors.orange),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField(
                value: selectedType,
                hint: Text(
                  "Select Type",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                items: types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type['type'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedType = value as Map?;
                    print(selectedType);

                    selectedSubType = null;


                  });
                  await getSubTypes();
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                iconSize: 30,
                isExpanded: true,
                dropdownColor: AppColors.darkBlue,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                value: selectedSubType,
                hint: Text(
                  "Select Sub-Type",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  items: subTypes.map((subType) {
                    return DropdownMenuItem(
                      value: subType,
                      child: Text(
                        subType['sub_type'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubType = value as Map?;
                      print(selectedSubType);
                    });
                  },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                iconSize: 30,
                isExpanded: true,
                dropdownColor: AppColors.darkBlue,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Short Description',
                  hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: AppColors.darkBlue,
                ),
                maxLines: 4,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              TextField(
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
              if (_searchResults.isNotEmpty)
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final place = _searchResults[index];
                      selectedPlace = place['name'];
                      final location = place['geometry']['location'];
                      final latLng = LatLng(location['lat'], location['lng']);
                      return ListTile(
                        title: Text(place['name'],
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(place['formatted_address'],
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          _selectPlace(latLng, place['name']);
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
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
                      _markers.clear();
                      _markers.add(Marker(
                        markerId: MarkerId("selectedLocation"),
                        position: _selectedLocation,
                      ));
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
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
                      "Submit Form",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
}
