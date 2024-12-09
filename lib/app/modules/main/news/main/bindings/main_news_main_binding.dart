import 'package:get/get.dart';

import '../controllers/main_news_main_controller.dart';

class MainNewsMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNewsMainController>(
      () => MainNewsMainController(),
    );
  }
}
