import 'dart:convert';

class CurationPageModel {
  final String userNickname, curationTitle, text;
  final int curationId, workspaceId, userId, likes;
  final List<String> featureTagsList;
  final DateTime createdAt, updatedAt;
  final List<CurationReviewModel> reviews; // CurationReviewModel 리스트로 수정

  CurationPageModel.fromJson(Map<dynamic, dynamic> json)
      : userNickname = json['userNickname'] ?? '',
        curationTitle = json['curationTitle'] ?? '',
        text = json['text'] ?? '',
        curationId = json['curationId'] ?? 0,
        workspaceId = json['workspaceId'] ?? 0,
        userId = json['userId'] ?? 0,
        likes = json['likes'] ?? 0,
        //featureTags String을 List<int>로 바꾼 뒤 Map을 통해 List<String>으로 변환
        featureTagsList = json['featureTags']
            .split(',')
            .map(int.parse)
            .toList()
            .map((tag) => tagMap[tag])
            .toList(),
        // 각 리뷰 데이터를 CurationReviewModel로 변환하여 리스트로 저장
        reviews = (json['curationCommentDtoList'] != null)
            ? List<CurationReviewModel>.from(json['curationCommentDtoList']
                .map((reviewJson) => CurationReviewModel.fromJson(reviewJson)))
            : [],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']);
}

class CurationReviewModel {
  final int curationId, commenterId;
  final String userNickname, comment;
  final DateTime createdAt;

  CurationReviewModel.fromJson(Map<dynamic, dynamic> json)
      : curationId = json['curationId'] ?? 0,
        commenterId = json['commenterId'] ?? 0,
        userNickname = json['userNickname'] ?? '',
        comment = json['comment'] ?? '',
        createdAt = DateTime.parse(json['createdAt']);
}

Map<int, String> tagMap = {
  1: '감성적인',
  2: '자연적인',
  3: '모던한',
  4: '차분한',
  5: '빈티지',
  6: '커피 맛집',
  7: '디저트 맛집',
  8: '한적한',
  9: '아기자기한',
  10: '아늑한',
  11: '재미있는',
  12: '웨커이션',
  13: '작업하기 좋은',
  14: '볼거리가 많은',
};
