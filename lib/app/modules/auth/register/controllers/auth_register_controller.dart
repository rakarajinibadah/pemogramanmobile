import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/controllers/auth_controller.dart';

class AuthRegisterController extends GetxController {
 final authC = Get.find<AuthController>();

  TextEditingController emailController = TextEditingController(

  );
  TextEditingController passwordController = TextEditingController(

  );
  TextEditingController confirmPasswordController = TextEditingController(

  );
  TextEditingController nameController = TextEditingController(

  );

  RxString emailError = RxString('');
  RxString passwordError = RxString('');
  RxString confirmPasswordError = RxString('');
  RxString nameError = RxString('');

  RxBool isLoading = false.obs;
  RxBool isEmailError = false.obs;
  RxBool isPasswordError = false.obs;
  RxBool isConfirmPasswordError = false.obs;
  RxBool isNameError = false.obs;
  RxBool isPasswordMatch = false.obs;

  onSubmit() {
    if (nameController.text.isEmpty) {
      nameError.value = 'Name is required';
      isNameError.value = true;
    } else {
      nameError.value = '';
      isNameError.value = false;
    }
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
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      isConfirmPasswordError.value = true;
    } else {
      isConfirmPasswordError.value = false;
      confirmPasswordError.value = '';
    }

    try {
      isLoading.value = true;
      authC.register(
        emailController.text,
        passwordController.text,
        nameController.text,
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
