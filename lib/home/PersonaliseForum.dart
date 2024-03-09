import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  TextEditingController _allergiesController = TextEditingController();
  TextEditingController _medicalConditionsController = TextEditingController();
  String text = '';
  String _selectedAgeGroup = 'Select';
  String _lang = 'English';
  List<String> lang = [
    'English',
    'Hindi',
    'Urdu',
    'Marathi',
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
    _selectedAgeGroup = ageGroups[0];

    _selectedDietaryPreference = dietaryPreferences[0];
  }

  submitForm() async {
    print(widget.prompt);
    String finalPrompt = '';
    if (_selectedGender == 'Male' ||
        _selectedGender == 'Select' ||
        (_selectedGender == 'Female' && !_isPregnantOrLactating)) {
      if (widget.sourcePage == 'manual') {
        finalPrompt =
            '''We are making a food scanner app through which the users can enter the name of the product and they can get personalized analysis about it. The personalized information is retrieved through a personalisation page from the user. The user is asked for their age, gender, dietary preference, medical conditions and allergies. Now for the final analysis page, generate a report for the food product using the information given below.

The product name of a packaged food is - ${widget.prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore,  carbon footprint, health hazards which may be associated with it, etc.

The consumer is a ${_selectedGender} who falls in a age group of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text} (ignore if it's written none)
The user is also allergic to ${_allergiesController.text} (ignore if written none)
The user is a ${_selectedDietaryPreference}

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.

After which, in a separate paragraph, list out the pros of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term benefits and short term benefits also if any. At Least 3.

After which in a separate paragraph, list out the cons of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term harms and short terms harms also if any. At Least 3.

In the next paragraph, using all the information of the user given above like age, gender, lactating or not, dietary preference, medical conditions and allergies. Create a report for the user stating whether the consumer should consume the product and will it be fit for consumption for him/her as per their preferences. Write it in a concise manner in which you talk straight to the point and avoid any unnecessary information to be added. Make it as informative as possible in bold and effective words. 

In the next paragraph, use the nutriscore of the product and state it to the user. Describe what is nutriscore and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, talk about the environmental aspect of the product. Firstly, state the material from which the packaging of the product is made from and state if it is environmentally friendly or not. Then by also considering the emissions in the production of the product, give out the carbon footprint which may be caused by the product. Talk about the potential benefits of the packaging material. Use the ecoscore of the product and state it to the user. Describe what ecoscore is and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, suggest any healthier and better alternatives than the entered product. Give reasons for choosing the alternative and how it is better. Give atleast 2 alternatives and mention their brand, product name and any necessary information.

Throughout the response, consider all the EU food guidelines, WHO reports, FSSAI reports, UN’s Food and Agricultural Organisation and other important food guidelines to analyze the product. Check if the product contains any substance or ingredients which is considered harmful according to the reports or is banned in any country due to its harmful effects. If true, then mention it but don't include URLs and add in which countries it is banned.

USE MARKDOWN to format the response. It is a necessary requirement. 

The language of the report should be in ${_lang} language.''';
      } else if (widget.sourcePage == 'ocr') {
        finalPrompt =
            '''We are making a food scanner app through which the users can enter the name of the product and they can get personalized analysis about it. The personalized information is retrieved through a personalisation page from the user. The user is asked for their age, gender, dietary preference, medical conditions and allergies. Now for the final analysis page, generate a report for the food product using the information given below.

The food product has the following ingredients: ${widget.prompt}
Using these ingredients, retrieve the product name if you can, if you cannot just retrieve the nutritional values, the material of their packaging, nutriscore, ecoscore,  carbon footprint, health hazards which may be associated with it, etc.

The consumer is a ${_selectedGender} who falls in a age group of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text} ( ignore if it's written none)
The user is also allergic to ${_allergiesController.text} (ignore if written none)
The user is a ${_selectedDietaryPreference}

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.

After which, in a separate paragraph, list out the pros of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term benefits and short term benefits also if any. At Least 3.

After which in a separate paragraph, list out the cons of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term harms and short terms harms also if any. At Least 3.

In the next paragraph, using all the information of the user given above like age, gender, lactating or not, dietary preference, medical conditions and allergies. Create a report for the user stating whether the consumer should consume the product and will it be fit for consumption for him/her as per their preferences. Write it in a concise manner in which you talk straight to the point and avoid any unnecessary information to be added. Make it as informative as possible in bold and effective words. 

In the next paragraph, use the nutriscore of the product and state it to the user. Describe what is nutriscore and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, talk about the environmental aspect of the product. Firstly, state the material from which the packaging of the product is made from and state if it is environmentally friendly or not. Then by also considering the emissions in the production of the product, give out the carbon footprint which may be caused by the product. Talk about the potential benefits of the packaging material . Use the ecoscore of the product and state it to the user. Describe what ecoscore is and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, suggest any healthier and better alternatives than the entered product. Give reasons for choosing the alternative and how it is better. Give atleast 2 alternatives and mention their brand, product name and any necessary information.

Throughout the response, consider all the EU food guidelines, WHO reports, FSSAI reports, UN’s Food and Agricultural Organisation and other important food guidelines to analyze the product. Check if the product contains any substance or ingredients which is considered harmful according to the reports or is banned in any country due to its harmful effects. If true, then mention it but don't include URLs and add in which countries it is banned.

USE MARKDOWN to format the response. It is a necessary requirement. 

Give your response in ${_lang} language''';
      } else if (widget.sourcePage == 'barcode') {
        finalPrompt =
            '''We are making a food scanner app through which the users can enter the name of the product and they can get personalized analysis about it. The personalized information is retrieved through a personalisation page from the user. The user is asked for their age, gender, dietary preference, medical conditions and allergies. Now for the final analysis page, generate a report for the food product using the information given below.

The product has the following information: ${widget.prompt}
Use this information and your knowledge to provide your analysis. If some values or information are not provided, retrieve its ingredients,nutritional values, the material of their packaging, nutriscore, ecoscore,  carbon footprint, health hazards which may be associated with it, etc.

The consumer is a ${_selectedGender} who falls in a age group of ${_selectedAgeGroup} and has the following medical conditions - ${_medicalConditionsController.text} ( ignore if it's written none)
The user is also allergic to ${_allergiesController.text} (ignore if written none)
The user is a ${_selectedDietaryPreference}

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.

After which, in a separate paragraph, list out the pros of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term benefits and short term benefits also if any. At Least 3.

After which in a separate paragraph, list out the cons of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term harms and short terms harms also if any. At Least 3.

In the next paragraph, using all the information of the user given above like age, gender, lactating or not, dietary preference, medical conditions and allergies. Create a report for the user stating whether the consumer should consume the product and will it be fit for consumption for him/her as per their preferences. Write it in a concise manner in which you talk straight to the point and avoid any unnecessary information to be added. Make it as informative as possible in bold and effective words. 

In the next paragraph, use the nutriscore of the product and state it to the user. Describe what is nutriscore and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, talk about the environmental aspect of the product. Firstly, state the material from which the packaging of the product is made from and state if it is environmentally friendly or not. Then by also considering the emissions in the production of the product, give out the carbon footprint which may be caused by the product. Talk about the potential benefits of the packaging material. Use the ecoscore of the product and state it to the user. Describe what ecoscore is and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, suggest any healthier and better alternatives than the entered product. Give reasons for choosing the alternative and how it is better. Give atleast 2 alternatives and mention their brand, product name and any necessary information.

Throughout the response, consider all the EU food guidelines, WHO reports, FSSAI reports, UN’s Food and Agricultural Organisation and other important food guidelines to analyze the product. Check if the product contains any substance or ingredients which is considered harmful according to the reports or is banned in any country due to its harmful effects. If true, then mention it but don't include URLs and add in which countries it is banned.

USE MARKDOWN to format the response. It is a necessary requirement. 

The language of the report should be ${_lang} language''';
      }
    } else {
      if (widget.sourcePage == 'manual') {
        print('manual');
        finalPrompt = 
          '''We are making a food scanner app through which the users can enter the name of the product and they can get personalized analysis about it. The personalized information is retrieved through a personalisation page from the user. The user is asked for their age, gender, dietary preference, medical conditions and allergies. Now for the final analysis page, generate a report for the food product using the information given below.

The product name of a packaged food is - ${widget.prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore,  carbon footprint, health hazards which may be associated with it, etc.

The consumer is pregnant and lactating women who falls in a age group of ${_selectedAgeGroup} and also has the following medical conditions - ${_medicalConditionsController.text} ( ignore if it's written none)
The user is also allergic to ${_allergiesController.text} (ignore if written none)
The user is a ${_selectedDietaryPreference}

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.

After which, in a separate paragraph, list out the pros of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term benefits and short term benefits also if any. At Least 2 general and 1-2 specific for this pregnant woman.

After which in a separate paragraph, list out the cons of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term harms and short terms harms also if any. At Least 2 general and 1-2 specific for this pregnant woman.

In the next paragraph, using all the information of the user given above like age, gender, lactating or not, dietary preference, medical conditions and allergies. Create a report for the user stating whether the consumer should consume the product and will it be fit for consumption for him/her as per their preferences. Write it in a concise manner in which you talk straight to the point and avoid any unnecessary information to be added. Make it as informative as possible in bold and effective words. 

In the next paragraph, use the nutriscore of the product and state it to the user. Describe what is nutriscore and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, talk about the environmental aspect of the product. Firstly, state the material from which the packaging of the product is made from and state if it is environmentally friendly or not. Then by also considering the emissions in the production of the product, give out the carbon footprint which may be caused by the product. Talk about the potential benefits of the packaging material. Use the ecoscore of the product and state it to the user. Describe what ecoscore is and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, suggest any healthier and better alternatives than the entered product. Give reasons for choosing the alternative and how it is better. Give atleast 2 alternatives and mention their brand, product name and any necessary information.

Throughout the response, consider all the EU food guidelines, WHO reports, FSSAI reports, UN’s Food and Agricultural Organisation and other important food guidelines to analyze the product. Check if the product contains any substance or ingredients which is considered harmful according to the reports or is banned in any country due to its harmful effects. If true, then mention it but don't include URLs and add in which countries it is banned.

USE MARKDOWN to format the response. It is a necessary requirement. 

The language of the report should be ${_lang} language''';
      } else if (widget.sourcePage == 'ocr') {
        finalPrompt = 
          '''We are making a food scanner app through which the users can enter the name of the product and they can get personalized analysis about it. The personalized information is retrieved through a personalisation page from the user. The user is asked for their age, gender, dietary preference, medical conditions and allergies. Now for the final analysis page, generate a report for the food product using the information given below.

It has the following ingredients: ${widget.prompt}
Using these ingredients, retrieve the product name if you can, if you cannot just retrieve the nutritional values, the material of their packaging, nutriscore, ecoscore,  carbon footprint, health hazards which may be associated with it, etc.

The consumer is pregnant and lactating women who falls in a age group of ${_selectedAgeGroup} and also has the following medical conditions - ${_medicalConditionsController.text} ( ignore if it's written none)
The user is also allergic to ${_allergiesController.text} (ignore if written none)
The user is a ${_selectedDietaryPreference}

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.

After which, in a separate paragraph, list out the pros of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term benefits and short term benefits also if any. At Least 2 general and 1-2 specific for this pregnant woman.

After which in a separate paragraph, list out the cons of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term harms and short terms harms also if any. At Least 2 general and 1-2 specific for this pregnant woman.

In the next paragraph, using all the information of the user given above like age, gender, lactating or not, dietary preference, medical conditions and allergies. Create a report for the user stating whether the consumer should consume the product and will it be fit for consumption for him/her as per their preferences. Write it in a concise manner in which you talk straight to the point and avoid any unnecessary information to be added. Make it as informative as possible in bold and effective words. 

In the next paragraph, use the nutriscore of the product and state it to the user. Describe what is nutriscore and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, talk about the environmental aspect of the product. Firstly, state the material from which the packaging of the product is made from and state if it is environmentally friendly or not. Then by also considering the emissions in the production of the product, give out the carbon footprint which may be caused by the product. Talk about the potential benefits of the packaging material. Use the ecoscore of the product and state it to the user. Describe what ecoscore is and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, suggest any healthier and better alternatives than the entered product. Give reasons for choosing the alternative and how it is better. Give atleast 2 alternatives and mention their brand, product name and any necessary information.

Throughout the response, consider all the EU food guidelines, WHO reports, FSSAI reports, UN’s Food and Agricultural Organisation and other important food guidelines to analyze the product. Check if the product contains any substance or ingredients which is considered harmful according to the reports or is banned in any country due to its harmful effects. If true, then mention it but don't include URLs and add in which countries it is banned.

USE MARKDOWN to format the response. It is a necessary requirement. 

The language of the report should be in ${_lang} language''';
      } else if (widget.sourcePage == 'barcode') {
        finalPrompt = 
          '''We are making a food scanner app through which the users can enter the name of the product and they can get personalized analysis about it. The personalized information is retrieved through a personalisation page from the user. The user is asked for their age, gender, dietary preference, medical conditions and allergies. Now for the final analysis page, generate a report for the food product using the information given below.

The product has the following information: ${widget.prompt}
Use this information and your knowledge to provide your analysis. If some values or information are not provided, retrieve its ingredients,nutritional values, the material of their packaging, nutriscore, ecoscore,  carbon footprint, health hazards which may be associated with it, etc.

The consumer is pregnant and lactating women who falls in a age group of ${_selectedAgeGroup} and also has the following medical conditions - ${_medicalConditionsController.text} ( ignore if it's written none)
The user is also allergic to ${_allergiesController.text} (ignore if written none)
The user is a ${_selectedDietaryPreference}

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc.

After which, in a separate paragraph, list out the pros of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term benefits and short term benefits also if any. At Least 2 general and 1-2 specific for this pregnant woman.

After which in a separate paragraph, list out the cons of the ingredients of the food product and the overall effect of the product on the health of the consumers. Give long term harms and short terms harms also if any. At Least 2 general and 1-2 specific for this pregnant woman.

In the next paragraph, using all the information of the user given above like age, gender, lactating or not, dietary preference, medical conditions and allergies. Create a report for the user stating whether the consumer should consume the product and will it be fit for consumption for him/her as per their preferences. Write it in a concise manner in which you talk straight to the point and avoid any unnecessary information to be added. Make it as informative as possible in bold and effective words. 

In the next paragraph, use the nutriscore of the product and state it to the user. Describe what is nutriscore and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, talk about the environmental aspect of the product. Firstly, state the material from which the packaging of the product is made from and state if it is environmentally friendly or not. Then by also considering the emissions in the production of the product, give out the carbon footprint which may be caused by the product. Talk about the potential benefits of the packaging material. Use the ecoscore of the product and state it to the user. Describe what ecoscore is and what it represents. Also say that “a” score being the best and “e” being the worst. Always tell the score between this scale. Add visuals elements to this paragraph of 5 emojis going from sad to happy representing the scores from “a” score being the happiest emoji and the “e” score being the saddest emoji.

In the next paragraph, suggest any healthier and better alternatives than the entered product. Give reasons for choosing the alternative and how it is better. Give atleast 2 alternatives and mention their brand, product name and any necessary information.

Throughout the response, consider all the EU food guidelines, WHO reports, FSSAI reports, UN’s Food and Agricultural Organisation and other important food guidelines to analyze the product. Check if the product contains any substance or ingredients which is considered harmful according to the reports or is banned in any country due to its harmful effects. If true, then mention it but don't include URLs and add in which countries it is banned.

USE MARKDOWN to format the response. It is a necessary requirement. 

The language of the report should be in (lang) language ${_lang} language''';
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportPage(
                  prompt: finalPrompt,
                )));
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
          'Personalization Panel',
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
              Text(
                'Personalisation Panel',
                style: GoogleFonts.oswald(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'Dear user, In this following page please provide us the specefic details asked in the below fields. it will help us to provide you a personalised and more accurate result',
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
                decoration: InputDecoration(labelText: 'Enter the Allergies'),
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
