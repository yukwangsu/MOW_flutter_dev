import 'package:http/http.dart' as http;
import 'package:flutter_mow/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccount {
  static Future<bool> deleteAccount() async {
    final url = Uri.parse('${Secrets.awsKey}auth/delete/account');

    //토큰 가져오기
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    var headers = {
      'accessToken': '$token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url, headers: headers);
      print('----------deleteAccount----------');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during deleteAccount: $e');
      return false;
    }
  }
}
