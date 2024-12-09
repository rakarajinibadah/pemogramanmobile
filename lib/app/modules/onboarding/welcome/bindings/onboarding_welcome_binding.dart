import 'package:get/get.dart';

import '../controllers/onboarding_welcome_controller.dart';

class OnboardingWelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingWelcomeController>(
      () => OnboardingWelcomeController(),
    );
  }
}
