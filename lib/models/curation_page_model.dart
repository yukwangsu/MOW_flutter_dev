class CurationPageModel {
  final String userNickname, curationTitle, text;
  final int curationId, workspaceId, userId, likes;
  final List<String> featureTagsList;
  final DateTime createdAt;
  final List<String> imageList;
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
        // as String 을 추가해서 type 'List<dynamic>' is not a subtype of type 'List<String>' 오류 해결
        featureTagsList = (json['featureTags'] as String)
            .split(',')
            .map((tag) => tagMap[int.tryParse(tag) ?? 0] ?? '알 수 없음')
            .toList(),
//이미지 리스트 만들기
        imageList = makeImageList([
          json['curationPhoto'],
          json['curationPhoto2'],
          json['curationPhoto3'],
          json['curationPhoto4'],
          json['curationPhoto5'],
          json['curationPhoto6'],
          json['curationPhoto7'],
          json['curationPhoto8'],
          json['curationPhoto9'],
          json['curationPhoto10']
        ]),

        // 각 리뷰 데이터를 CurationReviewModel로 변환하여 리스트로 저장
        reviews = (json['curationCommentDtoList'] != null)
            ? List<CurationReviewModel>.from(json['curationCommentDtoList']
                .map((reviewJson) => CurationReviewModel.fromJson(reviewJson)))
            : [],
        createdAt = DateTime(
            json['createdAt'].length > 0 ? json['createdAt'][0] : 2024,
            json['createdAt'].length > 1 ? json['createdAt'][1] : 1,
            json['createdAt'].length > 2 ? json['createdAt'][2] : 1,
            json['createdAt'].length > 3 ? json['createdAt'][3] : 0,
            json['createdAt'].length > 4 ? json['createdAt'][4] : 0,
            json['createdAt'].length > 5 ? json['createdAt'][5] : 0);
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
        createdAt = DateTime(
            json['createdAt'].length > 0 ? json['createdAt'][0] : 2024,
            json['createdAt'].length > 1 ? json['createdAt'][1] : 1,
            json['createdAt'].length > 2 ? json['createdAt'][2] : 1,
            json['createdAt'].length > 3 ? json['createdAt'][3] : 0,
            json['createdAt'].length > 4 ? json['createdAt'][4] : 0,
            json['createdAt'].length > 5 ? json['createdAt'][5] : 0);
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

List<String> makeImageList(List<String> images) {
  List<String> result = [];
  for (int i = 0; i < images.length; i++) {
    if (images[i].split('.')[0] == 'https://mowimageurlbucket') {
      result.add(images[i]);
    }
  }
  return result;
}
