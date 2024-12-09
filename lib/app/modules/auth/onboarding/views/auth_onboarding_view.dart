import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';

import '../controllers/auth_onboarding_controller.dart';

class AuthOnboardingView extends GetView<AuthOnboardingController> {
  const AuthOnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 140,
            ),
            child: Column(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Wanna see the world?',
                        style: AppTheme.heading1.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Let\'s get started!',
                        style: AppTheme.heading3.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 470,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Transform.translate(
                    offset:
                        Offset(-0, 0),
                    child: Container(
                      height: 470,
                      width: Get.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/onboarding.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Color(0xff09453E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: AppTheme.bodyText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), 

                SizedBox(
                  width: double.infinity, 
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: Color(0xff09453E), width: 2), 
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), 
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: AppTheme.bodyText.copyWith(
                        color: Color(
                            0xff09453E), 
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
