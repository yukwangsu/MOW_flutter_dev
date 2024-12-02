class CharacterModel {
  final int characterType;
  final String characterDetail, characterMessage;

  CharacterModel.fromJson(Map<dynamic, dynamic> json)
      : characterType = json['characterType'] ?? 0,
        characterDetail = json['characterDetail'] ?? '캐릭터 이름(미정)',
        characterMessage = json['characterMessage'] ?? '어디 좋은 카페 없나..';
}
