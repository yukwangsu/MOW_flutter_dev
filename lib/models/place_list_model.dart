class PlaceListModel {
  final int totItemCnt, totPageCnt, currentPage;
  final List<WorkspaceDtoModel> workspaceDtoList;

  PlaceListModel.fromJson(Map<dynamic, dynamic> json)
      : totItemCnt = json['totItemCnt'] ?? 0,
        totPageCnt = json['totPageCnt'] ?? 0,
        currentPage = json['currentPage'] ?? 0,
        workspaceDtoList = (json['workspaceDtoList'] != null)
            ? List<WorkspaceDtoModel>.from(json['workspaceDtoList'].map(
                (curationJson) => WorkspaceDtoModel.fromJson(curationJson)))
            : [];
}

class WorkspaceDtoModel {
  final int workspaceId, reviewCnt, widenessDegree, outletDegree, chairDegree;
  final double starscore,
      distance,
      userLatitude,
      userLongitude,
      workspaceLatitude,
      workspaceLongitude;
  final String workspaceName,
      workspaceThumbnailUrl,
      workspaceType,
      location,
      phoneNumber,
      spaceUrl,
      featureTags;

  WorkspaceDtoModel.fromJson(Map<dynamic, dynamic> json)
      : workspaceId = json['workspaceId'] ?? 0,
        starscore = json['starscore'] ?? 0.0,
        reviewCnt = json['reviewCnt'] ?? 0,
        distance = json['distance'] ?? 0.0,
        userLatitude = json['userLatitude'] ?? 0,
        userLongitude = json['userLongitude'] ?? 0,
        workspaceLatitude = json['workspaceLatitude'] ?? 0,
        workspaceLongitude = json['workspaceLongitude'] ?? 0,
        widenessDegree = json['widenessDegree'] ?? 0,
        outletDegree = json['outletDegree'] ?? 0,
        chairDegree = json['chairDegree'] ?? 0,
        workspaceName = json['workspaceName'] ?? '',
        workspaceThumbnailUrl = json['workspaceThumbnailUrl'] ?? '',
        workspaceType = json['workspaceType'] ?? '',
        location = json['location'] ?? '',
        phoneNumber = json['phoneNumber'] ?? '',
        spaceUrl = json['spaceUrl'] ?? '',
        featureTags = json['featureTags'] ?? '';
}
