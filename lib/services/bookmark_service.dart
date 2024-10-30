import 'package:flutter_mow/models/bookmark.dart';
import 'package:flutter_mow/models/curation_page_model.dart';
import 'package:flutter_mow/models/curation_place_model.dart';
import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/models/simple_curation_model.dart';
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
}
