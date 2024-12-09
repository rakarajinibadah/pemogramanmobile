import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ShowController extends GetxController {
  var id = ''.obs;
  var data = {}.obs;
  VideoPlayerController? videoController;
  var isPlaying = false.obs;
  var isMuted = false.obs;

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      videoController!.pause();
      isPlaying.value = false;
    } else {
      videoController!.play();
      isPlaying.value = true;
    }
  }

  void toggleMute() {
    if (isMuted.value) {
      videoController!.setVolume(1.0);
      isMuted.value = false;
    } else {
      videoController!.setVolume(0.0);
      isMuted.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      id.value = arguments['documentId'];
      data.value = arguments['data'];
      if (data['file_type'] == 'video') {
        videoController = VideoPlayerController.networkUrl(
          Uri.parse(
            data['media_url'],
          ),
        )..initialize().then(
            (_) {
              videoController!.play();
            },
          );
      }
    }
  }
}
