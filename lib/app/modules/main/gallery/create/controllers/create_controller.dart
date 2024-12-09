import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mountain/app/modules/main/layout/controllers/main_layout_controller.dart';
import 'package:mountain/app/services/cloudinary_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:video_player/video_player.dart';

class CreateController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  GetStorage box = GetStorage();

  TextEditingController titleController = TextEditingController(

  );
  TextEditingController descriptionController = TextEditingController(

  );
  TextEditingController locationName = TextEditingController(

  );
  TextEditingController userId = TextEditingController();

  RxString mediaPath = ''.obs;
  VideoPlayerController? videoController;

  SpeechToText speech = SpeechToText();

  RxString titleError = ''.obs;
  RxString descriptionError = ''.obs;
  RxString locationNameError = ''.obs;
  RxString mediaError = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isTitleError = false.obs;
  RxBool isDescriptionError = false.obs;
  RxBool isLocationNameError = false.obs;
  RxBool isMediaError = false.obs;
  RxBool isVideoPlaying = false.obs;
  RxBool isListening = false.obs;

  Position? currentPosition;
  RxString locationMessage = "Searching latitude and longitude...".obs;
  RxBool isLoadingLocation = false.obs;

  onSubmit() async {
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
    if (mediaPath.value.isEmpty) {
      mediaError.value = 'Gambar atau Video tidak boleh kosong';
      isMediaError.value = true;
    } else {
      mediaError.value = '';
      isMediaError.value = false;
    }

    if (currentPosition == null) {
      Get.snackbar(
        'Error',
        'Lokasi tidak ditemukan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!isTitleError.value &&
        !isDescriptionError.value &&
        !isLocationNameError.value &&
        !isMediaError.value) {
      isLoading.value = true;
      userId.text = box.read('id');
      String mediaUrl = await uploadImageToCloudinary(File(mediaPath.value));

      var data = {
        'title': titleController.text,
        'description': descriptionController.text,
        'location_name': locationName.text,
        'user_id': userId.text,
        'media_url': mediaUrl,
        'created_at': DateTime.now().toString(),
        'location_latitude_longitude':
            "${currentPosition!.latitude},${currentPosition!.longitude}",
        'file_type': mediaPath.value.endsWith('.mp4') ? 'video' : 'image',
      };
      Get.snackbar(
        'Berhasil',
        'Berhasil menambahkan data',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      FirebaseFirestore.instance.collection('galleries').add(data).then(
        (value) {
          isLoading.value = false;
          Get.find<MainLayoutController>().selectedIndex.value = 1;
          Get.offNamed('/layout');
        },
      );
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    isLoadingLocation.value = true;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Error',
            'Aplikasi membutuhkan izin lokasi',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
        if (permission == LocationPermission.deniedForever) {
          Get.snackbar(
            'Error',
            'Aplikasi membutuhkan izin lokasi',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition = position;
      locationMessage.value =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      isLoadingLocation.value = false;
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil lokasi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    getCurrentLocation();
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }
}
