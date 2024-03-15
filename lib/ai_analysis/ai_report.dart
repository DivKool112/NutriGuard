import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:nurti_guard/const.dart';
import 'package:nurti_guard/home/bottomNav.dart';

import '../ai_chat/chat_ai.dart';

class ReportPage extends StatefulWidget {
  final String prompt;

  const ReportPage({super.key, required this.prompt});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ReportPage> {
  @override
  initState() {
    super.initState();
    sendMessage();
  }

  bool isComp = false;

  List<Map<String, dynamic>> messages = [];

  final client = GoogleAIClient(
    apiKey: gK,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfffff5d7),
      appBar: AppBar(
        backgroundColor: priColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: priColor),
        title: Text('Analysis Report',
            style: TextStyle(
              fontSize: 19,
            )),
      ),
      body: isComp
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Markdown(
                shrinkWrap: false,
                data: '${messages.last['text']}',
                styleSheet: MarkdownStyleSheet(
                  h1: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600),
                  h2: TextStyle(fontSize: 24, color: Colors.lightBlue[600]),
                  h3: TextStyle(fontSize: 27, color: Color(0xff2a2836)),
                  h4: TextStyle(fontSize: 18),
                  h5: TextStyle(fontSize: 17),
                  p: TextStyle(fontSize: 15),
                  blockquote: TextStyle(fontSize: 14),
                  code: TextStyle(fontSize: 14),
                  em: TextStyle(fontSize: 14),
                  strong: TextStyle(fontSize: 17, color: Colors.black87),
                ),
              ))
          : isErr
              ? Center(
                  child: Text('Something went wrong! Please try again.'),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Generating your report...'),
                      SizedBox(height: 10),
                      CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                      ),
                    ],
                  )),
                ),
    );
  }

  bool isErr = false;

  void sendMessage() async {
    try {
      String userMessage = widget.prompt;
      setState(() {
        messages.add({'text': userMessage, 'isUser': true});
      });
      // _controller.clear();

      String modelResponse = await generateModelResponse(userMessage);
      print(modelResponse);
      setState(() {
        messages.add({'text': modelResponse, 'isUser': false});
        isComp = true;
      });
    } catch (e) {
      setState(() {
        isErr = true;
      });
      // TODO
    }
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
