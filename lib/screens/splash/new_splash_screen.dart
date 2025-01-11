import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/map.dart';
import 'package:flutter_mow/screens/signin/login_screen.dart';
import 'package:flutter_mow/services/signin_service.dart';
import 'package:flutter_svg/svg.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({
    super.key,
  });

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen> {
  void checkUser() async {
    final result = await SigninService.checkAuth();
    // 1.5초간 대기
    await Future.delayed(const Duration(milliseconds: 1500));
    if (result == true) {
      final detailNullResult = await SigninService.checkDetails();
      // 1. 자동 로그인 실패
      if (detailNullResult) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // 모든 이전 화면을 제거
        );
      }
      // 2. 자동 로그인 성공
      else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const MapScreen(isNewUser: false)),
          (route) => false, // 모든 이전 화면을 제거
        );
      }
    } else if (result == false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // 모든 이전 화면을 제거
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/login_cat.svg'),
            const SizedBox(height: 150.0),
          ],
        ),
      ),
    );
  }
}
