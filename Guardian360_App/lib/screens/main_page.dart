import 'package:flutter/material.dart';
import 'package:guardians_app/config/travel_alert_service.dart';
import 'package:guardians_app/screens/home_screen.dart';
import 'package:guardians_app/screens/incident_reporting/incident_reporting.dart';
import 'package:guardians_app/screens/location/safe_zones_add.dart';
import 'package:guardians_app/utils/colors.dart';

import '../services/background_service.dart';
import '../services/check_connectivity.dart';
import '../services/location_service.dart';
import 'location/travel_mode_page.dart';

class MainPage extends StatefulWidget {
  final int userID;
  const MainPage({super.key, required this.userID});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  Future<void> startTracking() async {
    print("Main Page Loaded");
    // await BackgroundLocationService.initService(widget.userID);
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      IncidentReportingPage(userID: widget.userID),
      SafeZonesView(userID: widget.userID), // Safe Zone placeholder
      TravelModePage(userID: widget.userID), // Travel placeholder
    ];

    startTracking();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      InternetConnectivityInApp().listenToConnectivity(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Only update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.isNotEmpty
          ? _pages[_selectedIndex] // Use the selected page
          : const Center(child: CircularProgressIndicator()), // Fallback if pages are not initialized yet
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: AppColors.darkBlue, // Set the background color here
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.orange,
          unselectedItemColor: AppColors.offWhite,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'Safe Zone',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_crash_outlined),
              label: 'Travel',
            ),
          ],
        ),
      ),
    );
  }
}
