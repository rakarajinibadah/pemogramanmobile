import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/modules/main/gallery/list/views/list_view.dart';

import 'package:mountain/app/modules/main/home/views/home_view.dart';
import 'package:mountain/app/modules/main/news/main/views/main_news_main_view.dart';

class MainLayoutController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List<Map<String, dynamic>> menus = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'page': HomeView(),
    },
    {
      'title': 'My Gallery',
      'icon': Icons.image,
      'page': ListGalleriesView(),
    },
    {
      'title': 'News',
      'icon': Icons.newspaper,
      'page': MainNewsMainView(),
    },
  ];

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
