import 'package:flutter_mow/models/bookmark.dart';
import 'package:flutter_mow/models/character_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterService {
  // 캐릭터 불러오기
  static Future<CharacterModel> getCharacter() async {
    final url = Uri.parse('${Secrets.awsKey}character/info');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getCharacter----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return CharacterModel.fromJson(responseData);
      } else {
        print('Fail getCharacter');
        throw Error();
      }
    } catch (e) {
      print('Error during getCharacter: $e');
      throw Error();
    }
  }

  // 캐릭터 조합 불러오기
  static Future<int> getCharacterComp() async {
    final url = Uri.parse('${Secrets.awsKey}character/get/comp');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getCharacteComp----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return responseData;
      } else {
        print('Fail getCharacteComp');
        throw Error();
      }
    } catch (e) {
      print('Error during getCharacteComp: $e');
      throw Error();
    }
  }
}
