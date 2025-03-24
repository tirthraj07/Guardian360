import 'package:flutter/material.dart';
import 'package:guardians_app/screens/friend_pages/add_contacts_page.dart';
import 'package:guardians_app/screens/friend_pages/friend_loc_info.dart';
import 'package:guardians_app/screens/friend_pages/pending_friend_requests.dart';

import '../../services/check_connectivity.dart';
import '../../utils/colors.dart';

class ContactRequestManagerPage extends StatefulWidget {
  final Map userData;
  const ContactRequestManagerPage({super.key, required this.userData});

  @override
  State<ContactRequestManagerPage> createState() => _ContactRequestManagerPageState();
}

class _ContactRequestManagerPageState extends State<ContactRequestManagerPage> {


  int _selectedIndex = 0;
  late List<Widget> _pages;  // Declare as late

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InternetConnectivityInApp().listenToConnectivity(context);
    });
    super.initState();
    _pages = [
      const AddCloseFriendsHomePage(),
      AcceptPendingRequestPage(userData: widget.userData), // No const here
      FriendLocationTrackingPage(),
    ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: AppColors.darkBlue,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.orange,
        unselectedItemColor: AppColors.offWhite,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Accept',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Location',
          ),
        ],
      ),
    );
  }
}
