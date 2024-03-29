import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
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
  final List<Color> boxColors = [
    Color(0xFFEFF7EE),
    Color(0xFFFFF8EB),
    Color(0xFFB5B1E7)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: priColor, statusBarColor: priColor),
        // backgroundColor: priColor,
        title: Text('About Us',
            style: GoogleFonts.signika(
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: Colors.black,
            )),
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
                margin: EdgeInsets.only(bottom: 36.h, left: 12.w, right: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.w,
                  ),
                  color: boxColors[index],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 6.w, right: 6.w, top: 12.w, bottom: 12.w),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 100.h,
                              width: 100.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.w),
                                child: Image.asset(
                                  images[index],
                                  height: 100.h,
                                  width: 100.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              names[index],
                              style: GoogleFonts.signika(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 15.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              width: 118.w,
                              child: Text(
                                shortDescriptions[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.signika(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFA38A8A),
                                    fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: 201.w,
                            child: Text(
                              detailedDescriptions[index],
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.signika(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF4D4B4B),
                                  fontSize: 15.sp),
                            ))
                      ]),
                ),
              );
              // return Container(
              //   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //   width: MediaQuery.of(context).size.width,
              //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              //   decoration: BoxDecoration(
              //       color: Colors.white70,
              //       borderRadius: BorderRadius.circular(20),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.grey.withOpacity(0.3),
              //             blurRadius: 20,
              //             spreadRadius: 3)
              //       ]),
              //   child: Column(
              //     children: [
              //       Container(
              //         width: MediaQuery.of(context).size.width * 0.4,
              //         height: MediaQuery.of(context).size.width * 0.4,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: priColor, width: 2),
              //             borderRadius: BorderRadius.circular(100)),
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(100),
              //           child: Image.asset(
              //             images[index],
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //       Text(
              //         names[index],
              //         style: TextStyle(fontSize: 19),
              //       ),
              //       Text(
              //         shortDescriptions[index],
              //         style:
              //             TextStyle(fontSize: 17, color: Colors.grey.shade600),
              //       ),
              //       Text(detailedDescriptions[index])
              //     ],
              //   ),
              // );
            }),
      ),
    );
  }
}
