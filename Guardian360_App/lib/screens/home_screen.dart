import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardians_app/config/base_config.dart';
import 'package:guardians_app/screens/notification_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cache_service.dart';
import '../services/encryption.dart';
import '../services/sms_service.dart';
import '../services/video_contoller_service.dart';
import '../utils/asset_suppliers/contacts_page_assets.dart';
import '../utils/asset_suppliers/home_page_assets.dart';
import '../utils/colors.dart';
import '../utils/widgets/home_drawer.dart';
import 'chatbot.dart';
import 'friend_pages/contact_manager_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _smsSent = false;
  bool _isComplete = false;
  double _pressDuration = 0;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _circleAnimation;
  int _remainingSeconds = 5;
  final VideoCaptureController _videoController = VideoCaptureController();

  bool isConnectedToInternet = true;
  bool _isLoading = true;

  var userData = {};
  var friend_data = [];

  var currentLat;
  var currentLong;

  String publicKey = "";

  int notif_number = 0;

  String selectedMethod = 'single';
  double singleTapDelay = 3.0;
  double doubleTapDelay = 3.0;

  Future<void> getNotifications() async {
    String type = "all";
    final url = Uri.parse("${DevConfig().notificationServiceBaseUrl}/api/${userData['userID']}/notifications/inapp?type=$type");

    print("${DevConfig().notificationServiceBaseUrl}/api/${userData['userID']}/notifications/inapp?type=$type");

    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print("Request successful: ${response.body}");

        final data = jsonDecode(response.body);
        List _notifications = data['notifications'];

        notif_number = _notifications.length;

        setState(() {

        });

      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending request: $e");
    }
  }

  void updateFequently() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      updatePokeAcknowledgement();
    });
  }



  Future<void> updatePokeAcknowledgement() async {
    final url = Uri.parse("${DevConfig().sosReportingServiceBaseUrl}/api/poke/acknowledge/${userData['userID']}");

    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        // print("Request successful: ${response.body}");

      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending request: $e");
    }
  }

  Future<void> sendSOS() async {
    final String url = '${DevConfig().sosReportingServiceBaseUrl}/api/sos';

   print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-Token': 'MOBILE_APP',
        },
        body: jsonEncode({
          "userID": userData['userID'],
          "location": {
            "latitude" : currentLat,
            "longitude" : currentLong,
          },
          "notify_regional_users" : false
        }),

      );

      if (response.statusCode == 200) {
        print({response.body});
      } else {
        print('Error sending SOS: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }




  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (mounted) {
      setState(() {
        currentLat = position.latitude;
        currentLong = position.longitude;
      });
    }
  }

  Future<void> getFriends() async {
    String url =
        "${DevConfig().travelAlertServiceBaseUrl}friends/${userData['userID']}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        friend_data = data["friends"];
        setState(() {
          // Updates the state only once after all changes
        });

        print("Friends Fetched");

        await CacheService().saveFriendsData(jsonEncode(friend_data));
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

  }

  int userBattery = 0;

  Future<void> getUserData() async {
    await Future.delayed(Duration(milliseconds: 1500));
    String? userDataString = await CacheService().getData("user_data");

    if (userDataString == null || userDataString.isEmpty) {
      userDataString = '{}'; // Set default empty JSON if no data is found
    }
    print("\n\n");
    userData = jsonDecode(jsonDecode(userDataString));
    // publicKey = (await CacheService().getData('public_key'))!;

    getFriends();
    var battery = Battery();

    userBattery = await battery.batteryLevel;
    print(userBattery);

    // print(publicKey);
    print("Getting Notifs");
    getNotifications();
    setState(() {
      _isLoading = false; // Data is loaded, set loading state to false
    });
  }

  Future<void> loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString("sos_preferences");

    print("Loaded Data");
    Map<String, dynamic> loadedPrefs = jsonDecode(savedData ?? '');
    setState(() {
      selectedMethod = loadedPrefs["selectedMethod"] ?? 'single';
      singleTapDelay = (loadedPrefs["singleTapDelay"] ?? 3.0).toDouble();
      doubleTapDelay = (loadedPrefs["doubleTapDelay"] ?? 3.0).toDouble();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    _getCurrentLocation();
    loadPreferences();
    updateFequently();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _videoController.initializeCamera();
  }

  void _onPressStart() {
    setState(() {
      _smsSent = false;
      _isPressed = true;
      _pressDuration = 0;
      _isComplete = false;
      _remainingSeconds = 5;
    });

    _animationController.forward();

    // Start a timer to update the remaining seconds
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          HapticFeedback.heavyImpact();
          HapticFeedback.heavyImpact();
        });
      } else {
        setState(() {
          _isComplete = true;
          HapticFeedback.vibrate();
        });

        print("Sending Sos");

        var friend_phones = [];

        List friend_data_from_cache = jsonDecode(await CacheService().getData('friends_data') ?? '');

        for (int i = 0; i < friend_data_from_cache.length; i++) {
          print('${(friend_data_from_cache[i]['phone_no']).replaceAll(' ', '')}');

          friend_phones.add((friend_data_from_cache[i]['phone_no']).replaceAll(' ', ''));

          print(friend_phones);
        }

        var latitude = currentLat;
        var longitude = currentLong;

        var gmapUrl = "https://www.google.com/maps?q=$latitude,$longitude";

        var batteryPercentage = "$userBattery%";

        String messageToSend =
            """Guardian-360 [SOS Alert]\n\nI'm ${userData['first_name']}, in urgent need of help!\nLatitude : $latitude,\nLongitude : $longitude""";
        String messageToSend2 =
            """You can find me here: $gmapUrl.\n\nMy device battery is at $batteryPercentage.\n\nPlease assist me as soon as possible""";

        String messagetoServer = """Guardian360-${userData['userID']}-{"LAT": "$latitude","LONG": "$longitude","TYPE": "SOS","BATTERY": "$batteryPercentage%"}""";

        print(messageToSend);
        print(messageToSend2);

        await sendSOS();
        await _videoController.captureAndSendVideo(int.parse(userData['userID']));

        if (!_smsSent) {
          SmsService().sendMessage(friend_phones, messageToSend);
          SmsService().sendMessage(friend_phones, messageToSend2);
          SmsService().sendMessage(['+918767945245'], messagetoServer);
          _smsSent = true;
        }




        _timer.cancel();
      }
    });
  }

  void _onPressEnd() {
    _timer.cancel();
    _animationController.reverse();
    setState(() {
      _isPressed = false;
      _pressDuration = 0;
      _isComplete = false;
      _remainingSeconds = 5; // Reset the timer when the press ends
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading // Show progress indicator while loading data
        ? Scaffold(
            backgroundColor: AppColors.darkBlue,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.orange,
              ), // Show loading spinner
            ),
          )
        : Scaffold(
            backgroundColor: AppColors.darkBlue,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: _isLoading
                  ? Text("Loading...") // Display loading state in title
                  : Text(
                      userData['first_name'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
              leadingWidth: 80,
              leading: Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      width: 5,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage(ContactsPageAssets.userProfilePic),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContactRequestManagerPage(
                                userData: userData,
                              )));
                    },
                    icon: Icon(
                      Icons.group_add_outlined,
                      color: Colors.white,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserQueryChatbot(
                                userID: int.parse(userData['userID']),
                              )));
                    },
                    icon: Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 30,
                    )),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NotificationScreen(userID : int.parse(userData['userID']))));
                  },
                  icon: notif_number != 0
                      ? badges.Badge(
                          badgeContent: Text(
                            '${notif_number}', // Change this to your notification count
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor:
                                Colors.red, // Change badge color if needed
                            elevation: 4, // Gives a slight shadow effect
                          ),
                          position:
                              badges.BadgePosition.topEnd(top:  -6, end: -3),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      : Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ],
            ),
            drawer: HomePageDrawer(userID: int.parse(userData['userID']),),
            body: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              "Are you in an emergency ?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: null,
                              overflow: TextOverflow
                                  .visible, // Prevent overflow clipping
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Press the SOS button, your live location will be shared with the nearest help centre and your emergency contacts",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: null,
                              overflow: TextOverflow
                                  .visible, // Prevent overflow clipping
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, right: 20, top: 15),
                        child: Image(
                            image: AssetImage(HomePageAssets.kidnapImage)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3.8,
                  child: Center(
                    child: GestureDetector(
                      onPanDown: (_) => _onPressStart(),
                      onPanEnd: (_) => _onPressEnd(),
                      onPanCancel: () => _onPressEnd(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _circleAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: 1 - _circleAnimation.value,
                                child: Container(
                                  width: 200 + 200 * _circleAnimation.value,
                                  height: 200 + 200 * _circleAnimation.value,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isPressed
                                        ? Colors.red.withOpacity(0.2)
                                        : Colors.transparent,
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: _isComplete
                                  ? Colors.green
                                  : (_isPressed
                                      ? Colors.red
                                      : AppColors.orange),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _isPressed
                                      ? Colors.red.withOpacity(0.5)
                                      : Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible: !_isPressed,
                                      child: Text(
                                        "SOS",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 40,
                                            color: Colors.black),
                                      )),
                                  Visibility(
                                      visible: _isPressed & !_isComplete,
                                      child: Text(
                                        "$_remainingSeconds",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 40,
                                            color: Colors.white),
                                      )),
                                  Visibility(
                                      visible: _isComplete,
                                      child: Text(
                                        "SENT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 40,
                                            color: Colors.white),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => ButtonConfigurePage()));
                //   },
                //   child: Container(
                //     width: double.infinity,
                //     margin: EdgeInsets.symmetric(horizontal: 40),
                //     height: 45,
                //     child: Center(
                //         child: Text(
                //       "Configure Button",
                //       style:
                //           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //     )),
                //     decoration: BoxDecoration(
                //         color: AppColors.orange,
                //         borderRadius: BorderRadius.circular(15)),
                //   ),
                // ),

                SizedBox(height: 10,),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF010038),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                       Text("Emergency Contacts", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
                        const SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
  }
}
