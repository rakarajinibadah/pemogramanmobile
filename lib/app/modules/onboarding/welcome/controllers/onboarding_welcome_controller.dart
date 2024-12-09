import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mountain/app/controllers/auth_controller.dart';
import 'package:flutter/widgets.dart';

class OnboardingWelcomeController extends GetxController {
  var userEmail = AuthController.userEmail;
  User? user = AuthController.user;

  getUser() {
    if (user != null || userEmail != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/layout');
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUser();
  }
}
