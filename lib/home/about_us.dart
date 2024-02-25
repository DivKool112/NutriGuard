import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurti_guard/const.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key? key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final List<String> names = [
    'Shrey Bajiya',
    'Divyansh Koolwal',
    'Vivaan Daga',
  ];

  // Short descriptions of team members
  final List<String> shortDescriptions = [
    'Founder & Backend Expert',
    'Founder & Design Enthusiast',
    'CEO & Marketing Strategist',
  ];

  final List<String> images = [
    'assets/1.jpeg',
    'assets/3.jpeg',
    'assets/4.jpeg',
  ];

  // Detailed descriptions of team members
  final List<String> detailedDescriptions = [
    'Shrey Bajiya, our founder, spearheads the technical aspects of our food scanner app. With expertise in backend coding and an entrepreneurial mindset, he ensures seamless functionality, unparalleled user experience, and marketing tie-ups.',
    'Divyansh Koolwal, our founder, a computer science enthusiast, envisioned our food scanner app. Passionate about crafting and designing applications, he delves into the intricacies of their functionality with unwavering curiosity and dedication.',
    'Vivaan Daga, our adept CEO, orchestrates strategic crowdfunding initiatives and spearheads marketing endeavors. His dedication extends to raising awareness about our app and addressing critical food safety concerns.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: priColor, statusBarColor: priColor),
        backgroundColor: priColor,
        title: Text(
          'About Us',
          style: GoogleFonts.lato(),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 5),
            itemCount: names.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 3)
                    ]),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          border: Border.all(color: priColor, width: 2),
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      names[index],
                      style: TextStyle(fontSize: 19),
                    ),
                    Text(
                      shortDescriptions[index],
                      style:
                          TextStyle(fontSize: 17, color: Colors.grey.shade600),
                    ),
                    Text(detailedDescriptions[index])
                  ],
                ),
              );
            }),
      ),
    );
  }
}
