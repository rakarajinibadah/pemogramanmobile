import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:video_player/video_player.dart';
import '../controllers/show_controller.dart';

class ShowView extends GetView<ShowController> {
  const ShowView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ShowController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.toNamed(
                        '/edit',
                        arguments: {
                          'id': controller.id,
                          'data': controller.data,
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.edit_rounded,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: AppTheme.bodyText.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: controller.data['file_type'] == 'image'
                    ? CachedNetworkImage(
                        imageUrl: controller.data['media_url'],
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: Get.width,
                      )
                    : AspectRatio(
                        aspectRatio:
                            controller.videoController!.value.aspectRatio,
                        child: Stack(
                          children: [
                            VideoPlayer(controller.videoController!),
                            VideoProgressIndicator(
                              controller.videoController!,
                              allowScrubbing: true,
                              padding: const EdgeInsets.all(10),
                              colors: VideoProgressColors(
                                playedColor: AppTheme.primaryColor,
                                bufferedColor: Colors.grey.withOpacity(0.5),
                                backgroundColor: Colors.black26,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Row(
                                children: [
                                  Obx(() => IconButton(
                                        icon: Icon(
                                          controller.isPlaying.value
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                        onPressed: controller.togglePlayPause,
                                      )),
                                  Obx(() => IconButton(
                                        icon: Icon(
                                          controller.isMuted.value
                                              ? Icons.volume_off
                                              : Icons.volume_up,
                                          color: Colors.white,
                                        ),
                                        onPressed: controller.toggleMute,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: CachedNetworkImage(
              //     imageUrl: controller.data['media_url'],
              //     placeholder: (context, url) => const Center(
              //       child: CircularProgressIndicator(),
              //     ),
              //     errorWidget: (context, url, error) => const Icon(Icons.error),
              //     fit: BoxFit.cover,
              //     width: double.infinity,
              //     height: 300,
              //   ),
              // ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Title:',
                    style: AppTheme.bodyText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.data['title'] ?? 'No Title',
                    style: AppTheme.heading3.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location Name
                  Text(
                    'Location Name:',
                    style: AppTheme.bodyText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.data['location_name'] ?? 'No Location',
                    style: AppTheme.heading3.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description:',
                    style: AppTheme.bodyText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.data['description'] ?? 'No Description',
                    style: AppTheme.heading3.copyWith(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
