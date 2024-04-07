import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurti_guard/home/PersonaliseForum.dart';
import 'package:nurti_guard/main.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                "Profile",
                style: GoogleFonts.signika(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              Icon(
                CupertinoIcons.person_fill,
                color: Colors.grey,
                size: 160.sp,
              ),
              SizedBox(
                height: 39.5.h,
              ),
              Text(
                "Welcome",
                style: GoogleFonts.signika(
                    fontSize: 18.sp,
                    color: const Color.fromARGB(255, 22, 22, 22),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.h,
              ),
              FirebaseAuth.instance.currentUser!.phoneNumber != null
                  ? Text("${FirebaseAuth.instance.currentUser!.phoneNumber}")
                  : SizedBox(),
              FirebaseAuth.instance.currentUser!.email != null
                  ? Text("${FirebaseAuth.instance.currentUser!.email}")
                  : SizedBox(),
              SizedBox(
                height: 60.h,
              ),
              ZoomTapAnimation(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PersonaliseForm(isEdit: true,),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Row(
                  children: [
                    Container(
                      height: 48.sp,
                      width: 48.sp,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF8EE),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Color(0xFfFF9385),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      "Edit Personalisation form",
                      style: GoogleFonts.signika(
                          color: Color(0xFf707070),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ZoomTapAnimation(
                child: Row(
                  children: [
                    Container(
                      height: 48.sp,
                      width: 48.sp,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF8EE),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Image.asset("assets/paper.png"),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      "Terms & Privacy Policy",
                      style: GoogleFonts.signika(
                          color: Color(0xFf707070),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ZoomTapAnimation(
                onTap: () async {
                  await GetStorage().write('isOnboardingDone', false);
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => const SplashScreen());
                },
                child: Row(
                  children: [
                    Container(
                        height: 48.sp,
                        width: 48.sp,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF8EE),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Color(0xFfFF9385),
                        )),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      "Sign Out",
                      style: GoogleFonts.signika(
                          color: Color(0xFf707070),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
