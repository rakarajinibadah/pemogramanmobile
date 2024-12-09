import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:mountain/app/utils/clean_text.dart';
import 'package:mountain/app/utils/date_format.dart';

import '../controllers/main_news_detail_controller.dart';

class MainNewsDetailView extends GetView<MainNewsDetailController> {
  const MainNewsDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(MainNewsDetailController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail News",
          style: AppTheme.heading1.copyWith(
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            if (controller.news.value == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: controller.news.value?.urlToImage == null ||
                              controller.news.value?.urlToImage == ''
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl: controller.news.value!.urlToImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      controller.news.value!.title ?? 'No title',
                      style: AppTheme.heading1.copyWith(fontSize: 22),
                    ),
                    SizedBox(height: 5),
                    Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: <Widget>[
                        if ((controller.news.value!.author ?? '').isNotEmpty)
                          Text(
                            controller.news.value!.author ?? 'No author',
                            style: AppTheme.caption.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if ((controller.news.value!.author ?? '').isNotEmpty)
                          Text(
                            ' at ',
                            style: AppTheme.caption.copyWith(fontSize: 14),
                          ),
                        Text(
                          formatDate(
                              controller.news.value!.publishedAt.toString()),
                          style: AppTheme.caption.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Text(
                          'Source : ',
                          style: AppTheme.caption,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          controller.news.value?.source.name ?? 'No source',
                          style: AppTheme.caption.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Description : ',
                      style: AppTheme.caption.copyWith(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      controller.news.value!.description ?? 'No description',
                      style: AppTheme.bodyText.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Content : ',
                      style: AppTheme.caption.copyWith(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: cleanContent(
                          controller.news.value!.content ?? 'No content',
                        ),
                        style: AppTheme.bodyText.copyWith(
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'View More',
                            style: AppTheme.bodyText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(
                                  '/news-webview',
                                  arguments: controller.news.value!.url,
                                );
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
