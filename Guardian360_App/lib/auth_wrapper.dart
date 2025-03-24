import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardians_app/screens/home_screen.dart';
import 'package:guardians_app/screens/main_page.dart';
import 'package:guardians_app/screens/onboarding_screen.dart';
import 'package:guardians_app/services/background_service.dart';
import 'package:guardians_app/services/cache_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  String? access_token;
  Map userData = {"userID" : 0};

  Future<void> getToken() async {
    print("getting tokem");
    final CacheService cacheService = CacheService();
    access_token = await cacheService.getData('access_token');

    // await cacheService.removeCacheData('access_token');
    // await cacheService.removeCacheData('user_data');

    String? userDataString = await CacheService().getData("user_data");

    if (userDataString == null || userDataString.isEmpty) {
      userDataString = '{}';
    }
    else{
      print("\n\n");
      userData = jsonDecode(jsonDecode(userDataString));
      setState(() {
      });
    }


    print(userData['userID']);
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return access_token ==null ? OnboardingPage() : MainPage(userID: int.parse(userData['userID'])) ;
  }
}
