import 'package:flutter/material.dart';
import 'package:nurti_guard/ai_chat/chat_ai.dart';

import 'about_us.dart';
import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomePage(), AboutUsPage(), ChatPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // centerTitle: true,
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //       systemNavigationBarColor: priColor, statusBarColor: priColor),
      //   backgroundColor: priColor,
      //   title: Text(
      //     'Nutri Guard',
      //     style: GoogleFonts.lato(),
      //   ),
      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'AI Chat',
          ),
        ],
      ),
    );
  }
}
