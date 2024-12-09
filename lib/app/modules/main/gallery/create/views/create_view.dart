import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:mountain/app/widgets/custom_button.dart';
import 'package:mountain/app/widgets/custom_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../controllers/create_controller.dart';

class CreateView extends GetView<CreateController> {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create new data',
          style: AppTheme.heading1.copyWith(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          24,
          0,
          24,
          30,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.grey.withOpacity(0.5),
                ),
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('Pick Image'),
                            onTap: () {
                              controller.pickMedia(ImageSource.gallery);
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.videocam),
                            title: const Text('Pick Video'),
                            onTap: () {
                              controller.pickMedia(ImageSource.gallery,
                                  isVideo: true);
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Pick from Camera'),
                            onTap: () {
                              // Pilihan kamera untuk foto atau video
                              Get.bottomSheet(
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.photo_camera),
                                        title: const Text('Pick Photo'),
                                        onTap: () {
                                          controller
                                              .pickMedia(ImageSource.camera);
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.videocam),
                                        title: const Text('Pick Video'),
                                        onTap: () {
                                          controller.pickMedia(
                                              ImageSource.camera,
                                              isVideo: true);
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  'Pick Image or Video',
                  style: AppTheme.bodyText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Obx(
              () {
                return controller.mediaPath.value.isEmpty
                    ? Image.asset(
                        'assets/image.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: File(controller.mediaPath.value)
                                .path
                                .endsWith(".mp4")
                            ? AspectRatio(
                                aspectRatio: controller
                                    .videoController!.value.aspectRatio,
                                child: Stack(
                                  children: [
                                    VideoPlayer(controller.videoController!),
                                    VideoProgressIndicator(
                                      controller.videoController!,
                                      allowScrubbing: true,
                                      padding: const EdgeInsets.all(10),
                                      colors: VideoProgressColors(
                                        playedColor: AppTheme.primaryColor,
                                        bufferedColor:
                                            Colors.grey.withOpacity(0.5),
                                        backgroundColor: Colors.black26,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Image.file(
                                File(controller.mediaPath.value),
                                width: Get.width,
                                fit: BoxFit.cover,
                              ),
                      );
              },
            ),
          ),

          Obx(
            () {
              if (controller.mediaError.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '*${controller.mediaError.value}',
                    style: AppTheme.bodyText.copyWith(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),

          const SizedBox(height: 24),

          // Title input
          Obx(
            () {
              return CustomInput(
                labelText: 'Judul',
                controller: controller.titleController,
                errorMessage: controller.titleError.value,
                isError: controller.isTitleError.value,
              );
            },
          ),
          const SizedBox(height: 16),

          // Location Name input
          Obx(
            () {
              return CustomInput(
                labelText: 'Nama Lokasi',
                controller: controller.locationName,
                errorMessage: controller.locationNameError.value,
                isError: controller.isLocationNameError.value,
              );
            },
          ),
          const SizedBox(height: 16),

          // Description input
          Obx(
            () {
              return CustomInput(
                labelText: 'Deskripsi',
                controller: controller.descriptionController,
                errorMessage: controller.descriptionError.value,
                isError: controller.isDescriptionError.value,
                maxLines: 5,
              );
            },
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.isListening.value
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.stopListening,
                    child: Text(
                      'Stop Listening',
                      style: AppTheme.bodyText.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.startListening,
                    child: Text(
                      'Start Listening',
                      style: AppTheme.bodyText.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => controller.getCurrentLocation(),
            child: Text(
              'Get Current Location',
              style: AppTheme.bodyText.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Obx(
            () {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: controller.isLoadingLocation.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(controller.locationMessage.value),
              );
            },
          ),

          const SizedBox(height: 24),
          Obx(
            () {
              return CustomButton(
                onPressed: () {
                  if (controller.isLoading.value) {
                    return;
                  }
                  controller.onSubmit();
                },
                text: controller.isLoading.value ? 'Loading...' : 'Create New',
                isLoading: controller.isLoading.value,
              );
            },
          ),
        ],
      ),
    );
  }
}
