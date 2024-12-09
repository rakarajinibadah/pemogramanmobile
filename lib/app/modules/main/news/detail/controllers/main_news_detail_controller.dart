import 'package:get/get.dart';
import 'package:mountain/app/models/news_model.dart';

class MainNewsDetailController extends GetxController {
   var news = Rxn<News>();

  @override
  void onInit() {
    news.value = Get.arguments as News;
    super.onInit();
  }
}
