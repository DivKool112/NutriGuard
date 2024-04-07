// import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nurti_guard/ai_analysis/ai_controller.dart';
import 'package:nurti_guard/ai_analysis/ai_report.dart';
import 'package:nurti_guard/common/widgets.dart';
import 'package:nurti_guard/home/PersonaliseForum.dart';
import 'package:nurti_guard/home/bottom_nav.dart';
import 'package:nurti_guard/home/scanning_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../api/api_barcode.dart';
import '../const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomePage> {
  final storage = GetStorage();

  InterstitialAd? _interstitialAd;
  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  void _showInterstitialAd() {
    print('reached');
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      // Navigator.push(
      //   context,
      // MaterialPageRoute(
      //     builder: (context) => ReportPage(prompt: finalPrompt)),

      // );
      //  PersistentNavBarNavigator.pushNewScreen(
      //     context,
      //     screen: ReportPage(prompt: finalPrompt),
      //     withNavBar: false, // OPTIONAL VALUE. True by default.
      //     pageTransitionAnimation: PageTransitionAnimation.cupertino,
      //   );

      Get.to(ReportPage(prompt: finalPrompt));
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ReportPage(prompt: finalPrompt)),
        //   (route) => false,
        // );
        Get.to(ReportPage(prompt: finalPrompt));
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  bool isLoaded = false;
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isIOS
          ? 'ca-app-pub-6437987663717750/2923383440'
          : "ca-app-pub-6437987663717750/2079993497",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            isLoaded = true;
          });

          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          // _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          } else {
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => ReportPage(prompt: finalPrompt)),
            //   (route) => false,
            // );
            Get.to(ReportPage(prompt: prompt!));
          }
        },
      ),
    );
  }

  String finalPrompt = '';
  submitForm(String prompt, String sourcePage) async {
    print(prompt);
    Get.put(AiController()).productName = prompt;
    print('${Get.put(AiController()).productName}');
    print('${storage.read('language')}');
    print('printed');
    // if (!clicked) {
    //   showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //             title: Text('Error'),
    //             content: Text('Please select at least one option'),
    //             actions: [
    //               TextButton(
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                   },
    //                   child: Text('OK'))
    //             ],
    //           ));
    //   return;
    // }

    if (storage.read('gender') == 'Male' ||
        storage.read('gender') == 'Select' ||
        (storage.read('gender') == 'Female' &&
            !storage.read('isPregnantOrLactating'))) {
      if (sourcePage == 'manual') {
        finalPrompt = '''The product name of a packaged food is - ${prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietaryPreference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
Give me a response which considers all the parameters above and generate a final report stating your opinion if the product is fit for consumption or not. Answer in yes or no and for the answer give a suitable reasoning.Give your response in ${storage.read('language')} language''';
      } else if (sourcePage == 'ocr') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${prompt}

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietaryPreference')}.

 give a separate paragraph for telling the user if the product is fit for consumption for the user
If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and 
Please use markdown to format the response.

At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
.Give your response in ${storage.read('language')} language''';
      } else if (sourcePage == 'barcode') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${prompt}
The name of the is - ${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrive the information for the desired information about the product from the product name 

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietaryPreference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption or not.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, dont write that the information is not provided rather just skip the part and dont emphasise on it. Only write on the analysis on the given information and do no mention about an information which is not provided. For example if nutriscore is not present, dont write about it rather move on to the next parameter.
.Give your response in ${storage.read('language')} language''';
      }
    } else {
      if (sourcePage == 'manual') {
        print('manual');
        finalPrompt = '''
      The product name of a packaged food is - ${prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

The consumer is a ${storage.read('isPregnantOrLactating') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}. 
The user is also allergic to ${storage.read('allergies')} and has a dietary preference of ${storage.read('dietaryPreference')}.The user is a ${storage.read('dietaryPreference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption for a pregnant woman. 
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
Give me a response which considers all the parameters above and generate a final report stating your opinion if the product is fit for consumption for pregnant women or not. Answer in yes or no and for the answer give a suitable reasoning.
Use markdown in your response.Give your response in ${storage.read('language')} language''';
      } else if (sourcePage == 'ocr') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${prompt}

The consumer is a ${storage.read('isPregnantOrLactating') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}. 
The user is also allergic to ${storage.read('allergies')}. and has a dietary preference of ${storage.read('dietaryPreference')}.The user is a ${storage.read('dietaryPreference')}.

  give a separate paragraph for telling the user if the product is fit for consumption for the user. 
If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and 
Please use markdown to format the response.

At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
Use markdown in your response.Give your response in ${storage.read('language')} language''';
      } else if (sourcePage == 'barcode') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrive the information for the desired information about the product from the product name 

The consumer is a ${storage.read('isPregnantOrLactating') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}. 
The user is also allergic to ${storage.read('allergies')}. and has a dietary preference of ${storage.read('dietaryPreference')}.The user is a ${storage.read('dietaryPreference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption . 
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con Fin the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, dont write that the information is not provided rather just skip the part and dont emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, dont write about it rather move on to the next parameter.
Use markdown in your response.Give your response in ${storage.read('language')} language''';
      }
    }

    _showInterstitialAd();
  }

  List<String> tipTitle = [
    'More Than 821 Million People',
    '2.8 Million Death EACH YEAR',
    'Pregnant Women Need Help',
    'Importance of Calcium',
    'Importance of Iron',
    'People In Rural Areas Unknown To The Dangers',
    'NUTRIGUARD IS HERE'
  ];
  List<String> sub = [
    'Suffer from Malnutrition globally each year as a result of poor food and dietary habits',
    'Are attributed to obesity and diabetes related illnesses.',
    'Nutrients such as folic acid, iron and calcium are critical for fetal development in pregnant women and are a leading cause of deformities among newborns',
    'Calcium is essential for building your baby\'s bones and teeth. Fulfilment of daily requirements will help ensure that the baby is born healthy.',
    'Iron supports the baby\'s growth and helps prevent anemia in mothers. Proving to be essential for people of all age groups and gender.',
    'People residing in rural areas are unaware of their dietary choices and what\'s really going into their body. We are here to CHANGE this. We offer more than 5 native Indian Languages so that NutriGuard is accessible by everyone.',
    'Your Food. Your Health. Our App'
  ];
  searchManually() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Searching...'),
            content: SizedBox(
                height: 100, child: Center(child: CircularProgressIndicator())),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
    // CommonWidgets.showToast("Searching Please Wait");
    prompt = await getProductDetailsByName(barController.text);
    prompt = (barController.text);

    // Navigator.pop(context);
    //TODO
    try {
      if (prompt!.isNotEmpty) {
        submitForm(prompt!, 'manual');
      } else {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ScanningPage()));
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ScanningPage(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      }
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Product not found. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            );
          });
    }
    print('hi');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _createInterstitialAd();
  }

  String? prompt;
  TextEditingController barController = TextEditingController();
  // var hi = MediaQuery.of(context).size.height;
  // var wi = MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 222, 222, 222),
      // backgroundColor: Color(0xFFDDE9F7),
      // backgroundColor: Color(0xFFE3EDF7),
      // backgroundColor: Color.fromARGB(255, 165, 205, 176),
      backgroundColor: Color(0xFF39e75f),
      // appBar: AppBar(
      //   backgroundColor: priColor,
      //   // title: Text(
      //   //   'Nutri Guide',
      //   //   // style: TextStyle(color: Colors.white),
      //   // ),
      //   automaticallyImplyLeading: false,
      //   title: Container(
      //     height: MediaQuery.of(context).size.height * 0.06,
      //     child: Image.asset(
      //       'assets/logo.jpeg',
      //       fit: BoxFit.fill,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 21.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 18.h,
                ),
                // Container(
                //   child: Image.asset('assets/logo.png'),
                // ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Color(0xFFF4F4F4)),
                  // width: wi,
                  height: 64.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 21.w,
                      ),
                      SizedBox(
                        width: 260.w,
                        child: TextField(
                          controller: barController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search manually by product name',
                            hintStyle: GoogleFonts.signika(
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.bold),
                            // contentPadding:
                            //     EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            // suffix: InkWell(
                            //   onTap: searchManually,
                            //   child:
                            //       Icon(Icons.search, color: Color(0xFF999999)),
                            // ),
                          ),
                        ),
                      ),
                      ZoomTapAnimation(
                        onTap: searchManually,
                        child: Icon(
                          Icons.search,
                          color: Color(0xFF999999),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                SizedBox(
                  width: 136.h,
                  child: GestureDetector(
                    onTap: () {
                      print("${GetStorage().read('isFormFilled')}");
                    },
                    // child: Text(
                    //   "Nutri Guard",
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.signika(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 35.sp,
                    //     color: Color(0xFF89BA81),
                    //   ),
                    // ),
                    child: Image.asset(
                      "assets/app_logo.png",
                      width: 180.w,
                      height: 100.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "is here",
                  style: GoogleFonts.signika(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                    // color: Color(0xFF8C8C8C),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF9E9BC7),
                      borderRadius: BorderRadius.circular(32.w)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
                    child: Row(children: [
                      SizedBox(
                        width: 138.w,
                        child: Text(
                          "Scan Barcodes directly here",
                          style: GoogleFonts.signika(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ZoomTapAnimation(
                        onTap: () async {
                          String barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                                  "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                          // showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return AlertDialog(
                          //         title: Text('Searching...'),
                          //         content: SizedBox(
                          //             height: 100,
                          //             child: Center(
                          //                 child: SpinKitCircle(
                          //               color: Color(0xFF91C788),
                          //             ) //CircularProgressIndicator(),
                          //                 )),
                          //         // actions: [
                          //         //   TextButton(
                          //         //     onPressed: () {
                          //         //       Navigator.pop(context);
                          //         //     },
                          //         //     child: Text('Cancel'),
                          //         //   )
                          //         // ],
                          //       );
                          //     });
                          CommonWidgets.showToast("Searching...");
                          if (barcodeScanRes != null) {
                            prompt = await getProductDetails(barcodeScanRes);
                            // Navigator.pop(context);
                            // print(prompt);
                            try {
                              if (prompt!.isNotEmpty) {
                                submitForm(prompt!, 'barcode');
                              } else {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ScanningPage()));
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: ScanningPage(),
                                  withNavBar:
                                      false, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              }
                            } catch (e) {
                              CommonWidgets.showToast(
                                  "Product not found. Please try again");
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         title: Text('Error'),
                              //         content: Text(
                              //             'Product not found. Please try again.'),
                              //         actions: [
                              //           TextButton(
                              //             onPressed: () {
                              //               Navigator.pop(context);
                              //             },
                              //             child: Text('OK'),
                              //           )
                              //         ],
                              //       );
                              //     });
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.w),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Row(children: [
                              Image.asset("assets/qr_icon.png"),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                "Scan Now",
                                style: GoogleFonts.signika(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  color: Color(0xFF9E9BC7),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFFFF8EB),
                      borderRadius: BorderRadius.circular(32.w)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 22.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Know about",
                                style: GoogleFonts.signika(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF806E)),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(
                                width: 125.w,
                                child: Text(
                                  "The pros and cons of fast food by ingredients",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              ZoomTapAnimation(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ScanningPage()));
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: ScanningPage(),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Row(children: [
                                      Image.asset(
                                        "assets/qr_icon.png",
                                        color: Color(0xFF776565),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        "Scan Ingredients",
                                        style: GoogleFonts.signika(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                            color: Color(0xFF776565)),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Image.asset("assets/fast_food_image.png"),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 132.w,
                        height: 144.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.w),
                            color: Color(0xFFDAEDD6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "More About Us",
                              style: GoogleFonts.signika(
                                  fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                            ZoomTapAnimation(
                              onTap: () {
                                Get.put(BottomNavController())
                                    .controller
                                    .jumpToTab(1);
                              },
                              child: Container(
                                width: 98.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32.w)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 13.w,
                                      ),
                                      Icon(
                                        CupertinoIcons.exclamationmark_circle,
                                        color: Color(0xFF776565),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        "View",
                                        style: GoogleFonts.signika(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 13.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 132.w,
                        height: 144.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.w),
                          color: Color(0xFFFFF8EB),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Chat with AI",
                              style: GoogleFonts.signika(
                                  fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                            ZoomTapAnimation(
                              onTap: () {
                                Get.put(BottomNavController())
                                    .controller
                                    .jumpToTab(2);
                              },
                              child: Container(
                                width: 98.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32.w)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                      Icon(
                                        Icons.message_outlined,
                                        color: Color(0xFF776565),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        "Chat now",
                                        style: GoogleFonts.signika(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                ZoomTapAnimation(
                  onTap: () async {
                    try {
                      launchUrlString(
                          "https://milaap.org/fundraisers/support-nutriguard?utm_source=whatsapp&utm_medium=fundraisers-title&mlp_referrer_id=9431386");
                    } catch (e) {
                      Get.defaultDialog(
                          title: "Plrase Try Again After Sometime",
                          middleText: "");
                    }
                  },
                  child: Text(
                    "Donate now to help spreading health and nutritional awareness",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 47, 85),
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
