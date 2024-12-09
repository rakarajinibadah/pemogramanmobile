import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:mountain/app/controllers/auth_controller.dart';
import 'package:mountain/app/utils/date_format.dart';
import 'package:video_player/video_player.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            return Row(
              children: [
                Text(
                  'Welcome, ',
                  style: AppTheme.caption.copyWith(
                    fontSize: 16,
                  ),
                ),
                controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : Text(
                        '${controller.name.value} 🚀',
                        style: AppTheme.heading2.copyWith(
                          fontSize: 18,
                        ),
                      ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              Get.bottomSheet(
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Are you sure you want to logout?',
                        style: AppTheme.heading2.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTheme.bodyText.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Get.find<AuthController>().logout();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                            ),
                            child: Text(
                              'Logout',
                              style: AppTheme.bodyText.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('galleries')
            .orderBy(
              'created_at',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Center(
                child: Text(
                  'No Data',
                  style: AppTheme.heading3.copyWith(
                    fontSize: 20,
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(documents.length, (index) {
                      final document = documents[index];
                      final data = document.data() as Map<String, dynamic>;
                      final userId = data['user_id'];
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: userId)
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (userSnapshot.hasError) {
                            return Center(
                                child: Text('Error: ${userSnapshot.error}'));
                          } else if (!userSnapshot.hasData ||
                              !userSnapshot.data!.docs.isNotEmpty) {
                            return Center(child: Text('User data not found'));
                          } else {
                            final userData = userSnapshot.data!.docs.first
                                .data() as Map<String, dynamic>;
                            final userName = userData['name'] ?? 'Unknown User';

                            String imageUrl = data['media_url'] ?? '';
                            String title = data['title'] ?? 'No Title';
                            String locationName =
                                data['location_name'] ?? 'Unknown Location';
                            String createdAt = data['created_at'];
                            bool isVideo = data['file_type'] == 'video';
                            VideoPlayerController? videoController;

                            if (isVideo) {
                              videoController = VideoPlayerController
                                  .networkUrl(Uri.parse(imageUrl))
                                ..initialize().then((_) {
                                  videoController!.play();
                                });
                            }

                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  '/detail',
                                  arguments: {
                                    'id': document.id,
                                    'data': data,
                                    'publisher': userData,
                                  },
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(
                                  6,
                                ),
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: isVideo
                                            ? AspectRatio(
                                                aspectRatio:
                                                    videoController != null
                                                        ? videoController
                                                            .value.aspectRatio
                                                        : 16 / 9,
                                                child: Stack(
                                                  children: [
                                                    VideoPlayer(
                                                        videoController!),
                                                    VideoProgressIndicator(
                                                      videoController,
                                                      allowScrubbing: true,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      colors:
                                                          VideoProgressColors(
                                                        playedColor: AppTheme
                                                            .primaryColor,
                                                        bufferedColor: Colors
                                                            .grey
                                                            .withOpacity(0.5),
                                                        backgroundColor:
                                                            Colors.black26,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  double maxHeight = 250;
                                                  double imageHeight =
                                                      constraints.maxHeight >
                                                              maxHeight
                                                          ? maxHeight
                                                          : constraints
                                                              .maxHeight;

                                                  return CachedNetworkImage(
                                                    imageUrl: imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: imageHeight,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Center(
                                                      child: Icon(Icons.error,
                                                          color: Colors.red,
                                                          size: 50),
                                                    ),
                                                  );
                                                },
                                              )),
                                    const SizedBox(height: 6),
                                    Text(
                                      userName,
                                      style: AppTheme.heading3.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      title,
                                      style: AppTheme.bodyText.copyWith(
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: AppTheme.primaryColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          locationName,
                                          style: AppTheme.caption.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          color: AppTheme.primaryColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          formatDate(createdAt),
                                          style: AppTheme.caption.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
