import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurti_guard/ai_chat/chat_ai.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'about_us.dart';
import 'home_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key});

  @override
  _BottomNavState createState() => _BottomNavState();
}
class BottomNavController extends GetxController{
    PersistentTabController controller =
      PersistentTabController(initialIndex: 0);
}

class _BottomNavState extends State<BottomNav> {

  
  int _currentIndex = 0;


  // final List<Widget> _pages = [HomePage(), AboutUsPage(), ChatPage()];
  List<Widget> _buildScreens() {
    return [HomePage(), AboutUsPage(), ChatPage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/home_icon.png",
          color: Color(0xFF91C788),
        ),
        title: ("Home"),
        activeColorPrimary: Color(0xFF91C788),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.exclamationmark_bubble_fill,
          color: Color(0xFF91C788),
        ),
        title: ("About Us"),
        activeColorPrimary: Color(0xFF91C788),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/chat_icon.png",
          color: Color(0xFF91C788),
        ),
        title: ("Chat with AI"),
        activeColorPrimary: Color(0xFF91C788),
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   // appBar: AppBar(
    //   //   automaticallyImplyLeading: false,
    //   //   // centerTitle: true,
    //   //   systemOverlayStyle: SystemUiOverlayStyle(
    //   //       systemNavigationBarColor: priColor, statusBarColor: priColor),
    //   //   backgroundColor: priColor,
    //   //   title: Text(
    //   //     'Nutri Guard',
    //   //     style: GoogleFonts.lato(),
    //   //   ),
    //   // ),
    //   body: _pages[_currentIndex],
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: _currentIndex,
    //     onTap: (index) {
    //       setState(() {
    //         _currentIndex = index;
    //       });
    //     },
    //     items: const [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: 'Home',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.info),
    //         label: 'About Us',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.chat_bubble),
    //         label: 'AI Chat',
    //       ),
    //     ],
    //   ),
    // );
    return PersistentTabView(
      context,
      controller: Get.put(BottomNavController()).controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors
          .white, // Color.fromARGB(255, 179, 223, 172), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
