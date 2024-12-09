import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';

import '../controllers/onboarding_welcome_controller.dart';

class OnboardingWelcomeView extends GetView<OnboardingWelcomeController> {
  const OnboardingWelcomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingWelcomeController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/welcome.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Get ready for',
                  style: AppTheme.bodyText.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'New Adventures',
                  style: AppTheme.heading1.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'If you like to travel, then this is for you! Here you can explore the beauty of the world.',
                  textAlign: TextAlign.center,
                  style: AppTheme.caption.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/onboarding');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xff09453E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Let’s Tour',
                    style: AppTheme.buttonText.copyWith(
                      color: Color(0xff09453E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
