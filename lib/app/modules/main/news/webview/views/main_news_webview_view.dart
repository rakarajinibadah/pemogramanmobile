import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/main_news_webview_controller.dart';

class MainNewsWebviewView extends GetView<MainNewsWebviewController> {
  const MainNewsWebviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(
          'Web View',
          style: AppTheme.heading1.copyWith(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: controller.controllerWebView,
      ),
    );
  }
}
