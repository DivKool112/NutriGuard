import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:nurti_guard/const.dart';
import 'package:nurti_guard/firebase_options.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:social_auth_buttons/res/buttons/google_auth_button.dart';

import 'home/bottomNav.dart';

var gK = 'AIzaSyC_GIqQJSIBxZu-lblDJa0aLBiX-l6Rogw';
Future<void> main() async {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: priColor),
          useMaterial3: true,
          textTheme: GoogleFonts.oswaldTextTheme()),
      home: const SplashScreen(),
    );
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
  }

  Future<void> _handleSignIn() async {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.signInWithProvider(GoogleAuthProvider());
      if (user.user?.emailVerified == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
      backgroundColor: priColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Center(
                child: Text(
                  'WELCOME TO',
                  style: GoogleFonts.aBeeZee(
                      fontSize: 23, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Image.asset(
                'assets/logo.jpeg',
                scale: 1,
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Image.asset(
                'assets/diet.png',
                height: MediaQuery.of(context).size.height * 0.35,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.03,
              // ),
              Center(
                child: Text(
                  'Sign in to continue',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              GoogleAuthButton(
                width: MediaQuery.of(context).size.width * 0.6,
                onPressed: _handleSignIn,
                darkMode: false,
              ),
              SizedBox(height: 20),
              // Phone sign up button
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneSignUpScreen()));
                  },
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    margin: EdgeInsets.symmetric(horizontal: 72),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 10),
                        Container(
                          child: Text(
                            'Sign in with phone number',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: priColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100.0),
                      topLeft: Radius.circular(100.0),
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
      appBar: AppBar(
        title: Text('Sign Up with Phone Number'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
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
                                                  HomeScreen()));
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
                // Navigate to phone verification screen
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PhoneVerificationScreen()));
              },
              child: Text('Verify Phone Number'),
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
