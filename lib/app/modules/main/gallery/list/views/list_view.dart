import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:video_player/video_player.dart';

import '../controllers/list_controller.dart';

class ListGalleriesView extends GetView<ListController> {
  const ListGalleriesView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ListController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Gallery 🏞️',
          style: AppTheme.heading1.copyWith(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('galleries')
                      .where('user_id', isEqualTo: controller.userId.value)
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
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final documentSnaphot = documents[index];
                            final item =
                                documentSnaphot.data() as Map<String, dynamic>;
                            final documentId = documentSnaphot.id;
                            bool isVideo = item['file_type'] == 'video';
                            VideoPlayerController? videoController;

                            if (isVideo) {
                              videoController = VideoPlayerController
                                  .networkUrl(Uri.parse(item['media_url']))
                                ..initialize().then((_) {
                                  videoController!.play();
                                });
                            }
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                              child: ListTile(
                                title: Text(
                                  item['title'],
                                  style: AppTheme.heading2.copyWith(
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                ),
                                subtitle: Text(
                                  item['description'],
                                  style: AppTheme.caption.copyWith(
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: isVideo
                                      ? AspectRatio(
                                          aspectRatio: videoController!
                                              .value.aspectRatio,
                                          child: Stack(
                                            children: [
                                              VideoPlayer(videoController),
                                              VideoProgressIndicator(
                                                videoController,
                                                allowScrubbing: true,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                colors: VideoProgressColors(
                                                  playedColor:
                                                      AppTheme.primaryColor,
                                                  bufferedColor: Colors.grey
                                                      .withOpacity(0.5),
                                                  backgroundColor:
                                                      Colors.black26,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Image.network(
                                          item['media_url'],
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                ),
                                onTap: () {
                                  Get.toNamed(
                                    '/show',
                                    arguments: {
                                      'documentId': documentId,
                                      'data': item,
                                    },
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    Get.bottomSheet(
                                      Container(
                                        width: Get.width,
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Are you sure you want to delete this data?',
                                              style: AppTheme.heading2.copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () => Get.back(),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: AppTheme.bodyText
                                                        .copyWith(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('galleries')
                                                        .doc(documentId)
                                                        .delete()
                                                        .then(
                                                          (value) => {
                                                            Get.back(),
                                                            Get.snackbar(
                                                              'Berhasil',
                                                              'Berhasil menghapus data',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            ),
                                                          },
                                                        );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppTheme.primaryColor,
                                                  ),
                                                  child: Text(
                                                    'Hapus',
                                                    style: AppTheme.bodyText
                                                        .copyWith(
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
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Get.toNamed('/create')},
        tooltip: 'Pick Image',
        child: const Icon(Icons.add),
      ),
    );
  }
}
