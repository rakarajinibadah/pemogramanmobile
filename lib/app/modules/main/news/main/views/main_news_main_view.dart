import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';

import '../controllers/main_news_main_controller.dart';

class MainNewsMainView extends GetView<MainNewsMainController> {
  const MainNewsMainView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(MainNewsMainController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mountain News 🏔️',
          style: AppTheme.heading1.copyWith(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.newsList.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchNews();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: controller.newsList.length,
              itemBuilder: (context, index) {
                final news = controller.newsList[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/news-detail', arguments: news);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: 0.1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: news.urlToImage == null ||
                                  news.urlToImage == ''
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CachedNetworkImage(
                                  imageUrl: news.urlToImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 120,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.error,
                                        color: Colors.red, size: 50),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            news.title ?? "",
                            style: AppTheme.bodyText.copyWith(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
