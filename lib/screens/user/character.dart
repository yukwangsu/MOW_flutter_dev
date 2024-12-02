import 'package:flutter/material.dart';
import 'package:flutter_mow/models/character_model.dart';
import 'package:flutter_mow/screens/user/character_shop.dart';
import 'package:flutter_mow/services/character_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_free_width.dart';

class Character extends StatefulWidget {
  const Character({
    super.key,
  });

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  FocusNode characterNameFocusNode = FocusNode();
  FocusNode characterMessageFocusNode = FocusNode();
  late Future<CharacterModel> character;
  late Future<int> characterComp;
  final TextEditingController characterNameController =
      TextEditingController(); // 캐릭터 이름 컨트롤러
  final TextEditingController characterMessageController =
      TextEditingController(); // 캐릭터 메시지 컨트롤러

  @override
  void initState() {
    super.initState();

    // 캐릭터 이름 포커스 풀리면 저장
    characterNameFocusNode.addListener(() async {
      if (!characterNameFocusNode.hasFocus) {
        // 변경한 이름, 메시지가 비어있지 않은지 확인
        if (characterNameController.text.isNotEmpty &&
            characterMessageController.text.isNotEmpty) {
          setState(() {
            // 변경된 정보 수정하고 다시 불러오기
            character = CharacterService.editCharacterInfo(
                characterNameController.text, characterMessageController.text);
          });
        }
      }
    });

    // 캐릭터 메시지 포커스 풀리면 저장
    characterMessageFocusNode.addListener(() async {
      if (!characterMessageFocusNode.hasFocus) {
        // 변경한 이름, 메시지가 비어있지 않은지 확인
        if (characterNameController.text.isNotEmpty &&
            characterMessageController.text.isNotEmpty) {
          setState(() {
            // 변경된 정보 수정하고 다시 불러오기
            character = CharacterService.editCharacterInfo(
                characterNameController.text, characterMessageController.text);
          });
        }
      }
    });

    character = CharacterService.getCharacter();
    characterComp = CharacterService.getCharacterComp();
  }

  // 캐릭터 상점으로 가는 버튼을 눌렀을 때
  void onClickCharacterShopButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CharacterShop(),
      ),
    );
  }

  // 지도로 돌아가는 버튼을 눌렀을 때
  void onClickBackToMapButton() {
    // pop을 두번 함으로써 지도화면으로 돌아감
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 화면 그대로
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: GestureDetector(
        // 빈공간을 터치해도 인식
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 화면의 다른 곳을 터치할 때 포커스 해제
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 24.0,
              ),
              FutureBuilder<CharacterModel>(
                future: character, // 비동기 데이터 호출
                builder: (BuildContext context,
                    AsyncSnapshot<CharacterModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 데이터가 로드 중일 때 로딩 표시
                    return const Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('캐릭터 정보를 불러오는 중입니다...'),
                            CircularProgressIndicator(
                              color: Color(0xFFAD7541),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    // 오류가 발생했을 때
                    return Text('Error: ${snapshot.error} 캐릭터 로딩 실패');
                  } else {
                    // 데이터가 성공적으로 로드되었을 때
                    return Column(
                      children: [
                        // 1. 캐릭터 이름
                        //  Text(
                        //       snapshot.data!.characterDetail,
                        //       style: Theme.of(context).textTheme.titleLarge,
                        //     ),
                        characterNameInput(
                          characterNameController,
                          snapshot.data!.characterDetail,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        // 2. 상태 메시지
                        Column(
                          children: [
                            // 말풍선
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 19.0,
                                vertical: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: characterMessageInput(
                                  characterMessageController,
                                  snapshot.data!.characterMessage),
                            ),
                            // 말풍선 동그라미 1
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 60.0),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                decoration: BoxDecoration(
                                  color: Colors.white, // 하얀색
                                  shape: BoxShape.circle, // 동그라미 모양
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.15), // 그림자 색상
                                      spreadRadius: 1, // 그림자 퍼짐 반경
                                      blurRadius: 5, // 그림자 흐림 정도
                                      offset:
                                          const Offset(2, 2), // 그림자의 위치 (x, y)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // 말풍선 동그라미 2
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, left: 15.0),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: Colors.white, // 하얀색
                                  shape: BoxShape.circle, // 동그라미 모양
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.15), // 그림자 색상
                                      spreadRadius: 1, // 그림자 퍼짐 반경
                                      blurRadius: 5, // 그림자 흐림 정도
                                      offset:
                                          const Offset(2, 2), // 그림자의 위치 (x, y)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              ),

              // 3. 캐릭터
              FutureBuilder<int>(
                future: characterComp, // 비동기 데이터 호출
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 데이터가 로드 중일 때 로딩 표시
                    return const SizedBox(height: 308.0);
                  } else if (snapshot.hasError) {
                    // 오류가 발생했을 때
                    return Text('Error: ${snapshot.error} 캐릭터 이미지 로딩 실패');
                  } else {
                    // 데이터가 성공적으로 로드되었을 때
                    // 추후 이미지 고르는 로직 추가
                    final characterImage = snapshot.data!;
                    return Column(
                      children: [
                        // const Text('이미지 추가 예정'),
                        // Text('characterComp : ${snapshot.data!.toString()}'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Image.asset(
                              'assets/images/character/$characterImage.png'),
                        )
                      ],
                    );
                  }
                },
              ),
              // 빈공간 최대(버튼을 화면 아래에 넣기 위해서)
              const Spacer(),
              // 4. 꾸미기 상점 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onClickCharacterShopButton();
                        },
                        child: const ButtonFreeWidth(
                          text: '꾸미기 상점',
                          bgcolor: Colors.white,
                          textColor: Color(0xFF6B4D38),
                          borderColor: Color(0xFF6B4D38),
                          opacity: 1.0,
                          heightPadding: 11.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),

              // 5. 지도로 돌아가기 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onClickBackToMapButton();
                        },
                        child: const ButtonFreeWidth(
                          text: '지도로 돌아가기',
                          bgcolor: Color(0xFF6B4D38),
                          textColor: Colors.white,
                          borderColor: Color(0xFF6B4D38),
                          opacity: 1.0,
                          heightPadding: 11.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 56.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 캐릭터 이름 입력칸
  Widget characterNameInput(TextEditingController controller, String name) {
    controller.text = name;
    // IntrinsicWidth를 사용하면 TextField내부에 적힌 text의 길이에 맞게 width가 설정된다.
    return IntrinsicWidth(
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.titleLarge,
        focusNode: characterNameFocusNode,
        cursorColor: Colors.black, // 커서 색상 설정
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none, //테두리 없음
          isDense: true, // 컴팩트하게 설정
        ),
      ),
    );
  }

  // 캐릭터 메시지 입력칸
  Widget characterMessageInput(
      TextEditingController controller, String message) {
    controller.text = message;
    // IntrinsicWidth를 사용하면 TextField내부에 적힌 text의 길이에 맞게 width가 설정된다.
    return IntrinsicWidth(
      child: TextField(
        controller: controller,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: const Color.fromARGB(255, 155, 154, 154)),
        focusNode: characterMessageFocusNode,
        cursorColor: Colors.black, // 커서 색상 설정
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none, //테두리 없음
          isDense: true, // 컴팩트하게 설정
        ),
      ),
    );
  }
}
