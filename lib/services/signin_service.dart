import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';

class SigninService {
  static Future<bool> signin(String email, String passwd) async {
    final url = Uri.parse(
        '${Secrets.awsKey}auth/signin/password?email=$email&password=$passwd');
    var headers = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url, headers: headers);
      print('----------sign in----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      //accessToken 저장시 에러 발생 -> 해결
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String accessToken = responseData['accessToken'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        print('AccessToken saved: $accessToken');
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
