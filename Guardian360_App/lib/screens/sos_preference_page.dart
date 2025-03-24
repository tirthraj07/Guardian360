import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardians_app/screens/main_page.dart';
import 'package:guardians_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/text_styles.dart';

class SosPreferencesPage extends StatefulWidget {
  final int userID;

  const SosPreferencesPage({super.key, required this.userID});

  @override
  _SosPreferencesPageState createState() => _SosPreferencesPageState();
}

class _SosPreferencesPageState extends State<SosPreferencesPage> {
  String selectedMethod = 'single';
  double singleTapDelay = 3.0;
  double doubleTapDelay = 3.0;

  initState(){
    super.initState();

    loadPreferences();
  }

  Map<String, dynamic> userPreferences = {};

  Future<void> savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userPreferences = {
      "selectedMethod": selectedMethod,
      "singleTapDelay": singleTapDelay,
      "doubleTapDelay": doubleTapDelay,
    };
    await prefs.setString("sos_preferences", jsonEncode(userPreferences));
    print(userPreferences);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Preferences Saved")),
    );

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainPage(userID: widget.userID)));

    print("Hello");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: Text(
        "SOS Settings",
        style: AppTextStyles.title.copyWith(color: AppColors.orange),
      ),
        backgroundColor: Colors.transparent,
        leading: SizedBox.shrink()
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SOS Activation Method", style: AppTextStyles.bold.copyWith(fontSize: 17, color: Colors.white) ),
            SizedBox(height: 10),
            Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: RadioListTile(
                      title: Text("Single Tap"),
                      value: 'single',
                      groupValue: selectedMethod,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value.toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: RadioListTile(
                      title: Text("Double Tap"),
                      value: 'double',
                      groupValue: selectedMethod,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value.toString();
                        });
                      },
                    ),
                  ),
                ],
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            if (selectedMethod == 'single')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Set Timer Delay for Single Tap", style: AppTextStyles.bold.copyWith(fontSize: 17, color: Colors.white) ),
                  Slider(
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: Colors.orange,
                    value: singleTapDelay,
                    onChanged: (value) {
                      setState(() {
                        singleTapDelay = value;
                      });
                    },
                  ),
                  Center(
                    child: Text(
                      "${singleTapDelay.toInt()} Second",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.orange),
                    ),
                  ),
                ],
              ),
            if (selectedMethod == 'double')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Set Timer Delay for Double Tap", style: AppTextStyles.bold.copyWith(fontSize: 17, color: Colors.white) ),
                  Slider(
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: Colors.orange,
                    value: doubleTapDelay,
                    onChanged: (value) {
                      setState(() {
                        doubleTapDelay = value;
                      });
                    },
                  ),
                  Center(
                    child: Text(
                      "${doubleTapDelay.toInt()} Second",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.orange),
                    ),
                  ),
                ],
              ),
            Spacer(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(

                onPressed: savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12), // Padding inside button
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Save Preferences",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
