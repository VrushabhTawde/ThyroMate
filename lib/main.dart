// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thyroidclass/screen/Navigation%20Bar/bottom_nav/bottom_nav.dart';
import 'package:thyroidclass/screen/Onboarding%20Page/OnBoarding Content.dart';
import 'package:thyroidclass/screen/Onboarding%20Page/OnBoarding%20Screen.dart';
import 'package:thyroidclass/screen/Welcome/WelcomeScreen.dart';

int initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // initScreen = await prefs.getInt("initScreen");
  // await prefs.setInt("initScreen", 1);
  // print('initScreen ${initScreen}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thyro Care',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
      // routes: {
      //   '/': (context) => WelcomeScreen(),
      //   "first": (context) => OnboardingScreen(),
      // },
      home: WelcomeScreen(),
    );
  }
}
