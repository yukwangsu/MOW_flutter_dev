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

  //특정 장소의 큐레이션 리스트 불러오기
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

  // 본인이 작성한 큐레이션Id 불러오기
  static Future<List<dynamic>> getCurationMine() async {
    final url = Uri.parse('${Secrets.awsKey}curation/mine');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getCurationMine----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return responseData;
      } else {
        print('Fail getCurationMine');
        throw Error();
      }
    } catch (e) {
      print('Error during getCurationMine: $e');
      throw Error();
    }
  }

  //큐레이션 작성하기
  static Future<bool> writeCuration(
    String curationTitle,
    String text,
    List<String> featureTags,
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

  //큐레이션 수정하기
  static Future<bool> editCuration(
    int curationId,
    String curationTitle,
    String text,
    List<String> featureTags,
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
      "curationId": curationId,
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
      print('----------[service] editCuration----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("[success] editCuration");
        return true;
      } else {
        print("[fail] editCuration");
        return false;
      }
    } catch (e) {
      print('Error during editCuration: $e');
      return false;
    }
  }

  //큐레이션 삭제하기
  static Future<bool> deleteCurationById(
    int curationId,
  ) async {
    final url =
        Uri.parse('${Secrets.awsKey}curation/delete?curationId=$curationId');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.delete(url, headers: headers);
      print('----------[service] deleteCurationById----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail deleteCurationById');
        return false;
      }
    } catch (e) {
      print('Error during deleteCurationById: $e');
      return false;
    }
  }

  // 큐레이션 좋아요
  static Future<bool> likeCuration(
    int curationId,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}curation/like/increment?curationId=$curationId');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.patch(url, headers: headers);
      print('----------[service] likeCuration----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail likeCuration');
        return false;
      }
    } catch (e) {
      print('Error during likeCuration: $e');
      return false;
    }
  }

  // 큐레이션 좋아요 취소
  static Future<bool> cancelLikeCuration(
    int curationId,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}curation/like/decrement?curationId=$curationId');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.patch(url, headers: headers);
      print('----------[service] cancelLikeCuration----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail cancelLikeCuration');
        return false;
      }
    } catch (e) {
      print('Error during cancelLikeCuration: $e');
      return false;
    }
  }

  // 본인이 작성한 큐레이션 리스트 불러오기
  static Future<MyCurationListModel> getMyCuration() async {
    final url = Uri.parse('${Secrets.awsKey}curation/mine/all');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getMyCuration----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return MyCurationListModel.fromJson(responseData);
      } else {
        print('Fail getMyCuration');
        throw Error();
      }
    } catch (e) {
      print('Error during getMyCuration: $e');
      throw Error();
    }
  }

  // 본인이 좋아요를 누른 큐레이션 리스트 불러오기
  static Future<MyCurationListModel> getLikeCuration() async {
    final url = Uri.parse('${Secrets.awsKey}curation/mine/like');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getLikeCuration----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return MyCurationListModel.fromJson(responseData);
      } else {
        print('Fail getLikeCuration');
        throw Error();
      }
    } catch (e) {
      print('Error during getLikeCuration: $e');
      throw Error();
    }
  }
}
