import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // TODO: implement initState
    super.initState();

// #enddocregion CanAccessScopes
  }

  Future<void> _handleSignIn() async {
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
                  // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Image.asset(
                'assets/logo.jpeg',
                scale: 1,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Image.asset(
                'assets/diet.png',
                height: MediaQuery.of(context).size.height * 0.4,
                // color: priColor,
                scale: 1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Center(
                child: Text(
                  'Sign in to continue',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  // style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
              ),
              SizedBox(height: 10),
              GoogleAuthButton(
                width: MediaQuery.of(context).size.width * 0.6,
                onPressed: _handleSignIn,
                darkMode: false,
              ),

              // AppleAuthButton(
              //     width: MediaQuery.of(context).size.width * 0.6,
              //     darkMode: true,
              //     onPressed: _signInWithApple),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  // height: MediaQuery.of(context).size.height*0.2,
                  decoration: BoxDecoration(
                    color: priColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100.0),
                      topLeft:
                          Radius.circular(100.0), // Adjust the radius as needed
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

  Future<void> _signInWithGoogle() async {
    // Implement Google Sign-In logic here using the google_sign_in package
    // Example:Ra
  }

  Future<void> _signInWithApple() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = await firebaseAuth.signInWithProvider(AppleAuthProvider());
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
    // Implement Apple Sign-In logic here using the sign_in_with_apple package
    // Example:
    // AuthorizationCredentialAppleID? appleCredential = await SignInWithApple.getAppleIDCredential(scopes: []);
  }
}
