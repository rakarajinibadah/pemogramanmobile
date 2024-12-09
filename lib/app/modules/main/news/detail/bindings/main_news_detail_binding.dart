import 'package:get/get.dart';

import '../controllers/main_news_detail_controller.dart';

class MainNewsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNewsDetailController>(
      () => MainNewsDetailController(),
    );
  }
}
