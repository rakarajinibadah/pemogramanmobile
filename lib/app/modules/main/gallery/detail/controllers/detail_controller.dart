import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class DetailController extends GetxController {
  var id = ''.obs;
  var data = {}.obs;
  var publisher = {}.obs;
  VideoPlayerController? videoController;

  var isPlaying = false.obs;
  var isMuted = false.obs;

  void openGoogleMaps(String latlng) {
    final url = 'https://www.google.com/maps?q=$latlng';
    launchUrlFn(url);
  }

  void launchUrlFn(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not launch $url',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        throw 'Could not launch $url';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      id.value = arguments['id'];
      data.value = arguments['data'];
      publisher.value = arguments['publisher'];

      if (data['file_type'] == 'video') {
        videoController =
            VideoPlayerController.networkUrl(Uri.parse(data['media_url']))
              ..initialize().then((_) {
                update();
                if (videoController!.value.isInitialized) {
                  videoController!.play();
                  isPlaying.value = true;
                }
              }).catchError(
                (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to load video: $e',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  print('Error: $e');
                },
              );
      }
    }
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }

  // Fungsi Play/Pause
  void togglePlayPause() {
    if (isPlaying.value) {
      videoController!.pause();
      isPlaying.value = false;
    } else {
      videoController!.play();
      isPlaying.value = true;
    }
  }

  // Fungsi Mute/Unmute
  void toggleMute() {
    if (isMuted.value) {
      videoController!.setVolume(1.0);
      isMuted.value = false;
    } else {
      videoController!.setVolume(0.0);
      isMuted.value = true;
    }
  }
}
