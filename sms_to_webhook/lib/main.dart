import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const SmsApp());
}

class SmsApp extends StatelessWidget {
  const SmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SmsHomePage(),
    );
  }
}

class SmsHomePage extends StatefulWidget {
  const SmsHomePage({super.key});

  @override
  State<SmsHomePage> createState() => _SmsHomePageState();
}

class _SmsHomePageState extends State<SmsHomePage> {
  final SmsQuery _query = SmsQuery();
  String _latestMessage = "Tap refresh to load the latest SMS";

  Future<void> _fetchLatestSms() async {
    if (!mounted) return; // Prevent crashes

    if (await Permission.sms.request().isGranted) {
      try {
        final messages = await _query.querySms(kinds: [SmsQueryKind.inbox], count: 1);
        if (messages.isNotEmpty && mounted) {
          setState(() => _latestMessage = messages.first.body ?? "No content");
        }
      } catch (e) {
        debugPrint("Error fetching SMS: $e");
      }
    } else {
      debugPrint('SMS permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Latest SMS")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            _latestMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchLatestSms,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}