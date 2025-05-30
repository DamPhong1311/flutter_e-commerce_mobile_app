import 'dart:async';

import 'package:ecommerece_flutter_app/pages/intro/onboarding/onboarding_page.dart';
import 'package:ecommerece_flutter_app/pages/intro/signin_signup/signin_page.dart';
import 'package:flutter/material.dart';

import '../../common/constants/colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      // Chuyển sang màn hình chính sau 3 giây
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), 
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.primaryColor,
      body: Align(
        child: Image.asset('assets/logos/logo_2x.png'),
      ),
    );
  }
}