import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/map.dart';
import 'dart:async';
import 'package:flutter_mow/screens/signin/login_screen.dart';
import 'package:flutter_mow/services/signin_service.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigateToLoginScreen() async {
    bool checkAuthResult = await SigninService.checkAuth();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (checkAuthResult) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MapScreen(isNewUser: false),
        ),
        (route) => false, // 모든 이전 화면을 제거
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false, // 모든 이전 화면을 제거
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // navigateToLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/login_cat.svg'),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
