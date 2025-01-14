import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/models/word_cloud_model.dart';
import 'package:flutter_mow/variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static Future<void> addReview(
    String reviewText,
    List<String> featureTags,
    int workspaceId,
    double stars,
  ) async {
    final url = Uri.parse('${Secrets.awsKey}review/update');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    List<int> tagNumbers = featureTags
        .where((tag) => tagMap[tag] != null) // null 값 필터링
        .map((tag) => tagMap[tag]!)
        .toList();
    String tags = tagNumbers.join(',');

    // //userId 가져오기
    // final prefs = await SharedPreferences.getInstance();
    // int? userId = prefs.getInt('userId');

    //현재시간 가져오기(ISO 8601 형식)
    String createdAt = DateTime.now().toUtc().toIso8601String();

    var data = {
      "workspaceId": workspaceId,
      // "userId": userId,
      "stars": stars,
      "reviewText": reviewText,
      "featureTags": tags,
      "createdAt": createdAt,
    };

    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------[service] addReview----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("[success] addReview");
      } else {
        print("[fail] addReview");
      }
    } catch (e) {
      print('Error during addReview: $e');
    }
  }

  static Future<WordCloudModel> getTags(
    int workspaceId,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}workspace/tag/cnt?workspaceId=$workspaceId');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getTags----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("[success] getTags");
        final responseData = json.decode(response.body);
        print(responseData);
        return WordCloudModel.fromJson(responseData);
      } else {
        print("[fail] getTags");
        throw Error();
      }
    } catch (e) {
      print('Error during getTags: $e');
      throw Error();
    }
  }

  // 본인이 작성한 리뷰 불러오기
  static Future<List<dynamic>> getReviewMine(int id) async {
    final url = Uri.parse('${Secrets.awsKey}review/mine?workspaceId=$id');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getReviewMine----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return responseData;
      } else {
        print('Fail getReviewMine');
        throw Error();
      }
    } catch (e) {
      print('Error during getReviewMine: $e');
      throw Error();
    }
  }

  //리뷰 삭제하기
  static Future<bool> deleteReviewById(
    int reviewId,
  ) async {
    final url = Uri.parse('${Secrets.awsKey}review/delete?reviewId=$reviewId');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.delete(url, headers: headers);
      print('----------[service] deleteReviewById----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail deleteReviewById');
        return false;
      }
    } catch (e) {
      print('Error during deleteReviewById: $e');
      return false;
    }
  }
}
