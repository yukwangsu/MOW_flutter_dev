import 'package:flutter/material.dart';
import 'package:flutter_mow/models/character_model.dart';
import 'package:flutter_mow/services/character_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_free_width.dart';
import 'package:flutter_svg/svg.dart';

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
      TextEditingController(); // 캐릭터 이름 컨테이너

  @override
  void initState() {
    super.initState();

    // 포커스 풀리면 저장
    characterNameFocusNode.addListener(() {
      if (!characterNameFocusNode.hasFocus) {
        setState(() {
          // 저장하기

          // 다시 불러오기
          character = CharacterService.getCharacter();
        });
      }
    });

    character = CharacterService.getCharacter();
    characterComp = CharacterService.getCharacterComp();
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
                          height: 55.0,
                        ),
                        // 2. 상태 메시지
                        Column(
                          children: [
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
                              child: Text(
                                snapshot.data!.characterMessage,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: const Color.fromARGB(
                                            255, 155, 154, 154)),
                              ),
                            ),
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
                            const SizedBox(
                              height: 30.0,
                            )
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
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text('이미지 추가 예정'),
                        Text('characterComp : ${snapshot.data!.toString()}'),
                      ],
                    );
                  }
                },
              ),
              // 빈공간 최대(버튼을 화면 아래에 넣기 위해서)
              const Spacer(),
              // 4. 꾸미기 상점 버튼
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 31.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonFreeWidth(
                        text: '꾸미기 상점',
                        bgcolor: Colors.white,
                        textColor: Color(0xFF6B4D38),
                        borderColor: Color(0xFF6B4D38),
                        opacity: 1.0,
                        heightPadding: 11.0,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),

              // 5. 지도로 돌아가기 버튼
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 31.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonFreeWidth(
                        text: '지도로 돌아가기',
                        bgcolor: Color(0xFF6B4D38),
                        textColor: Colors.white,
                        borderColor: Color(0xFF6B4D38),
                        opacity: 1.0,
                        heightPadding: 11.0,
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
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.titleLarge,
      focusNode: characterNameFocusNode,
      cursorColor: Colors.black, // 커서 색상 설정
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        border: InputBorder.none, //테두리 없음
        isDense: true, // 컴팩트하게 설정
      ),
      // onTap: () {
      //   // // 텍스트 필드에 포커스가 갈 때마다 커서를 마지막으로 이동
      //   // controller.selection = TextSelection.fromPosition(
      //   //   TextPosition(offset: controller.text.length),
      //   // );
      // },
    );
  }
}
