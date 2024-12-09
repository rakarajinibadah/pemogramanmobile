import 'package:get/get.dart';
import 'package:mountain/app/models/news_model.dart';
import 'package:mountain/app/services/news_services.dart';

class MainNewsMainController extends GetxController {
 var newsList = <News>[].obs;
  var isLoading = true.obs;

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      final response = await NewsApiService().fetchNews();
      var validNews = response.where((news) {
        return news.title != null &&
            news.title != '[Removed]' &&
            news.url != null &&
            news.url!.isNotEmpty;
      }).toList();

      newsList.assignAll(validNews);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchNews();
    super.onInit();
  }
}
