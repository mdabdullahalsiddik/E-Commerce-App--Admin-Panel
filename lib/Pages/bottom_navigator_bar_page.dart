import 'package:e_shop_admin/Static/all_colors.dart';

import 'package:flutter/material.dart';

import 'home_pages.dart';

class BottomNavigatorBarPage extends StatefulWidget {
  const BottomNavigatorBarPage({super.key});

  @override
  State<BottomNavigatorBarPage> createState() => _BottomNavigatorBarPageState();
}

class _BottomNavigatorBarPageState extends State<BottomNavigatorBarPage> {
  

  int selectIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const HomePage(),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectIndex,
        onTap: (index) {
          setState(
            () {
              selectIndex = index;
            },
          );
        },
        selectedIconTheme: const IconThemeData(
          color: AllColors.primaryColor,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.5),
        ),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: "",
          ),
        ],
      ),
    );
  }
}
