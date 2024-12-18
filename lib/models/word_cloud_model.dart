class WordCloudModel {
  final int workspaceId;
  final Map<String, dynamic> tagCount;

  WordCloudModel.fromJson(Map<dynamic, dynamic> json)
      : workspaceId = json['workspaceId'] ?? 0,
        tagCount = json['tagCount'] ?? {};
}
