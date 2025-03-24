import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class KYCPage extends StatefulWidget {
  @override
  _KYCPageState createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    final camera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(camera, ResolutionPreset.high);

    try {
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // Capture the image
  Future<void> _takePicture() async {
    try {
      final image = await _cameraController.takePicture();
      setState(() {
        _imageFile = image;
      });
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Take a Selfie")),
      body: _isCameraInitialized
          ? Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraController),
          ),
          if (_imageFile != null) ...[
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
            )
          ],
          ElevatedButton(
            onPressed: _takePicture,
            child: Text('Take Selfie'),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
