import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mow/secrets.dart';

class SearchService {
  static Future<List?> searchPlace(
    String keyword,
    int order,
    String locationType,
    List<String> appliedSearchTags,
  ) async {
    final url =
        Uri.parse('${Secrets.awsKey}workspace?order=$order&page=0&size=20');
    var headers = {
      'Content-Type': 'application/json',
    };
    // 태그 변수 map
    Map<String, int> tagMap = {
      '# 공간이 넓어요': 1,
      '# 좌석이 많아요': 2,
      '# 콘센트가 많아요': 3,
      '# 한산해요': 4,
      '# 의자가 편해요': 5,
      '# 책상이 넓어요': 6,
      '# 뷰가 좋아요': 7,
      '# 조용해요': 8,
      '# 아늑해요': 9,
      '# 인테리어가 깔끔해요': 10,
      '# 어두워요': 11,
      '# 밝아요': 12,
      '# 다시 오고 싶어요': 13,
      '# 음악이 좋아요': 14,
      '# 대화하기 좋아요': 15,
      '# 감각적이에요': 16,
      '# 혼자 작업하기 좋아요': 17,
      '# 회의하기에 좋아요': 18,
      '# 저렴해요': 19,
      '# 매뉴가 다양해요': 20,
      '# 커피가 맛있어요': 21,
      '# 디저트가 맛있어요': 22,
      '# 친절해요': 23,
      '# 와이파이가 잘 터져요': 24,
      '# 에어컨이 잘 나와요': 25,
      '# 오래 작업하기 좋아요': 26,
      '# 화장실이 깨끗해요': 27,
      '# 찾아가기 편해요': 28,
      '# 무료로 이용이 가능해요': 29,
      '# 주차가 가능해요': 30,
      '# 24시간 운영이에요': 31
    };
    List<int> tagNumbers =
        appliedSearchTags.map((tag) => tagMap[tag]!).toList();

    var data = (locationType.isEmpty || locationType == '모든 공간')
        ? {
            "keyword": keyword,
            "featureYnList": tagNumbers,
          }
        : {
            "keyword": keyword,
            "workspaceType": [locationType],
            "featureYnList": tagNumbers,
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
}
