import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/map.dart';
import 'package:flutter_mow/screens/signin/login_screen.dart';
import 'package:flutter_mow/screens/splash/splash_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mow/secrets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: Secrets.naverClientId,
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF_Pro',
            height: 1.2,
          ),
          headlineMedium: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF_Pro',
            height: 1.2,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'SF_Pro',
            height: 1.2,
          ),
          titleSmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'SF_Pro',
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
