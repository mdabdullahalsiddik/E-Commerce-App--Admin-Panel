import 'package:e_shop_admin/Pages/bottom_navigator_bar_page.dart';
import 'package:e_shop_admin/Pages/welcome_page.dart';
import 'package:e_shop_admin/Static/all_colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future splash() async {
    Future.delayed(const Duration(seconds: 5)).then(
      (value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => FirebaseAuth.instance.currentUser != null
                  ? const BottomNavigatorBarPage()
                  : const WelcomePage(),
            ),
            (route) => false);
      },
    );
  }

  @override
  void initState() {
    splash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AllColors.primaryColor,
      body: Center(
        child: Icon(
          Icons.shopping_cart,
          size: 100,
          color: AllColors.yellowColor,
        ),
      ),
    );
  }
}
