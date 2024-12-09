import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:mountain/app/controllers/auth_controller.dart';
import 'package:mountain/app/widgets/custom_button.dart';
import 'package:mountain/app/widgets/custom_input.dart';

import '../controllers/auth_register_controller.dart';

class AuthRegisterView extends GetView<AuthRegisterController> {
  const AuthRegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Register',
                      style: AppTheme.heading2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Obx(
                      () => CustomInput(
                        labelText: 'Name',
                        controller: controller.nameController,
                        isError: controller.isNameError.value,
                        errorMessage: controller.nameError.value,
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => CustomInput(
                        labelText: 'Email',
                        controller: controller.emailController,
                        isError: controller.isEmailError.value,
                        errorMessage: controller.emailError.value,
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => CustomInput(
                        labelText: 'Password',
                        controller: controller.passwordController,
                        isPassword: true,
                        isError: controller.isPasswordError.value,
                        errorMessage: controller.passwordError.value,
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => CustomInput(
                        labelText: 'Password Confirmation',
                        controller: controller.confirmPasswordController,
                        isPassword: true,
                        isError: controller.isConfirmPasswordError.value,
                        errorMessage: controller.confirmPasswordError.value,
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(() {
                      return CustomButton(
                        text: authC.isLoading.value
                            ? "Loading..."
                            : "Register",
                        onPressed: () {
                          if (authC.isLoading.value) {
                            return;
                          }
                          controller.onSubmit();
                        },
                      );
                    }),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Already have an account?'),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/login');
                          },
                          child: Text(
                            ' Login',
                            style: AppTheme.heading3.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
