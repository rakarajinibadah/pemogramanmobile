import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mountain/app/controllers/auth_controller.dart';

class HomeController extends GetxController {
  RxString name = ''.obs;
  RxBool isLoading = true.obs;
  // inisiasi GetStorage
  GetStorage box = GetStorage();
  getUser() {
    if (AuthController.user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.userEmail)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          name.value = documentSnapshot.get('name');
          box.write('name', documentSnapshot.get('name'));
          box.write('email', documentSnapshot.get('email'));
          box.write('id', documentSnapshot.get('id'));
        } else {
          Get.snackbar(
            'Error',
            'Document does not exist on the database',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }).then((value) {
        isLoading.value = false;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/onboarding');
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUser();
  }
}
