import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainNewsWebviewController extends GetxController {
  RxString url = ''.obs;
  late final WebViewController controllerWebView;

  @override
  void onInit() {
    url.value = Get.arguments as String;
    controllerWebView = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url.value));
    super.onInit();
  }
}
