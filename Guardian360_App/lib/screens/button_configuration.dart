import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ButtonConfigurePage extends StatefulWidget {
  @override
  _ButtonConfigurePageState createState() => _ButtonConfigurePageState();
}

class _ButtonConfigurePageState extends State<ButtonConfigurePage> with TickerProviderStateMixin {
  final String serverUrl = 'http://10.10.10.194:8002/configure'; // Adjust to your server URL
  int userId = 0;
  bool isLoading = false;
  String message = '';

  // Controller for animations
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();

    // Scale-up animation for the button
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut);
    _scaleController.forward();
  }

  // Function to call the configure route
  Future<void> configureButton() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'button_id': 1, // Button ID to be configured
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response and extract the user_id
        final responseData = jsonDecode(response.body);
        setState(() {
          userId = responseData['user_id'];
          message = 'User ID: $userId assigned successfully!';
        });
      } else {
        setState(() {
          message = 'Failed to configure button. Try again!';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      appBar: AppBar(
        title: Text('Configure Button', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF14181B), // Set app bar color to your custom color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Welcome to Button Configuration!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14181B),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Press the button below to configure it with a unique user ID.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  onPressed: isLoading ? null : configureButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF14181B), // Custom color for the button
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Configure Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: message.contains('successfully') ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
