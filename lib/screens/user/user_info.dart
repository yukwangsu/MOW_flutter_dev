import 'package:flutter/material.dart';
import 'package:flutter_mow/models/character_model.dart';
import 'package:flutter_mow/screens/map/add_review.dart';
import 'package:flutter_mow/screens/user/character.dart';
import 'package:flutter_mow/screens/user/like_curation.dart';
import 'package:flutter_mow/screens/user/my_curation.dart';
import 'package:flutter_mow/screens/user/user_account.dart';
import 'package:flutter_mow/services/character_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({
    super.key,
  });

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String userName = ""; // 유저 닉네임 저장하는 변수
  String characterName = ""; // 캐릭터 이름을 저장하는 변수
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    // 유저 닉네임 불러오기
    getUserName();
    // 캐릭터 이름 불러오기
    getCharacterName();
  }

  void getUserName() async {
    prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userNickname')!;
    setState(() {});
  }

  void getCharacterName() async {
    CharacterModel character = await CharacterService.getCharacter();
    setState(() {
      characterName = character.characterDetail;
    });
  }

  void onClickCharacterSetting() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Character(),
      ),
    ).then((_) {
      getCharacterName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            // 사용자 정보, 캐릭터
            GestureDetector(
              behavior: HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
              onTap: () {
                // 캐릭터 꾸미기 화면으로 이동
                onClickCharacterSetting();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                          'assets/icons/user_info_character_icon.svg'),
                      const SizedBox(
                        width: 14.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$userName 님의',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            characterName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      )
                    ],
                  ),
                  SvgPicture.asset('assets/icons/arrow_right.svg')
                ],
              ),
            ),
            const SizedBox(
              height: 28.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: ListBorderLine(),
            ),
            const SizedBox(
              height: 14.0,
            ),
            // // 1. 내 저장 장소
            // Opacity(
            //   opacity: 0.3,
            //   child: GestureDetector(
            //     onTap: () {},
            //     child: SizedBox(
            //       height: 60.0,
            //       child: Row(
            //         children: [
            //           SvgPicture.asset(
            //               'assets/icons/user_info_my_place_icon.svg'),
            //           const SizedBox(
            //             width: 10.0,
            //           ),
            //           Text(
            //             '내 저장 장소',
            //             style: Theme.of(context).textTheme.bodyLarge,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // 2. 좋아요 한 큐레이션
            Opacity(
              opacity: 1.0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LikeCuration(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 60.0,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                          'assets/icons/user_info_like_curation_icon.svg'),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '좋아요 한 큐레이션',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 3. 내가 쓴 큐레이션
            Opacity(
              opacity: 1.0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyCuration(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 60.0,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                          'assets/icons/user_info_my_curation_icon.svg'),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '내가 쓴 큐레이션',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: ListBorderLine(),
            ),
            const SizedBox(
              height: 40.0,
            ),
            // 계정 정보
            GestureDetector(
              behavior: HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserAccount(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '계정 정보',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SvgPicture.asset('assets/icons/arrow_right_icon.svg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
