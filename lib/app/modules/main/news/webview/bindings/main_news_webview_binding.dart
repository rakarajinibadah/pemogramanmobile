import 'package:get/get.dart';

import '../controllers/main_news_webview_controller.dart';

class MainNewsWebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNewsWebviewController>(
      () => MainNewsWebviewController(),
    );
  }
}
