import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nurti_guard/ai_analysis/ai_controller.dart';
import 'package:nurti_guard/common/widgets.dart';
import 'package:nurti_guard/const.dart';
import 'package:nurti_guard/home/bottom_nav.dart';
import 'package:nurti_guard/home/home_page.dart';
import 'package:nurti_guard/onboarding/onboarding_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../ai_analysis/ai_report.dart';

class PersonaliseForm extends StatefulWidget {
  PersonaliseForm({
    Key? key,
    required this.isEdit,
  });
  // final prompt;
  // final String sourcePage;
  final bool isEdit;
  @override
  State<PersonaliseForm> createState() => _PersonaliseFormState();
}

class _PersonaliseFormState extends State<PersonaliseForm> {
  final storage = GetStorage();
// InterstitialAd? _interstitialAd;
  @override
  void dispose() {
    // _interstitialAd?.dispose();
    super.dispose();
  }

  // int _numInterstitialLoadAttempts = 0;
  // int maxFailedLoadAttempts = 3;
  // void _showInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => ReportPage(prompt: finalPrompt)),
  //     );
  //     return;
  //   }
  //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       ad.dispose();
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => ReportPage(prompt: finalPrompt)),
  //         (route) => false,
  //       );
  //     },
  //   );
  //   _interstitialAd!.show();
  //   _interstitialAd = null;
  // }

  bool isLoaded = false;
  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: Platform.isIOS
  //         ? 'ca-app-pub-6437987663717750/2923383440'
  //         : "ca-app-pub-6437987663717750/2079993497",
  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (InterstitialAd ad) {
  //         setState(() {
  //           isLoaded = true;
  //         });

  //         _interstitialAd = ad;
  //         _numInterstitialLoadAttempts = 0;
  //         // _showInterstitialAd();
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         _numInterstitialLoadAttempts += 1;
  //         _interstitialAd = null;
  //         if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
  //           _createInterstitialAd();
  //         } else {
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ReportPage(prompt: widget.prompt)),
  //             (route) => false,
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  TextEditingController _allergiesController = TextEditingController();
  TextEditingController _medicalConditionsController = TextEditingController();
  String text = '';
  String _selectedAgeGroup = 'Select';
  String _lang = 'English';
  List<String> lang = [
    'English',
    'Hindi',
    'Russian',
    'Arabic',
    'Bengali',
    'French',
    'Spanish'
  ];
  List<String> ageGroups = [
    'Select',
    '18-27',
    '28-40',
    '41-59',
    '60 and above'
  ];
  List<String> dietaryPreferences = [
    'Select',
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan'
  ];
  String _selectedDietaryPreference = 'Select';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _createInterstitialAd();
    _selectedAgeGroup = ageGroups[0];

    _selectedDietaryPreference = dietaryPreferences[0];
  }

  bool clicked = false;
  String finalPrompt = '';
//   submitForm(String prompt,String sourcePage) async {

//     Get.put(AiController()).productName=prompt;
//     if (!clicked) {
//       showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                 title: Text('Error'),
//                 content: Text('Please select at least one option'),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('OK'))
//                 ],
//               ));
//       return;
//     }

//     if (storage.read('gender') == 'Male' ||
//        storage.read('gender') == 'Select' ||
//         (storage.read('gender') == 'Female' && !storage.read('isPregnantOrLactating'))) {
//       if (sourcePage == 'manual') {
//         finalPrompt =
//             '''The product name of a packaged food is - ${prompt}
// Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

// The consumer is a ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}.
// The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietaryPreference')}.

// Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.
// Then, give a separate paragraph for telling the user if the product is fit for consumption.
// Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not.
// Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product.

// Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone.
// Also, give a personalized response based on the allergies and medical conditions inputted above.
// Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it.

// Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for.
// Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not.
// Also, use the packaging material to draw out the results.
// Please use markdown to format the response.
// Give me a response which considers all the parameters above and generate a final report stating your opinion if the product is fit for consumption or not. Answer in yes or no and for the answer give a suitable reasoning.Give your response in ${storage.read('language')} language''';
//       } else if (sourcePage == 'ocr') {
//         finalPrompt =
//             '''A packed food product contains the following ingredients and information:
// ${prompt}

// The consumer is a ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}.
// The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietaryPreference')}.

//  give a separate paragraph for telling the user if the product is fit for consumption for the user
// If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not.
// Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product.

// Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone.
// Also, give a personalized response based on the allergies and medical conditions inputted above.
// Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it.

// Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and
// Please use markdown to format the response.

// At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
// .Give your response in ${storage.read('language')} language''';
//       } else if (sourcePage == 'barcode') {
//         finalPrompt =
//             '''A packed food product contains the following ingredients and information:
// ${prompt}
// The name of the is - ${prompt}
// If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
// Retrive the information for the desired information about the product from the product name

// The consumer is a ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}.
// The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietaryPreference')}.

// Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.
// Then, give a separate paragraph for telling the user if the product is fit for consumption or not.
// Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not.
// Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product.

// Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone.
// Also, give a personalized response based on the allergies and medical conditions inputted above.
// Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it.

// Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for.
// Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not.
// Also, use the packaging material to draw out the results.
// Please use markdown to format the response.
// If some information is not provided, dont write that the information is not provided rather just skip the part and dont emphasise on it. Only write on the analysis on the given information and do no mention about an information which is not provided. For example if nutriscore is not present, dont write about it rather move on to the next parameter.
// .Give your response in ${storage.read('language')} language''';
//       }
//     } else {
//       if (sourcePage== 'manual') {
//         print('manual');
//         finalPrompt = '''
//       The product name of a packaged food is - ${prompt}
// Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

// The consumer is a ${storage.read('isPregnantOrLactating') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}.
// The user is also allergic to ${storage.read('allergies')} and has a dietary preference of ${storage.read('dietaryPreference')}.The user is a ${storage.read('dietaryPreference')}.

// Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.
// Then, give a separate paragraph for telling the user if the product is fit for consumption for a pregnant woman.
// Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not.
// Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product.

// Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone.
// Also, give a personalized response based on the allergies and medical conditions inputted above.
// Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it.

// Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for.
// Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not.
// Also, use the packaging material to draw out the results.
// Please use markdown to format the response.
// Give me a response which considers all the parameters above and generate a final report stating your opinion if the product is fit for consumption for pregnant women or not. Answer in yes or no and for the answer give a suitable reasoning.
// Use markdown in your response.Give your response in ${storage.read('language')} language''';
//       } else if (sourcePage== 'ocr') {
//         finalPrompt = '''
// A packed food product contains the following ingredients and information:
// ${prompt}

// The consumer is a ${storage.read('isPregnantOrLactating') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}.
// The user is also allergic to ${storage.read('allergies')}. and has a dietary preference of ${storage.read('dietaryPreference')}.The user is a ${storage.read('dietaryPreference')}.

//   give a separate paragraph for telling the user if the product is fit for consumption for the user.
// If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not.
// Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product.

// Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone.
// Also, give a personalized response based on the allergies and medical conditions inputted above.
// Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it.

// Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and
// Please use markdown to format the response.

// At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
// Use markdown in your response.Give your response in ${storage.read('language')} language''';
//       } else if (sourcePage== 'barcode') {
//         finalPrompt = '''
// A packed food product contains the following ingredients and information:
// ${prompt}
// If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
// Retrive the information for the desired information about the product from the product name

// The consumer is a ${storage.read('isPregnantOrLactating') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('selectedAgeGroup')} and has the following medical conditions - ${storage.read('medicalConditions')}.
// The user is also allergic to ${storage.read('allergies')}. and has a dietary preference of ${storage.read('dietaryPreference')}.The user is a ${storage.read('dietaryPreference')}.

// Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.
// Then, give a separate paragraph for telling the user if the product is fit for consumption .
// Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not.
// Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product.

// Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone.
// Also, give a personalized response based on the allergies and medical conditions inputted above.
// Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it.

// Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for.
// Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not.
// Also, use the packaging material to draw out the results.
// Please use markdown to format the response.
// If some information is not provided, dont write that the information is not provided rather just skip the part and dont emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, dont write about it rather move on to the next parameter.
// Use markdown in your response.Give your response in ${storage.read('language')} language''';
//       }
//     }

//     // _showInterstitialAd();
//     Get.offAll(OnboardingView());
//   }

  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
  }

  var _selectedGender = '';
  var _isPregnantOrLactating = false;
  TextStyle titleFont = GoogleFonts.signika(
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: Color(0xFF4D4B4B),
  );
  TextStyle hintFont = GoogleFonts.signika(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: Color(0xFF4D4B4B));
  @override
  Widget build(BuildContext context) {
// storage.read('isFormFilled')?    submitForm():null;
// submitForm();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => BottomNav()));
            // Navigator.pop(context);
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: HomePage(),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: priColor, statusBarColor: priColor),
        title: Text('Personalisation Panel',
            style: GoogleFonts.signika(
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //  mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 6,
              ),
              Text(
                  'Please provide us with personal details, so that we can personalise your analysis. It will help us serve you a with more personalised and accurate analysis.',
                  style: GoogleFonts.signika(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  )),
              SizedBox(
                height: 6,
              ),
              Divider(),
              SizedBox(
                height: 6,
              ),
              Text('Gender', style: titleFont),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  ZoomTapAnimation(
                    onTap: () async {
                      setState(() {
                        _selectedGender = "Male";
                      });
                      await storage.write('gender', 'Male');
                    },
                    child: CommonSelectionButton(
                      title: 'Male',
                      color: _selectedGender == "Male"
                          ? Color(0xFF9FD796)
                          : Color(0xFFD9D9D9),
                    ),
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                  ZoomTapAnimation(
                    onTap: () async {
                      setState(() {
                        _selectedGender = "Female";
                      });
                      await storage.write('gender', 'Female');
                    },
                    child: CommonSelectionButton(
                      title: 'Female',
                      color: _selectedGender == "Female"
                          ? Color(0xFF9FD796)
                          : Color(0xFFD9D9D9),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 34.h),
              Text('Age Group', style: titleFont),
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 46.h,
                width: 140.w,
                decoration: BoxDecoration(
                    color: Color(0xFFFFF8EB),
                    borderRadius: BorderRadius.circular(12.w)),
                child: Center(
                  child: DropdownButton<String>(
                    value: _selectedAgeGroup,
                    onChanged: (value) async {
                      setState(() {
                        _selectedAgeGroup = value!;
                        clicked = true;
                      });
                      await storage.write(
                          'selectedAgeGroup', _selectedAgeGroup);
                    },
                    items: ageGroups
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: hintFont.copyWith(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 34.h,
              ),
              if (_selectedGender == 'Female')
                Text(
                  'Pregnant or Lactating',
                  style: titleFont,
                ),
              if (_selectedGender == 'Female')
                SizedBox(
                  height: 20.h,
                ),
              if (_selectedGender == 'Female')
                Column(
                  children: [
                    Row(
                      children: [
                        ZoomTapAnimation(
                          onTap: () async {
                            setState(() {
                              _isPregnantOrLactating = true;
                            });
                            await storage.write('isPregnantOrLactating', true);
                          },
                          child: CommonSelectionButton(
                              title: "Yes",
                              color: _isPregnantOrLactating
                                  ? Color(0xFF9FD796)
                                  : Color(0xFFD9D9D9)),
                        ),
                        SizedBox(
                          width: 18.w,
                        ),
                        ZoomTapAnimation(
                          onTap: () async {
                            setState(() {
                              _isPregnantOrLactating = false;
                            });
                            await storage.write('isPregnantOrLactating', false);
                          },
                          child: CommonSelectionButton(
                            title: "No",
                            color: !_isPregnantOrLactating
                                ? Color(0xFF9FD796)
                                : Color(0xFFD9D9D9),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 34.h),
                  ],
                ),
              Text('Dietary Preference', style: titleFont),
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 46.h,
                width: 155.w,
                decoration: BoxDecoration(
                    color: Color(0xFFFFF8EB),
                    borderRadius: BorderRadius.circular(12.w)),
                child: Center(
                  child: DropdownButton<String>(
                    value: _selectedDietaryPreference,
                    onChanged: (value) async {
                      setState(() {
                        _selectedDietaryPreference = value!;
                        clicked = true;
                      });
                      storage.write(
                          'dietaryPreference', _selectedDietaryPreference);
                    },
                    items: dietaryPreferences
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: hintFont.copyWith(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 34.h),
              Text(
                'Allergies',
                style: titleFont,
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 190.w,
                height: 49.h,
                decoration: BoxDecoration(
                    color: Color(0xFFEFF7EE),
                    borderRadius: BorderRadius.circular(12.w)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TextField(
                    controller: _allergiesController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Allergies If Any',
                        hintStyle: hintFont),
                  ),
                ),
              ),
              SizedBox(height: 34.h),
              Text(
                'Medical Conditions',
                style: titleFont,
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 240.w,
                height: 49.h,
                decoration: BoxDecoration(
                    color: Color(0xFFEFF7EE),
                    borderRadius: BorderRadius.circular(12.w)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TextField(
                    controller: _medicalConditionsController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Medical Conditions if any',
                        hintStyle: hintFont),
                  ),
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              ZoomTapAnimation(
                onTap: () async {
                  var file = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ['pdf']);
                  if (file != null) {
                    var path = file.files.single.path;
                    var text = await getPDFtext(path!);
                    setState(() {
                      _medicalConditionsController.text = text;
                      clicked = true;
                    });
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('PDF Uploaded'),
                              content: Text('PDF Uploaded Successfully'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'))
                              ],
                            ));
                    print(text);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(''),
                              content: Text('PDF Not Uploaded'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'))
                              ],
                            ));
                    // Implement the logic to upload PDF file
                    // This could open a file picker or any relevant action
                  }
                },
                child: Container(
                  height: 36.h,
                  width: 133.w,
                  decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12.w)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          CupertinoIcons.cloud_upload,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          "Upload PDF",
                          style: GoogleFonts.signika(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 16.sp),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 34.h,
              ),
              Text('Preferred Language', style: titleFont),
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 46.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Color(0xFFFFF8EB),
                    borderRadius: BorderRadius.circular(12.w)),
                child: Center(
                  child: DropdownButton<String>(
                    value: _lang,
                    onChanged: (value) async {
                      setState(() {
                        _lang = value!;
                      });
                      await storage.write('language', _lang);
                    },
                    items: lang
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: hintFont,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 34.h,
              ),
              ZoomTapAnimation(
                onTap: () {
//  submitForm(widget.prompt,widget.sourcePage);
                  if (_selectedGender != "" &&
                      _selectedAgeGroup != "Select" &&
                      _selectedDietaryPreference != "Select") {
                    widget.isEdit
                        ? Get.offAll(BottomNav())
                        : Get.offAll(OnboardingView());
                  } else {
                    CommonWidgets.showToast("Please enter required fields");
                  }
                },
                child: Center(
                  child: Container(
                    height: 65.h,
                    width: 244.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.w),
                      color: Color(0xFF91C788),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: GoogleFonts.signika(
                            fontSize: 25.h,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonSelectionButton extends StatelessWidget {
  const CommonSelectionButton({
    super.key,
    required this.title,
    required this.color,
  });
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Center(
          child: Text(
        title,
        style: GoogleFonts.signika(
            fontWeight: FontWeight.w400, fontSize: 16.sp, color: Colors.black),
      )),
    );
  }
}
