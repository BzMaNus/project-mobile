import 'package:book/extension.dart';
import 'package:book/pages/mybook.dart';
import 'package:book/pages/home.dart';
import 'package:book/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainMenu extends StatefulWidget {
  static const routeName = '/';
  const MainMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  dynamic selected;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
        ),
        backgroundColor: Colors.white,
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.home_filled,
            ),
            selectedIcon: const Icon(Icons.home_filled),
            selectedColor: '#E72913'.toColor(),
            unSelectedColor: Colors.black12,
            title: Text('Home', style: GoogleFonts.kanit()),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.menu_book_rounded,
              ),
              selectedIcon: const Icon(
                Icons.menu_book_rounded,
              ),
              unSelectedColor: Colors.black12,
              selectedColor: '#E72913'.toColor(),
              title: Text(
                'My Books',
                style: GoogleFonts.kanit(),
              )),
          BottomBarItem(
              icon: const Icon(
                Icons.person,
              ),
              selectedIcon: const Icon(
                Icons.person,
              ),
              selectedColor: '#E72913'.toColor(),
              unSelectedColor: Colors.black12,
              title: Text('Profile', style: GoogleFonts.kanit())),
        ],
        hasNotch: true,
        currentIndex: selected ?? 0,
        onTap: (index) {
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: const [
            Home(),
            Cart(),
            Profile(),
          ],
        ),
      ),
    );
  }
}
