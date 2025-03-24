import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardians_app/config/base_config.dart';
import 'package:guardians_app/utils/text_styles.dart';
import 'package:http/http.dart' as http;

import '../utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  final int userID;

  const NotificationScreen({super.key, required this.userID});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
   List _notifications = [];

   @override
  void initState() {
    getNotifications();
    super.initState();
  }

  String _selectedFilter = "All";
  final List<String> _filters = ["All", "SOS", "Travel Alert", "Adaptive Alert", "General"];

  Future<void> getNotifications() async {
    String type = "all";
    if(_selectedFilter == "All"){
      type="all";
    }
    else if(_selectedFilter == "SOS"){
      type="sos";
    }
    else if(_selectedFilter == "Travel Alert"){
      type="travel_alert";
    }
    else if(_selectedFilter == "Adaptive Alert"){
      type="adaptive_location_alert";
    }
    else if(_selectedFilter == "General"){
      type="generic";
    }

    final url = Uri.parse("${DevConfig().notificationServiceBaseUrl}/api/${widget.userID}/notifications/inapp?type=$type");

    print("${DevConfig().notificationServiceBaseUrl}/api/${widget.userID}/notifications/inapp?type=$type");

    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print("Request successful: ${response.body}");

        final data = jsonDecode(response.body);
        _notifications = data['notifications'];
        _notifications = _notifications.reversed.toList();

        setState(() {

        });

      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending request: $e");
    }
  }

   Widget _buildFilterChips() {
     return SingleChildScrollView(
       scrollDirection: Axis.horizontal,
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 16),
         child: Row(
           children: _filters.map((filter) {
             bool isSelected = _selectedFilter == filter;
             return Padding(
               padding: EdgeInsets.symmetric(horizontal: 4.0),
               child: InkWell(
                 onTap: () {
                   setState(() {
                     _selectedFilter = filter;
                   });

                   getNotifications();
                 },
                 borderRadius: BorderRadius.circular(20), // Ripple effect shape
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(
                     color: isSelected ? Colors.blueAccent : Colors.grey.shade800,
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: Text(
                     filter,
                     style: TextStyle(
                       color: Colors.white,
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                     ),
                   ),
                 ),
               ),
             );
           }).toList(),
         ),
       ),
     );
   }


   Widget _buildNotificationContainer(Map<String, dynamic> notification) {
    switch (notification["notification_type_id"]) {
      case 0:
        return SOSNotification(
          message: notification["message"],
          sender: "${notification['notifier_id']}",
          phone: 'sample',
        );
      case 2:
        return TravelAlertNotification(
          message: notification["message"],
          sender: "${notification['notifier_id']}",
          phone: 'sample',
        );
      case 1:
        return AdaptiveAlertNotification(
          message: notification["message"],
          sender: "${notification['notifier_id']}",
          phone: 'sample',
        );
      case 3:
        return GeneralNotification(
          message: notification["message"],
          sender: "${notification['notifier_id']}",
          phone: 'sample',
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text("Notifications", style: AppTextStyles.bold),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        
        leading: IconButton(onPressed: () { Navigator.of(context).pop(); }, icon: Icon(Icons.arrow_back, color: AppColors.offWhite,), ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          _buildFilterChips(),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
                child: ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationContainer(_notifications[index]);
                  },
                ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationContainer extends StatelessWidget {
  final String message;
  final String sender;
  final String phone;
  final Color color;
  final String imagePath;

  const NotificationContainer({
    super.key,
    required this.message,
    required this.sender,
    required this.phone,
    required this.color,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "From: $sender ($phone)",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SOSNotification extends StatelessWidget {
  final String message;
  final String sender;
  final String phone;

  const SOSNotification(
      {super.key,
      required this.message,
      required this.sender,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return NotificationContainer(
      message: message,
      sender: sender,
      phone: phone,
      color: Colors.red.shade700,
      imagePath: 'assets/images/sos_notification.png',
    );
  }
}

class TravelAlertNotification extends StatelessWidget {
  final String message;
  final String sender;
  final String phone;

  const TravelAlertNotification(
      {super.key,
      required this.message,
      required this.sender,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return NotificationContainer(
      message: message,
      sender: sender,
      phone: phone,
      color: Color(0xFF5D8736),
      imagePath:
          'assets/images/travel_notification.jpg',
    );
  }
}

class AdaptiveAlertNotification extends StatelessWidget {
  final String message;
  final String sender;
  final String phone;

  const AdaptiveAlertNotification(
      {super.key,
      required this.message,
      required this.sender,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return NotificationContainer(
      message: message,
      sender: sender,
      phone: phone,
      color: Colors.cyan.shade600,
      imagePath:
          'assets/images/adaptive_notification.jpg',
    );
  }
}

class GeneralNotification extends StatelessWidget {
  final String message;
  final String sender;
  final String phone;

  const GeneralNotification(
      {super.key,
      required this.message,
      required this.sender,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return NotificationContainer(
      message: message,
      sender: sender,
      phone: phone,
      color: Colors.blue.shade400,
      imagePath:
          'assets/images/general_notificatiom.png',
    );
  }
}
