import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardians_app/config/auth_service.dart';
import 'package:guardians_app/screens/friend_pages/contact_page.dart';
import 'package:guardians_app/services/cache_service.dart';
import 'package:guardians_app/utils/asset_suppliers/contacts_page_assets.dart';
import 'package:guardians_app/utils/asset_suppliers/onboarding_page_assets.dart';
import 'package:guardians_app/utils/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'adhar_upload_page.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final PageController _pageController = PageController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  // Controllers for form inputs
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _adhaarController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();

  int _secondsLeft = 30; // 30 seconds for the timer
  Timer? _timer;

  String? deviceToken;

  void getDeviceToken() async {

    deviceToken = (await CacheService().getData("device_token"));

    print(deviceToken);
  }


  bool isVerified =
      false; // To simulate whether the email verification is successful

  // Variable to track if form is valid
  bool _isFormValid1 = false;
  bool _isFormValid2 = false;
  bool _isFormValid3 = false;
  bool _isFormValid4 = false;
  bool _isFormValid5 = false;


  Future<void> sendCode(String email) async {
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
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> verifyCode(String email, String first_name, String last_name, String phone_no, String code) async {
    print("verifying code");
    var url = Uri.parse(AuthService.signup);

    var body = jsonEncode({
      "first_name" : first_name,
      "last_name" : last_name,
      "phone_no" : "+91 ${phone_no}",
      "email" : email,
      "aadhar_no": _adhaarController.text,
      "device_token": deviceToken,
      "code" : code
    });

    print(body);

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',  // Set the content type to JSON
      },
      body: body,
    );

    if (response.statusCode == 201) {
      print('Code Verified successful!');
      isVerified = true;
     _updateFormValidity();

      print('Response: ${response.body}');
      
      final data = jsonDecode(response.body);

      CacheService cacheService = CacheService();
      print(data['user']);
      cacheService.saveAccessToken(data['userToken']);
      cacheService.saveUserDetails(jsonEncode(data['user']));
      cacheService.savePublicKey(jsonEncode(data['user']['public_key']));

    } else {
      print('Request failed with status: ${response.statusCode}');
    }



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
                  isVerified ? 'Verified' : "Not Verified",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Image.asset( isVerified ? ContactsPageAssets.verifiedImage : OnBoardingPageAssets.rejectedImage, height: 150.0),  // Add your tick mark image
              ],
            ),
          ),
        );
      },
    );
  }


  void _updateFormValidity() {
    setState(() {
      if (_formKey1.currentState != null) {
        _isFormValid1 = _formKey1.currentState!.validate();
      }
      if (_formKey2.currentState != null) {
        _isFormValid2 = _formKey2.currentState!.validate();
      }
      if (_formKey3.currentState != null) {
        _isFormValid3 = _formKey3.currentState!.validate();
      }
      if (_formKey4.currentState != null) {
        _isFormValid4 = isVerified;
      }
      if (_formKey5.currentState != null) {
        _isFormValid5 = true; // Assuming no validation for final page
      }
    });
  }


  // Handle the page change safely after the PageView is fully built
  @override
  void initState() {
    super.initState();
    getDeviceToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });


  }

  void _startTimer() {
    print("Timer Started");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _resendCode() {
    setState(() {
      _secondsLeft = 60;
      _startTimer();// Reset the timer to 30 seconds
    });

    sendCode(_emailController.text);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Column(
        children: [
          // PageView to manage the 5 pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {});
              },
              children: [
                // Page 1: First Name and Last Name
                _buildPage(
                  'First, Your Name',
                  'Please enter your first and last name.',
                  _formKey1,
                  [
                    TextFormField(
                      controller: _firstNameController,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        hintStyle: TextStyle(color: AppColors.orange),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.orange,
                              width: 2), // Active border color
                        ),
                      ),
                      onChanged: (value) => _updateFormValidity(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: TextStyle(color: AppColors.orange),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.orange,
                              width: 2), // Active border color
                        ),
                      ),
                      onChanged: (value) => _updateFormValidity(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Page 2: Phone Number
                _buildPage(
                  'Now, Your Phone Number',
                  'Please enter your phone number.',
                  _formKey2,
                  [
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: AppColors.orange),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        prefix: Container(child: Text("+91 ")),
                        hintStyle: TextStyle(color: AppColors.orange),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.orange,
                              width: 2), // Active border color
                        ),
                      ),
                      onChanged: (value) => _updateFormValidity(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Page 3: Email Address
                _buildPage(
                  'Now, Your Email',
                  'Please enter your email address.',
                  _formKey3,
                  [
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: AppColors.orange),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.orange,
                              width: 2), // Active border color
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _updateFormValidity();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10,),

                    TextFormField(
                      controller: _adhaarController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Adhaar Number',
                        hintStyle: TextStyle(color: AppColors.orange),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.orange,
                              width: 2), // Active border color
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _updateFormValidity();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                _buildPage(
                  'Verify Your Email',
                  'Enter the verification code sent to your email.',
                  _formKey4,
                  [
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        print("Current value: $value");
                      },
                      onCompleted: (value) {

                        verifyCode(_emailController.text, _firstNameController.text, _lastNameController.text, _phoneNumberController.text, value);
                      },



                      keyboardType: TextInputType.text,
                      animationType: AnimationType.fade,
                      textStyle: TextStyle(color: Colors.white, fontSize: 18),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        activeColor: Colors.orange,
                        selectedColor: Colors.orangeAccent,
                        inactiveColor: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 50,),

                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _secondsLeft > 0
                                ? 'Resend code in $_secondsLeft seconds'
                                : 'You can resend the code now!',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _secondsLeft == 0 ? _resendCode : null,
                            child: Text(
                              _secondsLeft == 0 ? 'Resend Code' : 'Wait...',
                              style: TextStyle(
                                color: Colors.white, // Text color (white for good contrast)
                                fontSize: 16,         // Optional: set font size
                                fontWeight: FontWeight.bold, // Optional: make text bold
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding inside button
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(

              onPressed: _pageController.hasClients
                  ? (_pageController.page == 0 && _isFormValid1)
                  ? () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
                  : (_pageController.page == 1 && _isFormValid2)
                  ? () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
                  : (_pageController.page == 2 && _isFormValid3)
                  ? () async {
                // Send Code
                print("Calling Function");
                await sendCode(_emailController.text);
                _startTimer();

                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
                  : (_pageController.page == 3 && isVerified && _isFormValid4)
                  ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddCloseFriendsPage(),
                  ),
                );

                print("First Name: ${_firstNameController.text}");
                print("Last Name: ${_lastNameController.text}");
                print("Phone Number: ${_phoneNumberController.text}");
                print("Email: ${_emailController.text}");
              }
                  : null
                  : null,

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
                    "Continue",
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
    );
  }

  // Helper method to build each page
  Widget _buildPage(String heading, String subheading,
      GlobalKey<FormState> formKey, List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange)),
              SizedBox(height: 10),
              Text(
                subheading,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ...fields,
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
