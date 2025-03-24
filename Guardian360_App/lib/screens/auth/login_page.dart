import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardians_app/screens/main_page.dart';
import 'package:guardians_app/screens/signup_page.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../config/auth_service.dart';
import '../../services/cache_service.dart';
import '../../utils/asset_suppliers/login_page_aseets.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController phoneController = TextEditingController();


  bool _otpVisible = false;
  String? _verificationId;
  int _start = 30;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      askForRegistration();
    });
    getDeviceToken();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the FocusNodes to free up resources
    super.dispose();
  }

  void askForRegistration(){
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing by tapping outside
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
              children: [
                // Image at the top
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    LoginPageAssets.signUpImage,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  "Don't have an Account?",
                  style: AppTextStyles.bold.copyWith(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Description
                Text(
                  "Join us today and experience secure and seamless protection!",
                  style: AppTextStyles.normal.copyWith(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Signup Button
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog first
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.darkBlue, AppColors.lightBlueShade1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "SIGN UP",
                      style: AppTextStyles.bold.copyWith(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  }

  String? deviceToken = "";

  void getDeviceToken() async {

    deviceToken = (await CacheService().getData("device_token"));

    print(deviceToken);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void sendOTP() async {
    String email = phoneController.text.trim();

    print("sending code");
    var url = Uri.parse(AuthService.send_code);  // Replace with your URL

    var body = jsonEncode({
      'email': email,
    });

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',  // Set the content type to JSON
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Request successful!');
      print('Response: ${response.body}');
      setState(() {
              _otpVisible = true;
            });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> verifyOTP(String code) async {

    String email = phoneController.text.trim();

    print("verifying code");
    var url = Uri.parse(AuthService.login);  // Replace with your URL

    var body = jsonEncode({
      'email': email,
      'code': code,
      "device_token" : deviceToken
    });

    print(body);

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',  // Set the content type to JSON
      },
      body: body,
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      print('Request successful!');
      print('Response: ${response.body}');

      final data = jsonDecode(response.body);

      CacheService cacheService = CacheService();
      print(data['user']);
      cacheService.saveAccessToken(data['userToken']);
      cacheService.saveUserDetails(jsonEncode(data['user']));

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainPage(userID: int.parse(data['user']['userID']))));

    } else {
      showDialog(context: context, builder: (context)=>AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Code failed"),
        content: Text('Request code again'),
      ));
    }

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.darkBlue, AppColors.lightBlueShade1,],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: Container(

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text : "Securing", style: AppTextStyles.bold.copyWith(color: Colors.white)),
                                  TextSpan(text : " Women", style: AppTextStyles.bold),
                                  TextSpan(text : " everyday", style: AppTextStyles.bold.copyWith(color: Colors.white)),
                                  TextSpan(text : " with care ", style: AppTextStyles.bold.copyWith(color: Colors.white)),
                                  TextSpan(text : "and", style: AppTextStyles.bold.copyWith(color: Colors.white)),
                                  TextSpan(text : " Support", style: AppTextStyles.bold)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Stack(
                          clipBehavior: Clip.none, // Allows overflow
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: 180.w,
                              height: 180.h,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.orange, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                    
                              child: Image(image: AssetImage(LoginPageAssets.loginImage), ),
                            ),
                            Positioned(
                              bottom: -10.h,
                              child: Container(
                                width: 220.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: AppColors.orange,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.orange, // Border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                child: Center(child: Text("Stay Secure", style: AppTextStyles.title.copyWith(color: Colors.black87),)),
                              ),
                    
                            ),
                    
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              clipBehavior: Clip.none, // Allows overflow
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 500.w,
                  height: 320.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50), ),
                  ),

                  child: Container(
                    padding: EdgeInsets.only(top: 45.h, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text("Guardian 360", style: AppTextStyles.bold.copyWith(color: Colors.black),)),
                        SizedBox(height: 40),
                        Text( _otpVisible ? "VERIFY CODE" : "ENTER EMAIL", style:  TextStyle(fontSize: 16),),
                        SizedBox(height: 20),

                        Visibility(
                          visible: _otpVisible,
                          child: PinCodeTextField(
                            appContext: context,
                            length: 6,
                            onChanged: (value) {
                              print("Current value: $value");
                            },

                            onCompleted: (value){
                              verifyOTP(value);
                            },
                          )
                        ),

                        Visibility(
                          visible: !_otpVisible,
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w), // Increased padding
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(15.sp),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.orange, width: 3),
                                borderRadius: BorderRadius.circular(15.sp),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(15.sp),
                              ),
                              hintText: "Enter",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value)
                            {
                              setState(() {

                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30,),

                        InkWell(
                          onTap: (){
                            if(_otpVisible)
                            {
                              sendOTP();
                            }
                            else
                            {
                              sendOTP();
                            }

                          },
                          child: Container(
                            width: double.infinity,
                            height: 45.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: phoneController.text.length  < 10 || _otpVisible == false  ?  AppColors.orange : AppColors.orange, // Change color based on phone number length
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Text(
                                _otpVisible ? "RESEND CODE" : "GET CODE",
                                style: AppTextStyles.bold.copyWith(color: Colors.white, fontSize: 18) // Use predefined styles
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -35.h, // Position the circle half outside the container
                  child: CircleAvatar(
                    radius: 35.h, // Using ScreenUtil for responsive radius
                    backgroundImage: AssetImage(LoginPageAssets.logo) ,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

