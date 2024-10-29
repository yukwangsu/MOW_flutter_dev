import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static void addReview(
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

    // 태그 변수 map
    Map<String, int> tagMap = {
      '# 공간이 넓어요': 1,
      '# 좌석이 많아요': 2,
      '# 콘센트가 많아요': 3,
      '# 한산해요': 4,
      '# 의자가 편해요': 5,
      '# 책상이 넓어요': 6,
      '# 뷰가 좋아요': 7,
      '# 조용해요': 8,
      '# 아늑해요': 9,
      '# 인테리어가 깔끔해요': 10,
      '# 어두워요': 11,
      '# 밝아요': 12,
      '# 다시 오고 싶어요': 13,
      '# 음악이 좋아요': 14,
      '# 대화하기 좋아요': 15,
      '# 감각적이에요': 16,
      '# 혼자 작업하기 좋아요': 17,
      '# 회의하기에 좋아요': 18,
      '# 저렴해요': 19,
      '# 매뉴가 다양해요': 20,
      '# 커피가 맛있어요': 21,
      '# 디저트가 맛있어요': 22,
      '# 친절해요': 23,
      '# 와이파이가 잘 터져요': 24,
      '# 에어컨이 잘 나와요': 25,
      '# 오래 작업하기 좋아요': 26,
      '# 화장실이 깨끗해요': 27,
      '# 찾아가기 편해요': 28,
      '# 무료로 이용이 가능해요': 29,
      '# 주차가 가능해요': 30,
      '# 24시간 운영이에요': 31,
      '# 공간이 보통이에요': 32,
      '# 공간이 좁아요': 33,
      '# 좌석이 보통이에요': 34,
      '# 좌석이 적어요': 35,
      '# 콘센트가 보통이에요': 36,
      '# 콘센트가 적어요': 37,
    };
    List<int> tagNumbers = featureTags.map((tag) => tagMap[tag]!).toList();
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
}
