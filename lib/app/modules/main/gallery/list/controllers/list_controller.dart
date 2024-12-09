import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListController extends GetxController {
  GetStorage box = GetStorage();
  RxString userId = ''.obs;

  

  @override
  void onInit() {
    super.onInit();
    userId.value = box.read('id') ?? '';
  }
}
