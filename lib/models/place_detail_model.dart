import 'dart:convert';

class PlaceDetailModel {
  final String workspaceName,
      workspaceThumbnailUrl,
      workspaceType,
      location,
      phoneNumber,
      spaceUrl,
      description,
      featureTags;
  final double starscore;
  final int workspaceId, reviewCnt, workspaceStatus;
  final Map<String, String> workspaceOperationTime; // Map으로 변경
  final List<ReviewModel> reviews; // ReviewModel 리스트로 수정
  final List photos;

  PlaceDetailModel.fromJson(Map<dynamic, dynamic> json)
      : workspaceName = json['workspaceName'] ?? '',
        workspaceThumbnailUrl = json['workspaceThumbnailUrl'] ?? '',
        workspaceType = json['workspaceType'] ?? '',
        location = json['location'] ?? '',
        phoneNumber = json['phoneNumber'] ?? '',
        spaceUrl = json['spaceUrl'] ?? '',
        description = json['description'] ?? '',
        featureTags = json['featureTags'] ?? '',
        starscore =
            (json['starscore'] != null) ? json['starscore'].toDouble() : 0.0,
        workspaceId = json['workspaceId'] ?? 0,
        reviewCnt = json['reviewCnt'] ?? 0,
        workspaceStatus = json['workspaceStatus'] ?? 0,
        workspaceOperationTime = (json['workspaceOperationTime'] != null)
            ? Map<String, String>.from(
                jsonDecode(json['workspaceOperationTime']))
            : {},
        // 각 리뷰 데이터를 ReviewModel로 변환하여 리스트로 저장
        reviews = (json['reviews'] != null)
            ? List<ReviewModel>.from(json['reviews']
                .map((reviewJson) => ReviewModel.fromJson(reviewJson)))
            : [],
        photos = (json['photos'] != null) ? List.from(json['photos']) : [];
}

class ReviewModel {
  final int workspaceId, userId;
  final double stars;
  final String userNickname, reviewText, featureTags;
  final DateTime createdAt;

  ReviewModel.fromJson(Map<dynamic, dynamic> json)
      : workspaceId = json['workspaceId'] ?? 0,
        userId = json['userId'] ?? 0,
        stars = (json['stars'] != null) ? json['stars'].toDouble() : 0.0,
        reviewText = json['reviewText'] ?? '',
        featureTags = json['featureTags'] ?? '',
        userNickname = json['userNickname'] ?? '',
        // 'createdAt'을 DateTime 형태로 변환
        createdAt = DateTime(
          json['createdAt'][0],
          json['createdAt'][1],
          json['createdAt'][2],
          json['createdAt'][3],
          json['createdAt'][4],
          json['createdAt'][5],
          json['createdAt'][6] ~/ 1000000, // 나노초를 마이크로초로 변환
        );
}
