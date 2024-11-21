import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/add_review.dart';
import 'package:flutter_mow/screens/signin/login_screen.dart';
import 'package:flutter_mow/services/delete_account.dart';
import 'package:flutter_mow/services/signout_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_free_width.dart';
import 'package:flutter_svg/svg.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({
    super.key,
  });

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  void initState() {
    super.initState();
  }

  // 취소 버튼을 눌렀을 때
  void onClickCancelButtonHandler() {
    setState(() {
      // 이전화면으로 돌아가면서 데이터를 전달
      Navigator.of(context).pop(false);
    });
  }

  // 로그아웃 버튼을 눌렀을 때
  void onClickLogoutButtonHandler() {
    setState(() {
      SignoutService.signout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // 이동할 화면
        (Route<dynamic> route) => false, // 이전 모든 화면 제거
      );
    });
  }

  // 회원탈퇴 버튼을 눌렀을 때
  void onClickDeleteAccountButtonHandler() {
    setState(() {
      DeleteAccount.deleteAccount();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // 이동할 화면
        (Route<dynamic> route) => false, // 이전 모든 화면 제거
      );
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
              height: 50.0,
            ),
            // 로그아웃
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        // shape를 사용해서 BorderRadius 설정.
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) {
                          return Container(
                            height: 298.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 33.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 40.0,
                                ),
                                SvgPicture.asset(
                                    'assets/icons/warning_icon.svg'),
                                const SizedBox(
                                  height: 22.0,
                                ),
                                Text(
                                  '로그아웃 하시겠어요?',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 55.0,
                                ),
                                // 버튼
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          onClickCancelButtonHandler();
                                        },
                                        child: const ButtonFreeWidth(
                                          text: '취소',
                                          bgcolor: Colors.white,
                                          textColor: Color(0xFF6B4D38),
                                          borderColor: Color(0xFF6B4D38),
                                          opacity: 1.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 11.0,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          onClickLogoutButtonHandler();
                                        },
                                        child: const ButtonFreeWidth(
                                          text: '로그아웃',
                                          bgcolor: Color(0xFF6B4D38),
                                          textColor: Colors.white,
                                          borderColor: Color(0xFF6B4D38),
                                          opacity: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '로그아웃',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: const Color(0xFFF34747)),
                        ),
                        SvgPicture.asset(
                          'assets/icons/arrow_right_icon.svg',
                          color: const Color(0xFFF34747),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  // 회원탈퇴
                  GestureDetector(
                    behavior: HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        // shape를 사용해서 BorderRadius 설정.
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) {
                          return Container(
                            height: 329.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 33.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 40.0,
                                ),
                                SvgPicture.asset(
                                    'assets/icons/warning_icon.svg'),
                                const SizedBox(
                                  height: 22.0,
                                ),
                                Text(
                                  '회원탈퇴',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  '삭제된 데이터는 복구가 불가능합니다.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: const Color(0xFF8D8D8D)),
                                ),
                                const SizedBox(
                                  height: 55.0,
                                ),
                                // 버튼
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          onClickCancelButtonHandler();
                                        },
                                        child: const ButtonFreeWidth(
                                          text: '취소',
                                          bgcolor: Colors.white,
                                          textColor: Color(0xFF6B4D38),
                                          borderColor: Color(0xFF6B4D38),
                                          opacity: 1.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 11.0,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          onClickDeleteAccountButtonHandler();
                                        },
                                        child: const ButtonFreeWidth(
                                          text: '탈퇴하기',
                                          bgcolor: Color(0xFF6B4D38),
                                          textColor: Colors.white,
                                          borderColor: Color(0xFF6B4D38),
                                          opacity: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '회원탈퇴',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SvgPicture.asset('assets/icons/arrow_right_icon.svg'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
