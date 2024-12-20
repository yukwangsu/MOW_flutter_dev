import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/map.dart';
import 'package:flutter_mow/screens/signin/login_screen.dart';
import 'package:flutter_mow/screens/splash/new_splash_screen.dart';
import 'package:flutter_mow/screens/splash/splash_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const NewSplashScreen(),
      theme: ThemeData(
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF_Pro',
            height: 37 / 28,
          ),
          titleLarge: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF_Pro',
            height: 1.2,
          ),
          titleMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF_Pro',
            height: 25 / 20,
          ),
          labelLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'SF_Pro',
            height: 25 / 20,
          ),
          labelMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'SF_Pro',
            height: 21 / 18,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF_Pro',
            height: 21 / 16,
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
            height: 20 / 14,
          ),
          labelSmall: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF_Pro',
            height: 16 / 12,
          ),
          bodySmall: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'SF_Pro',
            height: 16 / 12,
          ),
        ),
      ),
    );
  }
}
