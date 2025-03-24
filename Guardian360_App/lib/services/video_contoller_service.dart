import 'dart:io';
import 'package:camera/camera.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import '../config/base_config.dart';

class VideoCaptureController {
  CameraController? _cameraController;
  bool _isRecording = false;
  String webhookUrl = "${DevConfig().sosReportingServiceBaseUrl}/sos"; // Set your webhook URL

  // Initializes the camera
  Future<void> initializeCamera() async {
    try {
      List<CameraDescription> cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0], // Use the first available camera
          ResolutionPreset.medium,
          enableAudio: true, // Ensure audio is captured
        );
        await _cameraController!.initialize();
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // Starts video recording for 30 seconds and sends it to the webhook
  Future<void> captureAndSendVideo(int userID) async {
    if (_cameraController == null || _isRecording) return;

    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Start video recording
      await _cameraController!.startVideoRecording();
      _isRecording = true;
      print("Recording started...");

      // Wait for 30 seconds (or whatever duration you choose)
      await Future.delayed(Duration(seconds: 30));

      // Stop recording after 30 seconds
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      _isRecording = false;
      print("Recording stopped. File saved at: ${videoFile.path}");

      // ✅ Request permission and save to gallery using photo_manager
      await _saveToGallery(videoFile.path);

      // ✅ Send the video to the webhook
      await _sendVideoToWebhook(videoFile.path, userID);
    } catch (e) {
      print("Error during video capture: $e");
    }
  }

  // Method to save the video to the gallery
  Future<void> _saveToGallery(String videoPath) async {
    // Request permission to access photos
    PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      try {

        final asset = await PhotoManager.editor.saveVideo(File(videoPath));
        if (asset != null) {
          print("Video saved to gallery!");
        } else {
          print("Failed to save video to gallery.");
        }
      } catch (e) {
        print("Error saving video to gallery: $e");
      }
    } else {
      print("Permission to access photos is denied.");
    }
  }

  // Method to send video to webhook
  Future<void> _sendVideoToWebhook(String videoPath, int userID) async {
    File videoFile = File(videoPath);

    var url = Uri.parse("${DevConfig().sosReportingServiceBaseUrl}/api/sos/$userID/video");

    print("Uploading video to: ${url.toString()}"); // Debugging log

    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('video', videoFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Video uploaded successfully");
    } else {
      print("Failed to upload video: ${response.statusCode}");
    }
  }

  // Disposes the camera controller when no longer needed
  void dispose() {
    _cameraController?.dispose();
  }
}
