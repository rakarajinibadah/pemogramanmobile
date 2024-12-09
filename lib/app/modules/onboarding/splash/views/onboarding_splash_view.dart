import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_splash_controller.dart';

class OnboardingSplashView extends GetView<OnboardingSplashController> {
  const OnboardingSplashView({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 2000), () {
      Get.offNamed('/welcome');
    });
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
