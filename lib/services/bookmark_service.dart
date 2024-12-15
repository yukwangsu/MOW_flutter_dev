import 'package:flutter_mow/models/bookmark.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  //북마크 리스트 불러오기
  static Future<BookmarkListModel> getBookmarkList() async {
    final url = Uri.parse('${Secrets.awsKey}bookmark/lists');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getBookmarkList----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return BookmarkListModel.fromJson(responseData);
      } else {
        print('Fail getBookmarkList');
        throw Error();
      }
    } catch (e) {
      print('Error during getBookmarkList: $e');
      throw Error();
    }
  }

  //북마크 리스트에 공간 추가
  static Future<bool> addPlaceToBookmark(
    int bookmarkListId,
    int workspaceId,
  ) async {
    final url = Uri.parse('${Secrets.awsKey}bookmark/add/workspace');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    var data = {
      "bookmarkListId": bookmarkListId,
      "workspaceId": workspaceId,
    };
    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------[service] addPlaceToBookmark----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        print(responseData);
        return true;
      } else {
        print('Fail addPlaceToBookmark');
        return false;
      }
    } catch (e) {
      print('Error during addPlaceToBookmark: $e');
      return false;
    }
  }

  //새로운 리스트 추가
  static Future<bool> addBookmarkList(
    String bookmarkListTitle,
    int color,
  ) async {
    final url = Uri.parse('${Secrets.awsKey}bookmark/update');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    var data = {
      "bookmarkListTitle": bookmarkListTitle,
      "color": color,
    };
    var body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('----------[service] addBookmarkList----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        print(responseData);
        return true;
      } else {
        print('Fail addBookmarkList');
        return false;
      }
    } catch (e) {
      print('Error during addBookmarkList: $e');
      return false;
    }
  }

  // 북마크에서 장소를 삭제
  static Future<bool> removeWorkspaceFromBookmarkList(
    int workspaceId,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}bookmark/delete/bookmarked/workspace?bookmarkWorkspaceId=$workspaceId');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(url, headers: headers);
      print('----------[service] removeWorkspaceFromBookmarkList----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        print(responseData);
        return true;
      } else {
        print('Fail removeWorkspaceFromBookmarkList');
        return false;
      }
    } catch (e) {
      print('Error during removeWorkspaceFromBookmarkList: $e');
      return false;
    }
  }
}
