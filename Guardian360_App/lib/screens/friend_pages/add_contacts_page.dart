import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:guardians_app/config/base_config.dart';
import 'package:guardians_app/config/travel_alert_service.dart';
import 'package:guardians_app/utils/colors.dart';
import 'package:http/http.dart' as http;

import '../../services/cache_service.dart';
import '../../utils/asset_suppliers/contacts_page_assets.dart';
import '../home_screen.dart';

class AddCloseFriendsHomePage extends StatefulWidget {
  const AddCloseFriendsHomePage({Key? key}) : super(key: key);

  @override
  _AddCloseFriendsHomePageState createState() => _AddCloseFriendsHomePageState();
}

class _AddCloseFriendsHomePageState extends State<AddCloseFriendsHomePage> {
  final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();
  List<Contact> _contacts = [];
  List<String> _selectedContacts = [];
  List<int> _selectedContactUserIds = [];
  List _availableFriends = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    getUserData();
  }

  var userData = {};

  Future<void> getUserData() async {
    await Future.delayed(Duration(milliseconds: 1500));
    String? userDataString = await CacheService().getData("user_data");

    if (userDataString == null || userDataString.isEmpty) {
      userDataString = '{}'; // Set default empty JSON if no data is found
    }
    print("\n\n");
    userData = jsonDecode(jsonDecode(userDataString));
    setState(() {
    });

    print("\nFETCHING FRIEND");

    getAvailableFriends();
  }

  Future<void> getAvailableFriends() async {
    final url = Uri.parse(TravelAlertService.availableFriend);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userID': userData['userID'],
      }),
    );

    print(userData['userID']);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("\n\n${responseBody['available_friends']}");
      _availableFriends = responseBody['available_friends'];
      setState(() {

      });
    } else {
      throw Exception('Failed to load available friends');
    }



    setState(() {
      _isLoading = false;
    });
  }

  Future<void> sendRequest() async {
    final url = Uri.parse('${DevConfig().travelAlertServiceBaseUrl}friends/request');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "userID": userData['userID'],
        "friend_requests": _selectedContactUserIds
      }),
    );

    print(userData['userID']);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("\n\n${responseBody}");
      getAvailableFriends();

      setState(() {

      });

    } else {
      throw Exception('Failed to load available friends');
    }
  }

  Future<void> _requestPermissions() async {
    print("Requesting contact permissions...");
    bool permissionGranted =
    await FlutterContacts.requestPermission(readonly: true);
    print("Initial permission status: $permissionGranted");

    if (!permissionGranted) {
      print("Requesting full contact permissions...");
      permissionGranted = await FlutterContacts.requestPermission();
      print("Full permission status: $permissionGranted");
    }

    if (permissionGranted) {
      print("Permission granted. Loading contacts...");
      _loadContacts();
    } else {
      print("Permission denied. Showing dialog.");
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Denied"),
        content: const Text("We need permission to access your contacts."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              print("User dismissed permission denied dialog.");
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    try {
      print("Fetching contacts...");
      List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);
      print(
          "Contacts fetched successfully. Total contacts: ${contacts.length}");
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching contacts: $e");
    }
  }

  // Add or remove contact from selected contacts list
  void _toggleSelection(Contact contact) {
    String phoneNumber = cleanPhoneNumber(contact.phones.first.number);

    setState(() {
      if (_selectedContacts.contains(phoneNumber)) {
        print("Removing ${contact.displayName} from selected contacts.");

        // Find the user ID of the contact and remove it if exists
        int? userId = getUserIdFromPhone(_availableFriends, phoneNumber);
        if (userId != null) {
          _selectedContactUserIds.remove(userId);
        }

        _selectedContacts.remove(phoneNumber);
      } else {
        print("Adding ${contact.displayName} to selected contacts.");


        // Find the user ID and add it if exists
        int? userId = getUserIdFromPhone(_availableFriends, phoneNumber);
        if (userId != null) {
          _selectedContactUserIds.add(userId);
          print("Adding ${userId} to selected contacts.");
        }

        _selectedContacts.add(phoneNumber);
      }
    });
  }

  int? getUserIdFromPhone(List availableFriends, String phoneNumber) {
    for (var friend in availableFriends) {
      print("${cleanPhoneNumber(friend['phone_no'])}  $phoneNumber");
      if (cleanPhoneNumber(friend['phone_no']) == "91"+phoneNumber) {
        return friend['userID'];
      }
    }
    return null; // Return null if no match found
  }

  String cleanPhoneNumber(String number) {
    return number.replaceAll(
        RegExp(r'\D'), ''); // Removes all non-digit characters
  }

  bool isPhoneInList(List phoneList, String phoneNumber) {
    return phoneList.any((item) => item['phone_no'] == "+91 "+phoneNumber);
  }

  Widget buildPage(String title, String subtitle, GlobalKey<FormState> formKey,
      List<Widget> additionalWidgets) {
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
                child: Text(title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange)),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle,
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
                            ContactsPageAssets.safeCircleImage))),
              ),
              if (_isLoading)
                const LinearProgressIndicator()
              else if (_contacts.isEmpty)
                const Text("No contacts found")
              else
                SizedBox(
                  height: 15,
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = _contacts[index];
                    bool isSelected = _selectedContacts.contains(contact.phones.isNotEmpty
                        ? cleanPhoneNumber(contact.phones.first.number)
                        : '');

                    String cleanedPhoneNumber = contact.phones.isNotEmpty
                        ? cleanPhoneNumber(contact.phones.first.number)
                        : '';


                    if (isPhoneInList(_availableFriends, cleanedPhoneNumber)) {
                      return InkWell(
                        onTap: () {
                          _toggleSelection(contact);
                        },
                        child: Container(
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
                                backgroundImage: AssetImage(
                                    ContactsPageAssets.userProfilePic),
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
                                      contact.displayName,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      contact.phones.isNotEmpty
                                          ? contact.phones.first.number
                                          : "No phone number",
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              isSelected
                                  ? Image.asset(
                                ContactsPageAssets.selectedTick
                                ,
                                width: 30,
                                height: 30,
                                color: AppColors.orange,
                              )
                                  : SizedBox
                                  .shrink(),
                              // Displays nothing when unselected
                            ],
                          ),
                        ),
                      );
                    }
                    else
                    {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("Saving selected contacts...");
                  print(
                      "Selected Contacts: ${_selectedContacts.map((c) => c).join(', ')}");
                  print(
                      "Selected Ids: ${_selectedContactUserIds}");

                  sendRequest();

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 12), // Padding inside button
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Send Request",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
              // ElevatedButton(
              //   onPressed: () {
              //     print("Saving selected contacts...");
              //     print("Selected Contacts: ${_selectedContacts.map((c) => c).join(', ')}");
              //   },
              //   child: const Text("Save Selection"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(
      'Add Close Friends',
      'Would you like to add close friends to your circle?',
      _formKey5,
      [],
    );
  }
}
