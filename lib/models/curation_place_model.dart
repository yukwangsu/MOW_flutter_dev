class CurationPlaceModel {
  final int totItemCnt, totPageCnt, currentPage;
  final List<CurationPlaceDtoModel> curationPlaceList;

  CurationPlaceModel.fromJson(Map<dynamic, dynamic> json)
      : totItemCnt = json['totItemCnt'] ?? 0,
        totPageCnt = json['totPageCnt'] ?? 0,
        currentPage = json['currentPage'] ?? 0,
        curationPlaceList = (json['simpleCurationDtoList'] != null)
            ? List<CurationPlaceDtoModel>.from(json['simpleCurationDtoList']
                .map((curationJson) =>
                    CurationPlaceDtoModel.fromJson(curationJson)))
            : [];
}

class CurationPlaceDtoModel {
  final int curationId, workspaceId, userId, likes;
  final String userNickname,
      workSpaceName,
      location,
      curationTitle,
      featureTags,
      curationPhoto;

  CurationPlaceDtoModel.fromJson(Map<dynamic, dynamic> json)
      : curationId = json['curationId'] ?? 0,
        workspaceId = json['workspaceId'] ?? 0,
        userId = json['userId'] ?? 0,
        likes = json['likes'] ?? 0,
        userNickname = json['userNickname'] ?? '',
        workSpaceName = json['workSpaceName'] ?? '',
        location = json['location'] ?? '',
        curationTitle = json['curationTitle'] ?? '',
        featureTags = json['featureTags'] ?? '',
        curationPhoto = json['curationPhoto'] ?? 'no image';
}
