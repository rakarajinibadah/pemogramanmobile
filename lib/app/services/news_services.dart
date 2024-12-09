import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mountain/app/constants/config.dart';
import 'package:mountain/app/models/news_model.dart';

class NewsApiService {
  final Dio _dio = Dio();

  Future<List<News>> fetchNews() async {
    try {
      final response = await _dio.get(
        '${Config.baseUrlNews}/everything',
        queryParameters: {
          'apiKey': Config.apiKeyNews,
          'qInTitle': 'mountains',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['articles'];
        return data.map((item) => News.fromJson(item)).toList();
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch data',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return [];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }
}
