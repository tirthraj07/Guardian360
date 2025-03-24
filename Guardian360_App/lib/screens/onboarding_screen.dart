import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:guardians_app/screens/auth/login_page.dart';
import 'package:guardians_app/screens/signup_page.dart';
import 'package:guardians_app/utils/colors.dart';

import '../services/check_connectivity.dart';
import '../utils/asset_suppliers/onboarding_page_assets.dart'; // Add this dependency in your pubspec.yaml

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InternetConnectivityInApp().listenToConnectivity(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Column(
        children: [
          // PageView Builder for onboarding pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                OnboardingPageContent(
                  title: "Welcome to Guardians App",
                  description: "A safety app designed for women",
                  imageAsset: OnBoardingPageAssets.onBoardingImage2, // Provide your own image
                ),

                OnboardingPageContent(
                  title: "SOS Alerts",
                  description: "Send emergency alerts even offline",
                  imageAsset: OnBoardingPageAssets.onBoardingImage1, // Provide your own image
                ),

                OnboardingPageContent(
                  title: "Location Tracking",
                  description: "Share your location with trusted contacts",
                  imageAsset: OnBoardingPageAssets.onBoardingImage3, // Provide your own image
                ),

              ],
            ),
          ),

          // Dots indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: DotsIndicator(
              dotsCount: 3,
              position: _currentPage,
              decorator: DotsDecorator(
                activeColor: Colors.white,
                color: Colors.grey,
                size: Size(10.0, 10.0),
                activeSize: Size(12.0, 12.0),
                spacing: EdgeInsets.all(5.0),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
            child: Column(
              children: [
                if (_currentPage != 2) // If not last page, show Next button
                  InkWell(
                    onTap: _nextPage,
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      child: Center(child: Text("Next", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),

                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(15)
                      ),


                    ),
                  ),
                if (_currentPage == 2)
                  InkWell(
                    onTap: (){

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage() ));

                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                        child: Center(child: Text("Get Started", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),

                      decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(15)
                      ),


                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageContent extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;

  const OnboardingPageContent({
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: Offset(0, 5), // Adjust shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(20), // Add rounded corners
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Match the borderRadius
              child: Image.asset(
                imageAsset,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
