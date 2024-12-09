import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mountain/app/modules/main/gallery/show/controllers/show_controller.dart';
import 'package:mountain/app/modules/main/layout/controllers/main_layout_controller.dart';
import 'package:mountain/app/services/cloudinary_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:video_player/video_player.dart';

class EditController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  GetStorage box = GetStorage();
  TextEditingController idController = TextEditingController();
  TextEditingController titleController = TextEditingController(

  );
  TextEditingController descriptionController = TextEditingController(

  );
  TextEditingController locationName = TextEditingController(

  );
  TextEditingController userId = TextEditingController();

  RxString mediaPath = ''.obs;
  RxString imageUrl = ''.obs;

  RxString titleError = ''.obs;
  RxString descriptionError = ''.obs;
  RxString locationNameError = ''.obs;
  RxString imageError = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isTitleError = false.obs;
  RxBool isDescriptionError = false.obs;
  RxBool isLocationNameError = false.obs;
  RxBool isImageError = false.obs;

  SpeechToText speech = SpeechToText();
  RxBool isListening = false.obs;
  RxBool isVideoPlaying = false.obs;

  VideoPlayerController? videoController;

  onSubmit(String idTarget) async {
    // Validasi form
    if (titleController.text.isEmpty) {
      titleError.value = 'Judul tidak boleh kosong';
      isTitleError.value = true;
    } else {
      titleError.value = '';
      isTitleError.value = false;
    }

    if (descriptionController.text.isEmpty) {
      descriptionError.value = 'Deskripsi tidak boleh kosong';
      isDescriptionError.value = true;
    } else {
      descriptionError.value = '';
      isDescriptionError.value = false;
    }

    if (locationName.text.isEmpty) {
      locationNameError.value = 'Nama lokasi tidak boleh kosong';
      isLocationNameError.value = true;
    } else {
      locationNameError.value = '';
      isLocationNameError.value = false;
    }

    // Cek jika semua field valid
    if (!isTitleError.value &&
        !isDescriptionError.value &&
        !isLocationNameError.value &&
        !isImageError.value) {
      isLoading.value = true;
      userId.text = box.read('id');

      String imageUrl = '';
      if (mediaPath.value.isNotEmpty) {
        imageUrl = await uploadImageToCloudinary(File(mediaPath.value));
      } else {
        imageUrl = this.imageUrl.value;
      }

      var updatedData = {
        'title': titleController.text,
        'description': descriptionController.text,
        'location_name': locationName.text,
        'user_id': userId.text,
        'media_url': imageUrl,
        'file_type': mediaPath.value.endsWith('.mp4') ? 'video' : 'image',
      };
      FirebaseFirestore.instance
          .collection('galleries')
          .doc(idTarget)
          .update(updatedData)
          .then((value) {
        isLoading.value = false;
        Get.find<MainLayoutController>().selectedIndex.value = 1;
        Get.delete<ShowController>();
        Get.offNamed('/layout');
        Get.snackbar(
          'Berhasil',
          'Data berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }).catchError((error) {
        isLoading.value = false;
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan saat memperbarui data',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    }
  }

  Future<void> pickMedia(ImageSource source, {bool isVideo = false}) async {
    XFile? pickedFile;

    if (isVideo) {
      pickedFile = await _picker.pickVideo(source: source);
    } else {
      pickedFile = await _picker.pickImage(source: source);
    }

    if (pickedFile != null) {
      mediaPath.value = pickedFile.path;
      if (pickedFile.path.endsWith('.mp4')) {
        videoController = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            videoController!.play();
            update();
          });
      }
    }
  }

  void play() {
    videoController?.play();
    isVideoPlaying.value = true;
    update();
  }

  void pause() {
    videoController?.pause();
    isVideoPlaying.value = false;
    update();
  }

  void togglePlayPause() {
    if (videoController != null) {
      if (videoController!.value.isPlaying) {
        videoController?.pause();
        isVideoPlaying.value = false;
      } else {
        videoController?.play();
        isVideoPlaying.value = true;
      }
    }
    update();
  }

  void initSpeech() async {
    try {
      await speech.initialize();
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void startListening() async {
    await checkMicrophonePermission();
    if (await Permission.microphone.isGranted) {
      isListening.value = true;
      await speech.listen(
        onResult: (result) {
          if (result.toString().isNotEmpty) {
            descriptionController.text = result.recognizedWords;
          }
        },
      );
    } else {
      Get.snackbar(
        'Error',
        'Aplikasi membutuhkan izin mikrofon',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void stopListening() {
    isListening.value = false;
    speech.stop();
  }

  @override
  void onInit() {
    super.onInit();
    initSpeech();
    var arguments = Get.arguments;
    titleController.text = arguments['data']['title'];
    descriptionController.text = arguments['data']['description'];
    locationName.text = arguments['data']['location_name'];
    imageUrl.value = arguments['data']['media_url'];
    print(arguments['data']['media_url']);
    if (arguments['data']['file_type'] == 'video') {
      videoController = VideoPlayerController.networkUrl(
          Uri.parse(arguments['data']['media_url']))
        ..initialize().then((_) {
          videoController!.play();
          update();
        });
    }
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }
}
