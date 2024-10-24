import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/models/simple_curation_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurationService {
  static Future<SimpleCurationsModel> searchCuration(
    String keyword,
    List<String> featureList,
    int order, // 0(최신 순), 1(오래된 순), 2(좋아요 순)
    int page,
    int size,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}curation?order=$order&page=$page&size=$size');
    var headers = {
      'Content-Type': 'application/json',
    };
    // 태그 변수 map
    Map<String, int> tagMap = {
      '감성적인': 1,
      '자연적인': 2,
      '모던한': 3,
      '차분한': 4,
      '빈티지': 5,
      '커피 맛집': 6,
      '디저트 맛집': 7,
      '한적한': 8,
      '아기자기한': 9,
      '아늑한': 10,
      '재미있는': 11,
      '웨커이션': 12,
      '작업하기 좋은': 13,
      '볼거리가 많은': 14,
    };
    List<int> tagNumbers = featureList.map((tag) => tagMap[tag]!).toList();

    var data = {
      "keyword": keyword,
      "featureYnList": tagNumbers,
    };
    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------[service] searchCuration----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return SimpleCurationsModel.fromJson(responseData);
      } else {
        print('Fail searchCuration');
        throw Error();
      }
    } catch (e) {
      print('Error during searchCuration: $e');
      throw Error();
    }
  }
}
