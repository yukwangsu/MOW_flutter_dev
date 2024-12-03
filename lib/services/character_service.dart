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
        if (responseData == 0) {
          // 저장된 조합이 없을 경우 10000(기본값) 반환
          return 10000;
        } else {
          return responseData;
        }
      } else {
        print('Fail getCharacteComp');
        throw Error();
      }
    } catch (e) {
      print('Error during getCharacteComp: $e');
      throw Error();
    }
  }

  // 캐릭터 조합 수정하기
  static Future<bool> editCharacterComp(
    int newComp,
  ) async {
    final url = Uri.parse(
        '${Secrets.awsKey}character/update/comp?characterComp=$newComp');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.put(url, headers: headers);
      print('----------[service] editCharacterComp----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail editCharacterComp');
        return false;
      }
    } catch (e) {
      print('Error during editCharacterComp: $e');
      return false;
    }
  }

  // 캐릭터 정보 수정하기
  static Future<CharacterModel> editCharacterInfo(
    String characterDetail,
    String characterMessage,
  ) async {
    final url = Uri.parse('${Secrets.awsKey}character/update');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    var data = {
      "characterType": 0,
      "characterDetail": characterDetail,
      "characterMessage": characterMessage,
    };
    var body = jsonEncode(data);

    try {
      final response = await http.put(url, headers: headers, body: body);
      print('----------[service] editCharacterInfo----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return CharacterModel.fromJson(responseData);
      } else {
        print('Fail editCharacterInfo');
        throw Error();
      }
    } catch (e) {
      print('Error during editCharacterInfo: $e');
      throw Error();
    }
  }

  // 보유한 아이템 불러오기
  static Future<List<dynamic>> getOwnedItems() async {
    final url = Uri.parse('${Secrets.awsKey}possession/info');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getOwnedItems----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        return responseData;
      } else {
        print('Fail getOwnedItems');
        throw Error();
      }
    } catch (e) {
      print('Error during getOwnedItems: $e');
      throw Error();
    }
  }

  // 아이템 구매(추가)하기
  static Future<bool> addItem(int itemCode) async {
    final url =
        Uri.parse('${Secrets.awsKey}possession/update?possession=$itemCode');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.put(url, headers: headers);
      print('----------[service] addItem----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail addItem');
        return false;
      }
    } catch (e) {
      print('Error during addItem: $e');
      return false;
    }
  }

  // 보유한 보상 불러오기
  static Future<int> getMyReward() async {
    final url = Uri.parse('${Secrets.awsKey}reward?rewardType=0');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('----------[service] getMyReward----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(utf8Body);
        final reward = responseData['rewardContent'];
        if (reward == null) {
          // 초기에 reward가 0일 경우
          return 0;
        } else {
          return reward;
        }
      } else {
        print('Fail getMyReward');
        throw Error();
      }
    } catch (e) {
      print('Error during getMyReward: $e');
      throw Error();
    }
  }

  // 보유 보상 증가(보상 획득)
  static Future<bool> increaseReward(int amount) async {
    final url = Uri.parse('${Secrets.awsKey}reward/update');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    var data = {
      "rewardType": 0,
      "rewardContent": amount,
      "adjustmentType": 0, // 0: 증가, 1, 감소
    };
    var body = jsonEncode(data);

    try {
      final response = await http.put(url, headers: headers, body: body);
      print('----------[service] increaseReward----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail increaseReward');
        return false;
      }
    } catch (e) {
      print('Error during increaseReward: $e');
      return false;
    }
  }

  // 보유 보상 감소(아이템 구매)
  static Future<bool> decreaseReward(int amount) async {
    final url = Uri.parse('${Secrets.awsKey}reward/update');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };

    var data = {
      "rewardType": 0,
      "rewardContent": amount,
      "adjustmentType": 1, // 0: 증가, 1, 감소
    };
    var body = jsonEncode(data);

    try {
      final response = await http.put(url, headers: headers, body: body);
      print('----------[service] decreaseReward----------');
      print('Response status: ${response.statusCode}');

      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Fail decreaseReward');
        return false;
      }
    } catch (e) {
      print('Error during decreaseReward: $e');
      return false;
    }
  }
}
