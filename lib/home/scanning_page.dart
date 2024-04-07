import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_area_ocr_flutter/focused_area_ocr_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nurti_guard/const.dart';
import 'package:nurti_guard/home/home_page.dart';

import 'PersonaliseForum.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({Key? key}) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}

class _ScanningPageState extends State<ScanningPage> {
  final storage = GetStorage();
  final StreamController<String> controller = StreamController<String>();
  final double _textViewHeight = 80.0;
  TextEditingController _productNameController = TextEditingController();
  String scannedText = "";
  List<String> textList = [];

  void setText(value) {
    // print(value);
    scannedText = value;
    // controller.add(value);
    // text += value;
    // controller.close();
  }

  void updateText(String newText) {
    setState(() {
      scannedText = newText;
    });
  }

  _scanIngredientsWithOCR() {
    setState(() {});

    print(scannedText);
    if (scannedText.isNotEmpty) {
 HomeScreenState().submitForm(''' ${scannedText})}''', 'ocr');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No text found'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final Offset focusedAreaCenter = Offset(
      0,
      (statusBarHeight + kToolbarHeight) / 2,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: priColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: priColor),
        title: const Text('Scan the Product'),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        child: ElevatedButton(
          onPressed: _scanIngredientsWithOCR,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(priColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      child: FocusedAreaOCRView(
                        focusedAreaHeight: 250,
                        focusedAreaWidth: 300,
                        onScanText: (text) {
                          controller.add(text);
                          textList.add(text);
                          scannedText = text;

                          print(scannedText);
                        },
                        focusedAreaCenter: focusedAreaCenter,
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.all(16.0),
                    //       width: double.infinity,
                    //       height: _textViewHeight * 2.4,
                    //       color: Colors.black,
                    //       child: StreamBuilder<String>(
                    //         stream: controller.stream,
                    //         builder: (BuildContext context,
                    //             AsyncSnapshot<String> snapshot) {
                    //           if (snapshot.hasData) {
                    //             scannedText = snapshot.data!;
                    //           }
                    //           return Text(
                    //             snapshot.data != null ? snapshot.data! : '',
                    //             style: const TextStyle(color: Colors.white),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),

              // Expanded(
              //   child: StreamBuilder<String>(
              //     stream: controller.stream,
              //     builder:
              //         (BuildContext context, AsyncSnapshot<String> snapshot) {
              //       return Result(
              //           text: snapshot.data != null ? snapshot.data! : "");
              //     },
              //   ),
              // ),
              // Text(
              //   'Manually Input Product Name',
              //   style: TextStyle(fontSize: 16, color: Colors.black),
              // ),
              // TextField(
              //   controller: _productNameController,
              //   decoration: InputDecoration(labelText: 'Enter product name'),
              // ),
              // SizedBox(height: 16),
              // if (controller.hasListener)
            ],
          ),
        ),
      ),
    );
  }
}
