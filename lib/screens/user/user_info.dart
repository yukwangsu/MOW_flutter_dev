import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/add_review.dart';
import 'package:flutter_mow/screens/user/user_account.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_svg/svg.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({
    super.key,
  });

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  void initState() {
    super.initState();
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
              onTap: () {},
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
                            '사용자 님의',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '캐릭터 이름',
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
            // 내 저장 장소
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 60.0,
                child: Row(
                  children: [
                    SvgPicture.asset(
                        'assets/icons/user_info_my_place_icon.svg'),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '내 저장 장소',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            // 좋아요 한 큐레이션
            GestureDetector(
              onTap: () {},
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
            // 내가 쓴 큐레이션
            GestureDetector(
              onTap: () {},
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
