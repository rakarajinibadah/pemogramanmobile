import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:mountain/app/utils/date_format.dart';
import 'package:video_player/video_player.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            return Text(controller.data['title'] ?? 'Loading...');
          },
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => controller.openGoogleMaps(
                  controller.data['location_latitude_longitude'],
                ),
                child: Text(
                  'Lihat Lokasi',
                  style: AppTheme.bodyText.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                    aspectRatio: controller.videoController!.value.aspectRatio,
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
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'By: ',
                        style: AppTheme.caption,
                      ),
                      Text(
                        controller.publisher['name'] ?? '',
                        style: AppTheme.bodyText.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatDate(controller.data['created_at']),
                    style: AppTheme.caption.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    controller.data['location_name'],
                    style: AppTheme.caption.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            controller.data['title'] ?? '',
            style: AppTheme.heading3.copyWith(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.data['description'] ?? '',
            style: AppTheme.bodyText.copyWith(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
