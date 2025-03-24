import 'dart:core';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardians_app/config/base_config.dart';
import 'package:guardians_app/utils/asset_suppliers/contacts_page_assets.dart';
import 'package:guardians_app/utils/asset_suppliers/home_page_assets.dart';
import 'package:guardians_app/utils/asset_suppliers/login_page_aseets.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';// For base64 decoding
import 'dart:typed_data';

import '../utils/colors.dart';

String selectedCategory = "";

class UserQueryChatbot extends StatefulWidget {
  final int userID;

  const UserQueryChatbot({super.key, required this.userID});
  @override
  State createState() => _UserQueryChatbotState();
}

class _UserQueryChatbotState extends State<UserQueryChatbot> {

  final TextEditingController _messageController = TextEditingController();

  DateTime? _lastMessageDate;
  String my_profile_pic = "";
  List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool isScrolled = false;
  bool _showCategoryList = false;

  final Map<String, List<String>> categoryList = {
    "Child Protection": [
      "Child Welfare",
      "Child Abuse Prevention",
      "Child Rights Awareness",
      "Emergency Protection",
    ],
    "Women's Safety": [
      "Harassment Prevention",
      "Emergency Helplines",
      "Gender Equality ",
      "Safe Transportation",
    ],
    "Emergency Procedures": [
      "Reporting Sexual Harassment",
      "Safety Measures in Public Spaces",
      "Self-defense",
      "Emergency Contacts",
    ],
    "Safety Education": [
      "Self-defense for Women",
      "Awareness Programs",
      "Safe Digital Practices",
      "Support Services",
    ],
    "Other Queries": [],
  };




  String? selectedCategory;
  String? selectedSubCategory;

