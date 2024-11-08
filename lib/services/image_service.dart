import 'package:flutter_mow/models/curation_page_model.dart';
import 'package:flutter_mow/models/curation_place_model.dart';
import 'package:flutter_mow/models/image_model.dart';
import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/models/simple_curation_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageService {
  // 이미지 url 발급받기
  static Future<ImageModel> getImageUrl(
    String filename,
  ) async {
    final url = Uri.parse('${Secrets.awsKey}s3/posturl?filename=$filename');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getPreSignedUrl----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return ImageModel.fromJson(responseData);
      } else {
        print('Fail getPreSignedUrl');
        throw Error();
      }
    } catch (e) {
      print('Error during getPreSignedUrl: $e');
      throw Error();
    }
  }

  static String getContentType(String filePath) {
    if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
      return 'image/jpeg';
    } else if (filePath.endsWith('.png')) {
      return 'image/png';
    } else if (filePath.endsWith('.gif')) {
      return 'image/gif';
    }
    return 'application/octet-stream'; // 기본값
  }

  // 이미지 upload하기
  static Future<int> uploadImage(
    String preSignedUrl,
    XFile image,
  ) async {
    try {
      var imageByte = await image.readAsBytes();
      var contentType = getContentType(image.path);
      var response = await http.put(
        Uri.parse(preSignedUrl),
        headers: {
          'Content-Type': contentType,
        },
        body: imageByte,
      );

      print('----------[service] uploadImage----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.statusCode;
      } else {
        print('Fail uploadImage');
        throw Error();
      }
    } catch (e) {
      print('Error during uploadImage: $e');
      throw Error();
    }
  }
}
