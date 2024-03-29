import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ai_analysis/ai_report.dart';

class InterstitialAdPage extends StatefulWidget {
  final String finalPrompt;

  const InterstitialAdPage({super.key, required this.finalPrompt});
  @override
  _InterstitialAdPageState createState() => _InterstitialAdPageState();
}

class _InterstitialAdPageState extends State<InterstitialAdPage> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    _createInterstitialAd();
    super.initState();
  }

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
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ReportPage(prompt: widget.finalPrompt)),
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
      adUnitId: "ca-app-pub-6437987663717750/2079993497",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            isLoaded = true;
          });

          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _showInterstitialAd();
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
                  builder: (context) => ReportPage(prompt: widget.finalPrompt)),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      !isLoaded
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Launching ads...'),
                  SizedBox(height: 20),
                  // CircularProgressIndicator(),
                  SpinKitCircle(color: Color(0xFF91C788),)
                ],
              ),
            )
          : Container(),
    ]));
  }
}
