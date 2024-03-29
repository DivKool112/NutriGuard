import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurti_guard/home/bottom_nav.dart';
import 'package:nurti_guard/home/home_page.dart';

class OnboardingView extends StatefulWidget {
  OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
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

  Future<bool> showFacts() async {
    for (int i = 0; i < 3; i++) {
      factIndex.value = Random().nextInt(7);

      await Future.delayed(Duration(seconds: 2));
    }
    return true;
  }

  RxInt factIndex = Random().nextInt(7).obs;
  // RxInt factIndex = 5.obs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: showFacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 42.w),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 97.h,
                      ),
                      Image.asset("assets/onboarding_image.png"),
                      SizedBox(
                        height: 14.h,
                      ),
                      SizedBox(
                        height: 300.h,
                        child: Column(
                          children: [
                            Text(
                              tipTitle[factIndex.value],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.signika(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 25.sp),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              sub[factIndex.value],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.signika(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF8C8C8C)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SpinKitDoubleBounce(
                        color: Color(0xFFFF8473),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return BottomNav();
          }
        });
  }
}
