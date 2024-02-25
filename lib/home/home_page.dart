import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurti_guard/home/PersonaliseForum.dart';
import 'package:nurti_guard/home/scanning_page.dart';

import '../api/api_barcode.dart';
import '../const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  List<String> tipTitle = [
    'Did You Know?',
    'Did You Know?',
    'Did You Know?',
    'Tip 3: Calcium',
    'Why Is Proper Maternal Care',
    'Tip 4: Hydration',
    'Tip 5: Omega-3s'
  ];
  List<String> sub = [
    'Iron-deficiency anaemia is a condition which arises due to insufficient iron for hemoglobin production, critical for oxygen transport in red blood cells. During pregnancy, this deficiency elevates the risk of preterm birth and low birth weight. Globally, around 40% of pregnant women are affected, with higher rates in areas lacking access to iron-rich foods or supplements.',
    'Neural tube defects (NTDs) are birth anomalies where the brain, spinal cord, and associated structures fail to close properly during fetal development. These conditions impact roughly 1 in 1,000 pregnancies worldwide, with increased occurrences in areas lacking adequate folic acid fortification in food.',
    'Birth weight, a consequential matter, is influenced by a series of conditions characterized by deficiencies in essential nutrients such as protein, iron, and folic acid. These deficiencies impede fetal growth and development, leading to low birth weight and, in severe instances, mortality. It is estimated that approximately 15% of all births are affected by low birth weight, with elevated prevalence observed in low- and middle-income countries where maternal malnutrition prevails.',
    'Calcium is essential for building your baby\'s bones and teeth. Get your daily dose from dairy products, tofu, and leafy greens.',
    'Iron supports the baby\'s growth and helps prevent anemia in mothers. Find it in lean meats, beans, and fortified cereals.',
    'Staying well-hydrated is key for healthy pregnancy. Aim for 8-10 cups of water per day, and limit caffeine.',
    'Omega-3 fatty acids promote your baby\'s brain and eye development. Find them in fish, flaxseeds, and walnuts.'
  ];
  searchManually() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Searching...'),
            content: SizedBox(
                height: 100, child: Center(child: CircularProgressIndicator())),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
    // prompt = await getProductDetailsByName(barController.text);
    prompt = (barController.text);

    Navigator.pop(context);
    try {
      if (prompt!.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PersonaliseForm(
                      prompt: prompt,
                      sourcePage: 'manual',
                    )));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScanningPage()));
      }
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Product not found. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            );
          });
    }
    print('hi');
  }

  String? prompt;
  TextEditingController barController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var hi = MediaQuery.of(context).size.height;
    var wi = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: priColor,
        // title: Text(
        //   'Nutri Guide',
        //   // style: TextStyle(color: Colors.white),
        // ),
        automaticallyImplyLeading: false,
        title: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          child: Image.asset(
            'assets/logo.jpeg',
            fit: BoxFit.fill,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   child: Image.asset('assets/logo.png'),
            // ),
            Container(
              height: hi * 0.4,
              width: wi,
              child: Image.asset(
                'assets/pic.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            for (int i = 0; i < sub.length; i++)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      tipTitle[i],
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      sub[i],
                      style: TextStyle(fontSize: 15, color: golColor),
                    )
                  ],
                ),
              ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScanningPage()));
              },
              child: Center(
                child: Container(
                  width: wi * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: darkGreen,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(1, 2))
                      ]),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.document_scanner_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Scan Ingredients',
                        style: GoogleFonts.epilogue(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Searching...'),
                        content: SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator())),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          )
                        ],
                      );
                    });
                if (barcodeScanRes != null) {
                  prompt = await getProductDetails(barcodeScanRes);
                  Navigator.pop(context);
                  // print(prompt);
                  try {
                    if (prompt!.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonaliseForm(
                                    prompt: prompt,
                                    sourcePage: 'barcode',
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScanningPage()));
                    }
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content:
                                Text('Product not found. Please try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              )
                            ],
                          );
                        });
                  }
                }
              },
              child: Center(
                child: Container(
                  width: wi * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: darkGreen),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.document_scanner,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Scan Barcode',
                        style: GoogleFonts.epilogue(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ///Manual Searching
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('Search manually by product name'),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: golColor.withOpacity(0.2)),
              width: wi,
              height: hi * 0.07,
              child: TextField(
                controller: barController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ' product name',
                  hintStyle: TextStyle(color: golColor),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  suffix: InkWell(
                    onTap: searchManually,
                    child: Icon(
                      Icons.search,
                      color: golColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