  Future<void> sayHello() async {
    Map<String, dynamic>? lastMessage = null;

    if (lastMessage != null) {
      print("\n\n\n\nLAST MESSAGE");
      // print("${lastMessage['message'][0]}");

      if (lastMessage['message'][0] == "How can I help you?") {
        return;
      }
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    var answerData = {
      'senderId': 'chatbot',
      'answer': [
        "Hi, this is Guardians 360 Assistant!"
      ], // Save answer under 'answers' tag
      'timestamp': timestamp,
    };

    _messages.add(answerData);

    answerData = {
      'senderId': 'chatbot',
      'answer': ["How can I help you?"],
      'timestamp': timestamp,
    };

    _messages.add(answerData);
  }

  @override
  void initState() {
    super.initState();

    sayHello();
    isScrolled = false;

    _showCategoryList = true;

    getProfilePic();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    print("Scrolling to bottom");

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> getProfilePic() async {
    String profilePic = "";
  }

  Future<void> _sendMessage({String categoryMessage = ""}) async {
    print("Sending Message");
    final message = _messageController.text;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    var messageData = {
      'senderId': widget.userID,
      'message': message == "" ? categoryMessage : message,
      'timestamp': timestamp,
    };

    _messages.add(messageData);

    _isLoading = true;

    setState(() {

    });

    await sendPostRequest(message == "" ? categoryMessage : message);

  }

  Future<void> sendPostRequest(String query) async {
    // Define the URL of the API
    final String url = "${DevConfig().chatbotServiceBaseUrl}/query";

    // Prepare the data you want to send in the request body
    final Map<String, dynamic> requestData = {
      'user_id': widget.userID,
      'query' : query
    };

    print(requestData);

    final String jsonData = json.encode(requestData);

    // Send the POST request
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Specify the content type
        },
        body: jsonData, // Pass the data in the body
      );

      // Check the status code to see if the request was successful
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response
        print('Request was successful: ${response.body}');

        final data = json.decode(response.body);

        var answerData = {
          'senderId': 'chatbot',
          'answer': data["answer"]["answer"], // Save answer under 'answers' tag
          'timestamp': 0,
        };

        _messages.add(answerData);
        _isLoading = false;
        setState(() {

        });
      } else {
        // If the server did not return a 200 OK response
        print('Failed to send request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: AppColors.orange,
              )),
          backgroundColor: AppColors.darkBlue,
          title: Text(
            "Chatbot",
            style: TextStyle(color: AppColors.orange),
          ),
        ),
        backgroundColor: AppColors.darkBlue,
        body: Column(
          children: [
            // Use Expanded widget to take up all available space for messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true, // Important to avoid overflow
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['senderId'] == widget.userID;

                  // final showDate = _shouldShowDate(index, message);
                  _lastMessageDate = DateTime.fromMillisecondsSinceEpoch(
                      message['timestamp']);

                  return Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                    child: Column(
                      children: [
                        // if (showDate) _buildDateDivider(message),
                        Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isMe) ...[
                                  Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        width: 40.r,
                                        height: 40.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors
                                              .orange, // Circle background color
                                          image: DecorationImage(image: NetworkImage('https://img.freepik.com/free-vector/chatbot-conversation-vectorart_78370-4107.jpg'))
                                        ),
                                      )),
                                  SizedBox(width: 10),
                                ],
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.7,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 7.w),
                                        decoration: BoxDecoration(
                                          color: !isMe
                                              ? AppColors.lightBlue
                                              : Color.fromRGBO(
                                              206, 225, 223, 1),
                                          borderRadius: !isMe
                                              ? BorderRadius.only(
                                              topLeft:
                                              Radius.circular(12.r),
                                              topRight:
                                              Radius.circular(12.r),
                                              bottomRight:
                                              Radius.circular(12.r))
                                              : BorderRadius.only(
                                              topLeft:
                                              Radius.circular(12.r),
                                              topRight:
                                              Radius.circular(12.r),
                                              bottomLeft:
                                              Radius.circular(12.r)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: isMe
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            if (message['message'] !=
                                                "Image" &&
                                                message['message'] != null)
                                              Text(message['message'] ?? "",
                                                  style: TextStyle(
                                                    color: !isMe
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 14,
                                                  )),
                                            if (message['answer'] !=
                                                null) ...[
                                              for (var answer
                                              in message['answer'])
                                                Column(
                                                  children: [
                                                    Text(answer ?? "",
                                                        style: TextStyle(
                                                          color: !isMe
                                                              ? Colors.black
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        )),
                                                    if (message['answer']
                                                        .length >
                                                        1)
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                  ],
                                                ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      // if (showTimestamp)
                                      //   Text(
                                      //     _formatTimestamp(
                                      //         message['timestamp']),
                                      //     style: TextStyle(
                                      //         color: Colors.grey[600],
                                      //         fontSize: 10.sp),
                                      //   ),
                                    ],
                                  ),
                                ),
                                if (isMe) ...[
                                  SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 17.r,
                                      backgroundColor: Colors.white,
                                      backgroundImage: (my_profile_pic != "")
                                          ? NetworkImage(my_profile_pic)
                                          : AssetImage(ContactsPageAssets.userProfilePic),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (_isLoading) _buildLoadingBubble(),
            if (_showCategoryList) buildCategoryListWrap(),

            Container(
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextFormField(
                        controller: _messageController,
                        style: TextStyle(fontSize: 20),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Type your query here',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      await _sendMessage().then((val) {
                        _scrollToBottom();
                      });
                    },
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
          ],
        ));
  }


  bool _shouldShowTimestamp(int index, Map<String, dynamic> message) {
    if (index == 0) return true; // Always show timestamp for the first message

    final prevMessage = _messages[index - 1];
    final prevTimestamp = prevMessage['timestamp'];
    final currTimestamp = message['timestamp'];

    // Only show timestamp if the difference between messages is large enough
    final timeDifference = currTimestamp - prevTimestamp;
    if (timeDifference > 60000) {
      return true;
    }

    return false;
  }

  // Check if we should show the date for this message
  bool _shouldShowDate(int index, Map<String, dynamic> message) {
    final currentMessageDate =
    DateTime.fromMillisecondsSinceEpoch(message['timestamp']);
    if (_lastMessageDate == null) return true;

    return currentMessageDate.day != _lastMessageDate!.day;
  }

  // Build the date divider
  Widget _buildDateDivider(Map<String, dynamic> message) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(message['timestamp']);
    final formattedDate = '';

    return Container(
      width: 70,
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color.fromRGBO(206, 225, 223, 1),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        formattedDate,
        style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black54),
      ),
    );
  }

  Widget buildCategoryListWrap() {
    String query = "Please Provide me information on {subCat} from {MainCat}";

    final isSubCategoryView = selectedCategory != null;
    final itemsToDisplay = isSubCategoryView
        ? categoryList[selectedCategory] ?? []
        : categoryList.keys.toList();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: itemsToDisplay.map((item) {
          final bool isSelected = isSubCategoryView
              ? selectedSubCategory == item
              : selectedCategory == item;

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSubCategoryView) {
                  selectedSubCategory = isSelected ? null : item;

                  query = query
                      .replaceAll("{MainCat}", selectedCategory ?? "Unknown")
                      .replaceAll("{subCat}", selectedSubCategory ?? "Unknown");

                  setState(() {
                    _showCategoryList = false;
                  });

                  print(query);
                  _sendMessage(categoryMessage: query);
                } else {
                  selectedCategory = isSelected ? null : item;
                  selectedSubCategory = null; // Reset subcategory if going back

                  query = query.replaceAll("{MainCat}", selectedCategory!);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color:
                isSelected ? AppColors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.orange,
                  width: 1,
                ),
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.orange,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

Widget _buildLoadingBubble() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Row(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange, 
                image: DecorationImage(image: NetworkImage('https://img.freepik.com/free-vector/chatbot-conversation-vectorart_78370-4107.jpg'))// Circle background color
              ),
            )),
        SizedBox(
          width: 20,
        ),
        CircularProgressIndicator(color: AppColors.lightBlue,)
      ],
    ),
  );
}
