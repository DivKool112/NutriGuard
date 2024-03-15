import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nurti_guard/const.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

import '../ai_analysis/ai_report.dart';

class PersonaliseForm extends StatefulWidget {
  PersonaliseForm({Key? key, required this.prompt, required this.sourcePage});
  final prompt;
  final String sourcePage;

  @override
  State<PersonaliseForm> createState() => _PersonaliseFormState();
}

class _PersonaliseFormState extends State<PersonaliseForm> {
  InterstitialAd? _interstitialAd;

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportPage(prompt: finalPrompt)),
      );
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ReportPage(prompt: finalPrompt)),
          (route) => false,
        );
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => ReportPage(prompt: widget.prompt)),
              (route) => false,
            );
          }
        },
      ),
    );
  }

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
    _createInterstitialAd();
    _selectedAgeGroup = ageGroups[0];

    _selectedDietaryPreference = dietaryPreferences[0];
  }

  bool clicked = false;
  String finalPrompt = '';
  submitForm() async {
    if (!clicked) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Please select at least one option'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              ));
      return;
    }
    print(widget.prompt);

    if (_selectedGender == 'Male' ||
        _selectedGender == 'Select' ||
        (_selectedGender == 'Female' && !_isPregnantOrLactating)) {
      if (widget.sourcePage == 'manual') {
        finalPrompt =
            '''The product name of a packaged food is - ${widget.prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

The consumer is a ${_selectedGender} who has an age of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text}. 
The user is also allergic to ${_allergiesController.text}. The user is a ${_selectedDietaryPreference}.

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
Give me a response which considers all the parameters above and generate a final report stating your opinion if the product is fit for consumption or not. Answer in yes or no and for the answer give a suitable reasoning.Give your response in ${_lang} language''';
      } else if (widget.sourcePage == 'ocr') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${widget.prompt}

The consumer is a ${_selectedGender} who has an age of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text}. 
The user is also allergic to ${_allergiesController.text}. The user is a ${_selectedDietaryPreference}.

 give a separate paragraph for telling the user if the product is fit for consumption for the user
If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and 
Please use markdown to format the response.

At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
.Give your response in ${_lang} language''';
      } else if (widget.sourcePage == 'barcode') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${widget.prompt}
The name of the is - ${widget.prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrive the information for the desired information about the product from the product name 

The consumer is a ${_selectedGender} who has an age of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text}. 
The user is also allergic to ${_allergiesController.text}. The user is a ${_selectedDietaryPreference}.

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
.Give your response in ${_lang} language''';
      }
    } else {
      if (widget.sourcePage == 'manual') {
        print('manual');
        finalPrompt = '''
      The product name of a packaged food is - ${widget.prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

The consumer is a ${_isPregnantOrLactating ? 'pregnant' : ''} ${_selectedGender} who has an age of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text}. 
The user is also allergic to ${_allergiesController.text} and has a dietary preference of ${_selectedDietaryPreference}.The user is a ${_selectedDietaryPreference}.

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
Use markdown in your response.Give your response in ${_lang} language''';
      } else if (widget.sourcePage == 'ocr') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${widget.prompt}

The consumer is a ${_isPregnantOrLactating ? 'pregnant' : ''} ${_selectedGender} who has an age of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text}. 
The user is also allergic to ${_allergiesController.text}. and has a dietary preference of ${_selectedDietaryPreference}.The user is a ${_selectedDietaryPreference}.

  give a separate paragraph for telling the user if the product is fit for consumption for the user. 
If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and 
Please use markdown to format the response.

