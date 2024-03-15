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
                'assets/pic1.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: tipTitle.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          tipTitle[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          sub[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: golColor),
                        )
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 5,
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
            SizedBox(
              height: 5,
            ),

            ///Manual Searching
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Search manually by product name',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
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
