class ImageModel {
  final String preSignedUrl, key, permanentUrl;

  ImageModel.fromJson(Map<dynamic, dynamic> json)
      : preSignedUrl = json['preSignedUrl'] ?? '',
        key = json['key'] ?? '',
        permanentUrl = json['permanentUrl'] ?? '';
}
