import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:nurti_guard/const.dart';
import 'package:nurti_guard/firebase_options.dart';
import 'package:nurti_guard/home/PersonaliseForum.dart';
import 'package:nurti_guard/home/home_page.dart';
import 'package:nurti_guard/onboarding/onboarding_view.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:social_auth_buttons/res/buttons/google_auth_button.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'home/bottom_nav.dart';

var gK = 'AIzaSyC_GIqQJSIBxZu-lblDJa0aLBiX-l6Rogw';
Future<void> main() async {
  await GetStorage.init();
  try {
    WidgetsFlutterBinding.ensureInitialized();

    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'Nutri Guard',
    );
    MobileAds.instance.initialize();
    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.ENGLISH
    ];
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Error: $e');
  }
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

List<String> scopes = <String>[
  'email',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) {
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: priColor),
                    useMaterial3: true,
                    textTheme: GoogleFonts.oswaldTextTheme()),
                //TODO
                home: GetStorage().read('isOnboardingDone') != null &&
                        GetStorage().read('isOnboardingDone')
                    ? OnboardingView()
                    : const SplashScreen(),
                // home: OnboardingView(),
                // home: BottomNav(),
              ),
            );
          });
    });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    final storage = GetStorage();
    if (storage.read('isFormFilled') != null &&
        storage.read('isFormFilled') == true) {
    } else {
      storage.write('allergies', '');
      storage.write('medicalConditions', '');
      storage.write('selectedAgeGroup', '');
      storage.write('language', '');
      storage.write('dietaryPreference', '');
      storage.write('gender', '');
      storage.write('isPregnantOrLactating', false);
    }
  }

  Future<void> _handleSignIn() async {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.signInWithProvider(GoogleAuthProvider());
      if (user.user?.emailVerified == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PersonaliseForm(
                      isEdit: false,
                    )));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Email not verified'),
                content: Text('Please verify your email to continue'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              );
            });
        print('email not verified');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Color(0xFF39e75f),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 83.h),
            Center(
              child: Text(
                'Welcome To',
                style:
                    GoogleFonts.signika(fontSize: 24.sp, color: Colors.black),
              ),
            ),
            // SizedBox(
            //   height: 10.h,
            // ),
            // SizedBox(
            //   width: 136.h,
            //   child: Text(
            //     "Nutri Guard",
            //     textAlign: TextAlign.center,
            //     style: GoogleFonts.signika(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 35.sp,
            //       color: Color(0xFF89BA81),
            //     ),
            //   ),
            // ),
            Image.asset(
              "assets/app_logo.png",
              width: 136.w,
              height: 170.h,
            ),
            // SizedBox(
            //   height: 22.h,
            // ),
            ClipRRect(
                borderRadius: BorderRadius.circular(14.w),
                child: Image.asset("assets/signup_image.png")),
            SizedBox(
              height: 45.h,
            ),
            Center(
              child: Text(
                'Sign in to continue',
                style: GoogleFonts.signika(
                    fontSize: 17.sp,
                    // color: Color(0xFF7c7c7c),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 43.h),
            ZoomTapAnimation(
              onTap: () {
                _handleSignIn();
                // Get.to(OnboardingView());
              }, //_handleSignIn,
              child: SignInButton(
                imgLoc: "assets/google_icon.png",
                title: "Google",
              ),
            ),

            SizedBox(height: 22.h),
            ZoomTapAnimation(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhoneSignUpScreen()));
                  // Get.to(OnboardingView());
                },
                child: SignInButton(
                    imgLoc: "assets/phone_icon.png", title: "Phone")),
            // Phone sign up button

            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: priColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100.0),
                  topLeft: Radius.circular(100.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.imgLoc,
    required this.title,
  });
  final String imgLoc;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.w),
        color: Color(0xFF91C788),
      ),
      height: 63.h,
      width: 290.w,
      child: Row(
        children: [
          SizedBox(
            width: 85.w,
          ),
          Image.asset(
            imgLoc,
            color: title == "Phone" ? Color.fromARGB(255, 11, 123, 214) : null,
          ),
          SizedBox(
            width: 11.w,
          ),
          Text(
            title,
            style: GoogleFonts.signika(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          )
        ],
      ),
    );
  }
}

// Phone Sign Up Screen
class PhoneSignUpScreen extends StatefulWidget {
  PhoneSignUpScreen({Key? key}) : super(key: key);

  @override
  State<PhoneSignUpScreen> createState() => _PhoneSignUpScreenState();
}

class _PhoneSignUpScreenState extends State<PhoneSignUpScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  String smsCode = '';
  late PhoneAuthCredential _credential;
  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF39e75f),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Sign Up with Phone Number',
            style: GoogleFonts.signika(
                fontSize: 17.sp,
                color: Color(0xFF7c7c7c),
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                  print(number.dialCode);
                  countryCodeController.text = number.dialCode!;
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useBottomSheetSafeArea: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: controller,
                formatInput: true,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
              ),
            ),
            SizedBox(height: 30.h),
            ZoomTapAnimation(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Sending verification code...'),
                      );
                    });
                FirebaseAuth auth = FirebaseAuth.instance;
                print('Phone number: ' + controller.text);
                await auth.verifyPhoneNumber(
                  phoneNumber: countryCodeController.text + controller.text,
                  verificationCompleted:
                      (PhoneAuthCredential credential) async {
                    // Navigator.pop(context);
                    // // ANDROID ONLY!
                    //
                    // // Sign the user in (or link) with the auto-generated credential
                    // await auth.signInWithCredential(credential);
                  },
                  timeout: Duration(seconds: 120),
                  verificationFailed: (FirebaseAuthException e) {
                    Navigator.pop(context);
                    if (e.code == 'invalid-phone-number') {
                      print('The provided phone number is not valid.');
                    }
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(e.message!),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });

                    // Handle other errors
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    Navigator.pop(context);
                    print('Code sent' + verificationId);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                              title: Text("Enter SMS Code"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: _codeController,
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Confirm"),
                                  // textColor: Colors.white,
                                  // color: Colors.redAccent,
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    FirebaseAuth auth = FirebaseAuth.instance;

                                    smsCode = _codeController.text.trim();

                                    _credential = PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: smsCode);
                                    auth
                                        .signInWithCredential(_credential)
                                        .then((UserCredential result) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PersonaliseForm(
                                                    isEdit: false,
                                                  )));
                                    }).catchError((e) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(e.toString()),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('OK'))
                                              ],
                                            );
                                          });
                                      print(e);
                                    });
                                  },
                                )
                              ],
                            ));
                    // Update the UI - wait for the user to enter the SMS code
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    // Auto-resolution timed out...
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.w),
                  color: Color(0xFF91C788),
                ),
                height: 63.h,
                width: 290.w,
                child: Center(
                  child: Text("Verify Phone Number",
                      style: GoogleFonts.signika(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Phone Verification Screen
class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone Number'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your phone number',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform phone number verification logic
                // You can use Firebase's phone verification here
              },
              child: Text('Send Verification Code'),
            ),
          ],
        ),
      ),
    );
  }
}
