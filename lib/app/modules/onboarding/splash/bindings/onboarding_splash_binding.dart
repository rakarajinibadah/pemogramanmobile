import 'package:get/get.dart';

import '../controllers/onboarding_splash_controller.dart';

class OnboardingSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingSplashController>(
      () => OnboardingSplashController(),
    );
  }
}