At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
Use markdown in your response.Give your response in ${_lang} language''';
      } else if (widget.sourcePage == 'barcode') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${widget.prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrive the information for the desired information about the product from the product name 

The consumer is a ${_isPregnantOrLactating ? 'pregnant' : ''} ${_selectedGender} who has an age of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text}. 
The user is also allergic to ${_allergiesController.text}. and has a dietary preference of ${_selectedDietaryPreference}.The user is a ${_selectedDietaryPreference}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption . 
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, dont write that the information is not provided rather just skip the part and dont emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, dont write about it rather move on to the next parameter.
Use markdown in your response.Give your response in ${_lang} language''';
      }
    }

    _showInterstitialAd();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: priColor, statusBarColor: priColor),
        backgroundColor: priColor,
        title: Text(
          'Personalisation Panel',
          style: GoogleFonts.lato(),
        ),
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
                style: GoogleFonts.oswald(fontSize: 17.6, color: Colors.black),
              ),
              SizedBox(
                height: 6,
              ),
              Divider(),
              SizedBox(
                height: 6,
              ),
              Text(
                'Gender',
                style: GoogleFonts.oswald(fontSize: 19, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: priColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Radio(
                          value: 'Male',
                          activeColor: Colors.white,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value.toString();
                              clicked = true;
                            });
                          },
                        ),
                        Text('Male'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: priColor),
                    child: Row(
                      children: [
                        Radio(
                          activeColor: Colors.white,
                          value: 'Female',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value.toString();
                              clicked = true;
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Age Group',
                  style: GoogleFonts.oswald(color: Colors.black, fontSize: 19)),
              DropdownButton<String>(
                value: _selectedAgeGroup,
                onChanged: (value) {
                  setState(() {
                    _selectedAgeGroup = value!;
                    clicked = true;
                  });
                },
                items: ageGroups
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              if (_selectedGender == 'Female')
                Text(
                  'Pregnant or Lactating',
                  style: GoogleFonts.oswald(fontSize: 19, color: Colors.black),
                ),
              if (_selectedGender == 'Female')
                SizedBox(
                  height: 10,
                ),
              if (_selectedGender == 'Female')
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: priColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            activeColor: Colors.white,
                            value: true,
                            groupValue: _isPregnantOrLactating,
                            onChanged: (value) {
                              setState(() {
                                _isPregnantOrLactating =
                                    !_isPregnantOrLactating;
                                clicked = true;
                              });
                            },
                          ),
                          Text('Yes'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: priColor),
                      child: Row(
                        children: [
                          Radio(
                            activeColor: Colors.white,
                            value: false,
                            groupValue: _isPregnantOrLactating,
                            onChanged: (value) {
                              setState(() {
                                _isPregnantOrLactating =
                                    !_isPregnantOrLactating;
                                clicked = true;
                              });
                            },
                          ),
                          Text('No'),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              Text('Dietary Preference',
                  style: GoogleFonts.oswald(color: Colors.black, fontSize: 19)),
              DropdownButton<String>(
                value: _selectedDietaryPreference,
                onChanged: (value) {
                  setState(() {
                    _selectedDietaryPreference = value!;
                    clicked = true;
                  });
                },
                items: dietaryPreferences
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Allergies',
                style: GoogleFonts.oswald(fontSize: 19, color: Colors.black),
              ),
              TextField(
                controller: _allergiesController,
                decoration:
                    InputDecoration(labelText: 'Enter Allergies If Any'),
              ),
              SizedBox(height: 16),
              Text(
                'Medical Conditions',
                style: GoogleFonts.oswald(fontSize: 19, color: Colors.black),
              ),
              TextField(
                controller: _medicalConditionsController,
                decoration: InputDecoration(
                    labelText: 'Enter Medical Conditions if any'),
              ),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () async {
                    var file = await FilePicker.platform.pickFiles(
                        type: FileType.custom, allowedExtensions: ['pdf']);
                    if (file != null) {
                      var path = file.files.single.path;
                      var text = await getPDFtext(path!);
                      setState(() {
                        _medicalConditionsController.text = text;
                        clicked = true;
                      });
                      print(text);
                    } else {
                      // Implement the logic to upload PDF file
                      // This could open a file picker or any relevant action
                    }
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('PDF Uploaded'),
                              content: Text(
                                  'The PDF has been uploaded successfully'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'))
                              ],
                            ));
                  },
                  child: Text('or Upload PDF'),
                ),
              ),
              SizedBox(height: 16),
              Text('Preferred Language',
                  style: GoogleFonts.oswald(color: Colors.black, fontSize: 19)),
              DropdownButton<String>(
                value: _lang,
                onChanged: (value) {
                  setState(() {
                    _lang = value!;
                  });
                },
                items: lang
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              Center(
                child: InkWell(
                  onTap: submitForm,
                  child: Container(
                    decoration: BoxDecoration(
                        color: priColor,
                        borderRadius: BorderRadius.circular(13)),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Submit',
                      style:
                          GoogleFonts.oswald(fontSize: 17, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
