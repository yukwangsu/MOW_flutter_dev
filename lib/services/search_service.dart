import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/models/place_list_model.dart';
import 'package:flutter_mow/variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

//model을 사용하지 않음. 추후 수정필요
class SearchService {
  static Future<List?> searchPlace(
    String keyword,
    int order,
    String locationType,
    List<String> appliedSearchTags,
    double userLatitude,
    double userLongitude,
  ) async {
    final url =
        Uri.parse('${Secrets.awsKey}workspace?order=$order&page=0&size=40');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    // 공간 태그 (0: 넓어요, 1: 보통이에요, 2: 좁아요)
    int widenessDegree = 2; // 기본값 2: 좁아요(해당 값보다 좋거나 같은 정도만 검색)
    if (appliedSearchTags.contains('# 공간이 넓어요')) {
      widenessDegree = 0;
      // appliedSearchTags.remove('# 공간이 넓어요');
      // appliedSearchTags.remove('# 공간이 보통이에요');
    } else if (appliedSearchTags.contains('# 공간이 보통이에요')) {
      widenessDegree = 1;
      // appliedSearchTags.remove('# 공간이 보통이에요');
    }
    // 좌석 태그
    int chairDegree = 2; // 기본값 2: 적어요(해당 값보다 좋거나 같은 정도만 검색)
    if (appliedSearchTags.contains('# 좌석이 많아요')) {
      chairDegree = 0;
      // appliedSearchTags.remove('# 좌석이 많아요');
      // appliedSearchTags.remove('# 좌석이 보통이에요');
    } else if (appliedSearchTags.contains('# 좌석이 보통이에요')) {
      chairDegree = 1;
      // appliedSearchTags.remove('# 좌석이 보통이에요');
    }
    // 콘센트 태그
    int outletDegree = 2; // 기본값 2: 적어요(해당 값보다 좋거나 같은 정도만 검색)
    if (appliedSearchTags.contains('# 콘센트가 많아요')) {
      outletDegree = 0;
      // appliedSearchTags.remove('# 콘센트가 많아요');
      // appliedSearchTags.remove('# 콘센트가 보통이에요');
    } else if (appliedSearchTags.contains('# 콘센트가 보통이에요')) {
      outletDegree = 1;
      // appliedSearchTags.remove('# 콘센트가 보통이에요');
    }

    List<int> tagNumbers = appliedSearchTags
        .where((tag) => tagMap[tag] != null) // null 값 필터링
        .map((tag) => tagMap[tag]!)
        .toList();

    var data = (locationType.isEmpty || locationType == '모든 공간')
        ? {
            "keyword": keyword,
            "featureYnList": tagNumbers,
            "widenessYn": widenessDegree,
            "outletYn": outletDegree,
            "chairYn": chairDegree,
            "userLatitude": userLatitude,
            "userLongitude": userLongitude,
          }
        : {
            "keyword": keyword,
            "workspaceType": [locationType],
            "featureYnList": tagNumbers,
            "widenessYn": widenessDegree,
            "outletYn": outletDegree,
            "chairYn": chairDegree,
            "userLatitude": userLatitude,
            "userLongitude": userLongitude,
          };
    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------[service] search place----------');
      print('Response status: ${response.statusCode}');
      // 추후에 data로 이동
      print('*** appliedSearchTags: $appliedSearchTags');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        List workspaces = responseData['workspaceDtoList'];
        return workspaces;
      } else {
        print('Fail searchPlace');
        return null;
      }
    } catch (e) {
      print('Error during searchPlace: $e');
      return null;
    }
  }

  static Future<PlaceListModel> searchPlaceList(
    String keyword,
    int order,
    String locationType,
    List<String> appliedSearchTags,
    double userLatitude,
    double userLongitude,
  ) async {
    final url =
        Uri.parse('${Secrets.awsKey}workspace?order=$order&page=0&size=40');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    var data = {
      "keyword": keyword,
      "featureYnList": [],
      "userLatitude": userLatitude,
      "userLongitude": userLongitude,
    };
    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------[service] searchPlaceList----------');
      print('Response status: ${response.statusCode}');
      // 추후에 data로 이동
      print('*** appliedSearchTags: $appliedSearchTags');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return PlaceListModel.fromJson(responseData);
      } else {
        print('Fail searchPlaceList');
        throw Error();
      }
    } catch (e) {
      print('Error during searchPlaceList: $e');
      throw Error();
    }
  }

  //작업공간 북마크 색 가져오기
  static Future<Map<String, dynamic>> getWorkspaceBookmarkColor() async {
    final url = Uri.parse('${Secrets.awsKey}bookmark/workspaces/color');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getWorkspaceBookmarkColor----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return responseData;
      } else {
        print('Fail getWorkspaceBookmarkColor');
        throw Error();
      }
    } catch (e) {
      print('Error during getWorkspaceBookmarkColor: $e');
      throw Error();
    }
  }

  //model을 사용함.
  static Future<PlaceDetailModel> getPlaceById(int id) async {
    // final prefs = await SharedPreferences.getInstance();
    // int? userId = prefs.getInt('userId');

    // final url = Uri.parse(
    //     '${Secrets.awsKey}workspace/info?workspaceId=$id&userId=$userId&order=1&page=0&size=20');
    final url = Uri.parse(
        '${Secrets.awsKey}workspace/info?workspaceId=$id&order=1&page=0&size=40');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getPlaceById----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return PlaceDetailModel.fromJson(responseData);
      } else {
        print('Fail getPlaceById');
        throw Error();
      }
    } catch (e) {
      print('Error during getPlaceById: $e');
      throw Error();
    }
  }
}
