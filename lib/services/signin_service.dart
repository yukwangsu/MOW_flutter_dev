import 'package:flutter_mow/services/signout_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';

class SigninService {
  static Future<bool> signin(String email, String passwd) async {
    // 로그인 시도시 로그아웃 먼저 진행
    bool isLogout = await SignoutService.signout();
    if (isLogout) {
      print('기존에 로그인 되어 있어서 로그아웃 되었습니다.');
    } else {
      print('기존에 로그인 되지 않아서 로그아웃 불필요. 혹은 로그아웃 실패.');
    }

    print('입력 이메일: $email  비밀번호: $passwd');

    final url = Uri.parse(
        '${Secrets.awsKey}auth/signin/password?email=$email&password=$passwd');

    var headers = {
      'accessToken': 'null', //처음 로그인한 유저라면 값이 null
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url, headers: headers);
      print('----------sign in----------');
      print('Response status: ${response.statusCode}');
      // UTF-8로 응답을 수동 디코딩
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Response body: $utf8Body');
      // print('Response body: ${response.body}');

      //accessToken 저장시 에러 발생 -> 해결
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = json.decode(utf8Body);
        //accessToken 저장
        final prefs = await SharedPreferences.getInstance();
        String accessToken = responseData['accessToken'];
        await prefs.setString('accessToken', accessToken);
        print('AccessToken saved: $accessToken');
        //유저 닉네임 저장
        String userNickname = responseData['userNickname'];
        await prefs.setString('userNickname', userNickname);
        // // userId 저장X
        // int userId = responseData['userId'];
        // await prefs.setInt('userId', userId);
        // print('userId saved: $userId');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during sign in: $e');
      return false;
    }
  }

  static Future<bool> checkDetails() async {
    final url = Uri.parse('${Secrets.awsKey}auth/check/datails');
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    print('*****token: $token*****');
    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(url, headers: headers);
      print('----------check details----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        bool isDetailsNull = responseData['isDetailsNull'];
        return isDetailsNull;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during check details: $e');
      return false;
    }
  }
}
