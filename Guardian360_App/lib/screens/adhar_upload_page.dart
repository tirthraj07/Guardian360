import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:guardians_app/screens/home_screen.dart';
import 'package:guardians_app/screens/main_page.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/asset_suppliers/adhaar_page_assets.dart';
import '../utils/colors.dart';

class AadhaarCardPage extends StatefulWidget {
  final int userID;

  const AadhaarCardPage({super.key, required this.userID});
  @override
  _AadhaarCardPageState createState() => _AadhaarCardPageState();
}

class _AadhaarCardPageState extends State<AadhaarCardPage> {
  XFile? _aadhaarCardImage;
  CameraController? _cameraController;  // Make it nullable
  List<CameraDescription>? _cameras;  // Make it nullable
  bool _isCameraInitialized = false;
  XFile? _imageFile;

  // Function to pick Aadhaar card image
  Future<void> _pickAadhaarCard() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _aadhaarCardImage = pickedFile;
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Get available cameras
      _cameras = await availableCameras();

      // Choose front camera if available
      final camera = _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      // Initialize the camera controller
      _cameraController = CameraController(camera, ResolutionPreset.high);

      await _cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
      setState(() {
        _isCameraInitialized = false;
      });
    }
  }

  // Capture the image
  Future<void> _takePicture() async {
    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _imageFile = image;
      });
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Ensure the controller is disposed of properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Aadhaar Card Verification",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange)),

              SizedBox(height: 20),

              InkWell(
                onTap: _pickAadhaarCard,
                child: Container(
                  width: double.infinity, // Take the full available width
                  height: (MediaQuery.of(context).size.width / 16) * 9, // Maintain 16:9 aspect ratio
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Optional background color
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 1, // Border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Match container's rounded corners
                    child: _aadhaarCardImage != null
                        ? Image.file(
                      File(_aadhaarCardImage!.path),
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover, // Maintain aspect ratio and cover the space
                    )
                        : Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "No image selected",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                              child: Image(image: AssetImage(AdhaarPageAssets.uploadImage)))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Border color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: _isCameraInitialized
                    ? Column(
                  children: [
                    // Camera preview in 4:3 aspect ratio
                    Visibility(
                      visible : _imageFile == null,
                      child: AspectRatio(
                        aspectRatio: 1/ 1, // 4:3 aspect ratio for camera preview
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                    if (_imageFile != null) ...[
                      // Display the captured image
                      Image.file(
                        File(_imageFile!.path),
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Use this image for your flow
                          Navigator.pop(context, _imageFile!.path);
                        },
                        child: Text('Use this photo'),
                      ),
                    ],

                      SizedBox(height: 10,),

                      InkWell(
                        onTap: _takePicture,
                        child: Container(
                          height: 40,
                          width: 40,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ],
                )
                    : _cameraController == null
                    ? Center(
                  child: Text(
                    "Camera not available on this device.",
                    style: TextStyle(color: Colors.red),
                  ),
                )
                    : Center(
                  child: CircularProgressIndicator(), // Show while initializing
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainPage(userID: widget.userID,)));
                  },
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
                        "Verify",
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
      ),
    );
  }
}
