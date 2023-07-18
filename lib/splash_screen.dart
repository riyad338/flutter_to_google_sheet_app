import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:excel_sheet_connect/from.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnimatedSplashScreen(
          splash: Column(
            children: [
              Lottie.asset('images/splashpic.json'),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
          backgroundColor: Colors.white,
          nextScreen: HomePage(),
          splashIconSize: 450,
          duration: 1000,
          splashTransition: SplashTransition.sizeTransition,
          animationDuration: Duration(milliseconds: 100),
        ),
      ),
    );
  }
}
