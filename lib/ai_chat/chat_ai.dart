import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:nurti_guard/const.dart';

var gK = 'AIzaSyC_GIqQJSIBxZu-lblDJa0aLBiX-l6Rogw';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [
    {'text': 'Hello there!', 'isUser': false}
  ];
  bool isLoading = false; // Added

  final client = GoogleAIClient(
    apiKey: gK,
  );
  FocusNode chatFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        // backgroundColor: priColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: priColor),
        title: Text('Chat with AI',
            style: GoogleFonts.signika(
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: chatFocus.hasFocus ? 310.h : 565.h,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ChatMessage(
                    text: message['text'],
                    isUser: message['isUser'],
                  );
                },
              ),
            ),
            if (isLoading)
              ChatMessage(
                text: 'Loading...',
                isUser: false,
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 67.h,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    boxShadow: [],
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: chatFocus,
                        controller: _controller,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Type your message...',
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Loading Indicator
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    String userMessage = _controller.text;
    setState(() {
      messages.add({'text': userMessage, 'isUser': true});
      isLoading = true; // Show loading indicator
    });
    _controller.clear();

    String modelResponse = await generateModelResponse(userMessage);
    setState(() {
      messages.add({'text': modelResponse, 'isUser': false});
      isLoading = false; // Hide loading indicator
    });
  }

  Future<String> generateModelResponse(String userMessage) async {
    // Send user message to AI model
    final res = await client.generateContent(
      modelId: 'gemini-pro',
      request: GenerateContentRequest(
        contents: [
          Content(
            role: 'user',
            parts: [
              Part(
                text: userMessage,
              ),
            ],
          ),
        ],
      ),
    );

    // Get model's response
    String response = res.candidates?.first.content?.parts?.first.text ??
        "No response from the model.";
    return response;
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return BubbleNormal(
      bubbleRadius: 12.w,
      margin: EdgeInsets.symmetric(vertical: 5),
      leading:
          isUser ? Icon(Icons.person) : Image.asset("assets/chat_bot_icon.png"),
      text: text,
      isSender: isUser,
      // color: isUser ? Colors.grey.withOpacity(0.4) : Color(0xFF1B97F3),
      color: isUser ? Color(0xFFEAE5E5) : Color(0xFF9FD796),
      tail: true,
      textStyle: TextStyle(
        fontSize: 16,
        color: isUser ? Colors.black : Colors.white,
      ),
    );
  }
}
