import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(const SmsApp());
}

class SmsApp extends StatelessWidget {
  const SmsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SmsHomePage(),
    );
  }
}

class SmsHomePage extends StatefulWidget {
  const SmsHomePage({Key? key}) : super(key: key);

  @override
  State<SmsHomePage> createState() => _SmsHomePageState();
}

class _SmsHomePageState extends State<SmsHomePage> {
  final SmsQuery _query = SmsQuery();
  String _latestMessage = "Waiting for new SMS...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkSmsPermission();
    _startPollingForSms();
  }

  void _startPollingForSms() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchLatestSms();
    });
  }

  Future<void> _checkSmsPermission() async {
    if (await Permission.sms.request().isGranted) {
      _fetchLatestSms();
    } else {
      debugPrint('SMS permission denied');
    }
  }

  Future<void> _fetchLatestSms() async {
    if (!mounted) return;

    try {
      final messages = await _query.querySms(kinds: [SmsQueryKind.inbox], count: 1);
      if (messages.isNotEmpty && mounted) {
        setState(() => _latestMessage = messages.first.body ?? "No content");
      }
    } catch (e) {
      debugPrint("Error fetching SMS: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    );
  }
}