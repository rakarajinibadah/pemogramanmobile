import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/controllers/auth_controller.dart';

class AuthLoginController extends GetxController {
  final AuthController authController = Get.find();
  TextEditingController emailController = TextEditingController(

  );
  TextEditingController passwordController = TextEditingController(

  );

  RxString emailError = RxString('');
  RxString passwordError = RxString('');

  RxBool isLoading = true.obs;
  RxBool isEmailError = false.obs;
  RxBool isPasswordError = false.obs;

  onSubmit() {
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      isEmailError.value = true;
    } else {
      emailError.value = '';
      isEmailError.value = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isPasswordError.value = true;
    } else {
      isPasswordError.value = false;
      passwordError.value = '';
    }
    if (emailError.value.isEmpty && passwordError.value.isEmpty) {
      authController.login(emailController.text, passwordController.text);
    }
  }
}
