import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sms_to_webhook/services/sms_service.dart';
// websocket package
import 'package:web_socket_channel/web_socket_channel.dart';


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
  final _hostnameController = TextEditingController();
  final _portController = TextEditingController();
  String _latestMessage = "Waiting for new SMS...";
  String _messageSender = "";
  String? _webhookUrl;
  String? _websocketUrl;
  Timer? _timer;
  final SmsService smsService = SmsService();
  String? _lastProcessedMessage; // Tracks the last processed SMS content

  // WebSocket instance
  WebSocketChannel? _webSocketChannel;

  @override
  void initState() {
    super.initState();
    _checkSmsPermission();
  }

  Future<void> _checkSmsPermission() async {
    if (await Permission.sms.request().isGranted) {
      debugPrint('SMS permission granted');
    } else {
      debugPrint('SMS permission denied');
    }
  }

  void _startPollingForSms() {
    if (_webhookUrl == null) {
      debugPrint("Webhook URL is not set. Cannot start SMS polling.");
      return;
    }

    _timer?.cancel(); // Ensure no duplicate timers are running
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchLatestSms();
    });
  }

  Future<void> _fetchLatestSms() async {
    if (!mounted || _webhookUrl == null) return;

    try {
      final messages = await _query.querySms(kinds: [SmsQueryKind.inbox], count: 1);
      if (messages.isNotEmpty && mounted) {
        final latestMessage = messages.first.body ?? "No content";
        final sender = messages.first.address ?? "Unknown sender";
        // print("Fetching SMS..");
        // Send only if the message is new
        if (latestMessage != _lastProcessedMessage) {
          setState(() {
            _latestMessage = latestMessage;
            _messageSender = sender;
          });
          _lastProcessedMessage = latestMessage; // Update the last processed message
          await _sendSmsToWebhook();
        }
      }
    } catch (e) {
      debugPrint("Error fetching SMS: $e");
    }
  }

  Future<void> _sendSmsToWebhook() async {
    if (_webhookUrl == null) return;

    try {
      final response = await http.post(
        Uri.parse(_webhookUrl!),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message_body': _latestMessage,
          'message_sender': _messageSender,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Message sent successfully to webhook');
      } else {
        debugPrint('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error sending SMS to webhook: $e");
    }
  }

  void _setWebhookUrl() {
    final hostname = _hostnameController.text.trim();
    final port = _portController.text.trim();

    if (hostname.isEmpty || port.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both hostname and port")),
      );
      return;
    }

    setState(() {
      _webhookUrl = "http://$hostname:$port/receive_sms";
      _websocketUrl = "ws://$hostname:$port";
    });

    debugPrint("Webhook URL set to: $_webhookUrl");
    debugPrint("Websocket URL set to: $_websocketUrl");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Webhook URL set to: $_webhookUrl")),
    );

    _startPollingForSms();
    // start web socket connection
    _connectWebSocket();
  }

  void _connectWebSocket() {
    if (_websocketUrl == null) return;

    // final wsUrl = _webhookUrl!.replaceFirst("http", "ws"); // Convert http to ws
    final wsUrl = _websocketUrl!;
    debugPrint("Websocket url : $wsUrl");
    try {
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      debugPrint("WebSocket connection established: $wsUrl");

      // Listen for incoming messages from the WebSocket server
      _webSocketChannel!.stream.listen(
            (message) {
          debugPrint("WebSocket message received: $message");
          try {
            // Decode JSON message
            final Map<String, dynamic> data = jsonDecode(message);

            // Extract variables
            String recipient = data["recipient"] ?? "";
            String smsMessage = data["message"] ?? "";
            String eventType = data["event_type"] ?? "";

            // Print extracted values
            debugPrint("===== MESSAGE FROM NOTIFICATION SERVICE ====");
            debugPrint("Recipient: $recipient");
            debugPrint("Message: $smsMessage");
            debugPrint("Event Type: $eventType");

            smsService.sendMessage(recipient, smsMessage);

          } catch (e) {
            debugPrint("Error parsing WebSocket message: $e");
          }

        },
        onDone: () {
          debugPrint("WebSocket connection closed");
        },
        onError: (error) {
          debugPrint("WebSocket error: $error");
        },
      );
    } catch (e) {
      debugPrint("Error connecting to WebSocket: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _webSocketChannel?.sink.close(); // Close WebSocket connection
    _hostnameController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SMS Webhook App")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _hostnameController,
              decoration: const InputDecoration(
                labelText: "Hostname",
                hintText: "Enter webhook hostname",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: "Port",
                hintText: "Enter webhook port",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setWebhookUrl,
              child: const Text("Set Webhook URL"),
            ),
            const SizedBox(height: 40),
            Text(
              "Latest SMS:\n$_latestMessage\nFrom: $_messageSender",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
