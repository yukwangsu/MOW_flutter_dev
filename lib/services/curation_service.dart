import 'package:flutter_mow/models/curation_page_model.dart';
import 'package:flutter_mow/models/curation_place_model.dart';
import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/models/simple_curation_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurationService {
  //큐레이션 리스트 불러오기
  static Future<SimpleCurationsModel> searchCuration(
    String keyword,
    List<String> featureList,
    int order, // 0(최신 순), 1(오래된 순), 2(좋아요 순)
    int page,
    int size,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}curation?order=$order&page=$page&size=$size');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
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

  //큐레이션 리스트 불러오기
  static Future<CurationPlaceModel> getCurationPlace(
    int workspaceId,
    int order, // 0(최신 순), 1(오래된 순), 2(좋아요 순)
    int page,
    int size,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}curation/by/space?workspaceId=$workspaceId&order=$order&page=$page&size=$size');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers);
      print('----------[service] getCurationPlace----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return CurationPlaceModel.fromJson(responseData);
      } else {
        print('Fail CurationPlaceModel');
        throw Error();
      }
    } catch (e) {
      print('Error during CurationPlaceModel: $e');
      throw Error();
    }
  }

  //큐레이션 페이지 불러오기
  static Future<CurationPageModel> getCurationById(
    int curationId,
    int order,
    int page,
    int size,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}curation/info?curationId=$curationId&order=$order&page=$page&size=$size');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getCurationById----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return CurationPageModel.fromJson(responseData);
      } else {
        print('Fail getCurationById');
        throw Error();
      }
    } catch (e) {
      print('Error during getCurationById: $e');
      throw Error();
    }
  }

  //큐레이션 작성하기
  static Future<bool> writeCuration(
    String curationTitle,
    featureTags,
    text,
    int workspaceId,
    List<String> curationPhotoList,
  ) async {
    final url = Uri.parse('${Secrets.awsKey}curation/update');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
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
    List<int> tagNumbers = featureTags.map((tag) => tagMap[tag]!).toList();
    String tags = tagNumbers.join(',');

    //사진 url저장
    List<String> photoList = [];
    for (int i = 0; i < curationPhotoList.length; i++) {
      photoList.add(curationPhotoList[i]);
    }
    for (int j = 0; j < 10 - curationPhotoList.length; j++) {
      photoList.add("no image");
    }

    //현재시간 가져오기(ISO 8601 형식)
    String createdAt = DateTime.now().toUtc().toIso8601String();
    String updatedAt = createdAt;

    var data = {
      "workspaceId": workspaceId,
      "curationTitle": curationTitle,
      "featureTags": tags,
      "text": text,
      "curationPhoto": photoList[0],
      "curationPhoto2": photoList[1],
      "curationPhoto3": photoList[2],
      "curationPhoto4": photoList[3],
      "curationPhoto5": photoList[4],
      "curationPhoto6": photoList[5],
      "curationPhoto7": photoList[6],
      "curationPhoto8": photoList[7],
      "curationPhoto9": photoList[8],
      "curationPhoto10": photoList[9],
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };

    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------[service] writeCuration----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("[success] writeCuration");
        return true;
      } else {
        print("[fail] writeCuration");
        return false;
      }
    } catch (e) {
      print('Error during writeCuration: $e');
      return false;
    }
  }
}
