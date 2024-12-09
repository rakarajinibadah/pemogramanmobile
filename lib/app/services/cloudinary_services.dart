import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mountain/app/constants/config.dart';

Future<String> uploadImageToCloudinary(File imageFile) async {
  final dio = Dio();
  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(imageFile.path),
    'upload_preset': 'mountain',
  });

  try {
    final response = await dio.post(
      'https://api.cloudinary.com/v1_1/${Config.cloudName}/upload',
      data: formData,
    );

    // Mendapatkan URL gambar setelah berhasil diupload
    if (response.statusCode == 200) {
      print('Response:');
      print(response.data);
      final String imageUrl = response.data['secure_url']; 
      return imageUrl;
    } else {
      throw Exception('Failed to upload image');
    }
  } catch (e) {
    throw Exception('Error uploading image: $e');
  }
}
