import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardians_app/config/travel_alert_service.dart';
import 'package:http/http.dart' as http;

import '../../utils/asset_suppliers/contacts_page_assets.dart';
import '../../utils/colors.dart';
import '../adhar_upload_page.dart';

class AcceptPendingRequestPage extends StatefulWidget {
  final Map userData;
  const AcceptPendingRequestPage({super.key, required this.userData});

  @override
  State<AcceptPendingRequestPage> createState() => _AcceptPendingRequestPageState();
}

class _AcceptPendingRequestPageState extends State<AcceptPendingRequestPage> {

  @override
  void initState() {
    getPendingRequests();
    super.initState();
  }

  bool _isLoading = false;
  List _pendingRequests = [];

  Future<void> getPendingRequests() async {
    try {
      final userID = widget.userData['userID'];

      // Check if userID is valid
      if (userID == null || userID.isEmpty) {
        print('User ID is null or empty');
        throw Exception('User ID is missing');
      }

      final url = Uri.parse(TravelAlertService.pendingRequests);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userID': userID,
        }),
      );

      print('User ID: $userID');


      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseBody = json.decode(response.body);

          // Safely handle the 'pending_requests' field
          _pendingRequests = responseBody['pending_requests'] ?? [];

          print(_pendingRequests);
          setState(() {});
        } else {
          _pendingRequests = [];
          setState(() {});
          print('Empty response body');
          throw Exception('Received empty response from the server');
        }
      } else {
        _pendingRequests = [];
        setState(() {});
        print('Failed to load pending requests. Status code: ${response.statusCode}');
        throw Exception('Failed to load available friends');
      }
    } catch (e) {
      print("Error occurred while fetching pending requests: $e");
      _pendingRequests = [];
      setState(() {});
      throw Exception('Failed to load available friends');
    }
  }


  Future<void> acceptRequest(List friend_requests) async {
    final url = Uri.parse(TravelAlertService.acceptFriendRequest);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userID': widget.userData['userID'],
        "friend_requests" : friend_requests
      }),
    );


    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      getPendingRequests();
      setState(() {

      });

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
                    'Added Friend',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Image.asset( ContactsPageAssets.verifiedImage, height: 150.0),  // Add your tick mark image
                ],
              ),
            ),
          );

        },
      );

      setState(() {

      });
    } else {
      throw Exception('Failed to load available friends');
    }


    setState(() {
      _isLoading = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Center(child: CircularProgressIndicator(color: AppColors.orange,)),
    )
        : Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Pending Requests",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange)),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "These people have added you as a Friend",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.orange, width: 7),
                    image: DecorationImage(
                        image: AssetImage(
                            ContactsPageAssets.safeCircleImage), fit: BoxFit.cover)),
              ),
              if (_isLoading)
                const LinearProgressIndicator()
              else
                SizedBox(
                  height: 15,
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: _pendingRequests.length,
                  itemBuilder: (context, index) {

                    Map user = _pendingRequests[index];

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: AppColors
                              .lightBlue,
                          // You can change this color if needed
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.orange,
                              backgroundImage: AssetImage(ContactsPageAssets.userProfilePic),
                              radius: 30,
                            ),
                            SizedBox(
                                width:
                                16.0),
                            // Space between avatar and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${user["first_name"]} ${user["last_name"]}",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${user["phone_no"]}",
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                print([user["userID"]]);
                                acceptRequest([user["userID"]]);
                              },
                              child: Image.asset(
                                ContactsPageAssets.selectedTick,
                                width: 30,
                                height: 30,
                                color: Color.fromRGBO(119, 178, 84, 1),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Image.asset(
                              ContactsPageAssets.rejectImage,
                              width: 30,
                              height: 30,
                            )

                            // Displays nothing when unselected
                          ],
                        ),
                      );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
