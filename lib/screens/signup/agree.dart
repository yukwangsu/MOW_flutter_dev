import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/signup/set_id.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/text_start.dart';
import 'package:flutter_svg/svg.dart';

class SignUpAgree extends StatefulWidget {
  const SignUpAgree({super.key});

  @override
  State<SignUpAgree> createState() => _SignUpAgreeState();
}

class _SignUpAgreeState extends State<SignUpAgree> {
  late bool allOk;
  late bool con1;
  late bool con2;
  double buttonOpacity = 0.5;
  bool bottonWork = false;

  @override
  void initState() {
    super.initState();
    allOk = false;
    con1 = false;
    con2 = false;
  }

  setAllOk() {
    setState(() {
      if (allOk) {
        allOk = false;
        con1 = false;
        con2 = false;
        bottonWork = false;
        buttonOpacity = 0.5;
      } else {
        allOk = true;
        con1 = true;
        con2 = true;
        bottonWork = true;
        buttonOpacity = 1.0;
      }
    });
  }

  clickCon1() {
    setState(() {
      con1 = !con1;
      if (con1 && con2) {
        setAllOk();
      } else if (!con1 && con2) {
        allOk = false;
        bottonWork = false;
        buttonOpacity = 0.5;
      }
    });
  }

  clickCon2() {
    setState(() {
      con2 = !con2;
      if (con1 && con2) {
        setAllOk();
      } else if (con1 && !con2) {
        allOk = false;
        bottonWork = false;
        buttonOpacity = 0.5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      resizeToAvoidBottomInset: false, //키보드가 올라와도 화면이 그대로 유지
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              const TextStart(
                text: 'MOW 서비스 이용약관에',
              ),
              const TextStart(
                text: '동의해주세요.',
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Column(
                  children: [
                    //모두 동의
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setAllOk();
                          },
                          child: SvgPicture.asset(allOk
                              ? 'assets/icons/select_box.svg'
                              : 'assets/icons/unselect_box.svg'),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          '모두 동의',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF_Pro',
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    //구분선
                    Container(
                      width: double.infinity, // width를 최대화
                      height: 1,
                      color: const Color(0xFFE4E3E2),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    //필수약관 동의
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            clickCon1();
                          },
                          child: SvgPicture.asset(con1
                              ? 'assets/icons/check_box.svg'
                              : 'assets/icons/uncheck_box.svg'),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          '[필수] 필수약관 동의',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF_Pro',
                            letterSpacing: -0.23, // 자간을 -0.23px로 설정
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            // 추후 notion 연결 필요1
                            print('텍스트가 클릭되었습니다.1');
                          },
                          child: const Text(
                            '보기',
                            style: TextStyle(
                              color: Color(0xFFC3C3C3),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF_Pro',
                              letterSpacing: -0.23,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    //개인정보 처리방침 동의
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            clickCon2();
                          },
                          child: SvgPicture.asset(con2
                              ? 'assets/icons/check_box.svg'
                              : 'assets/icons/uncheck_box.svg'),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          '[필수] 개인정보 처리방침 동의',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF_Pro',
                            letterSpacing: -0.23, // 자간을 -0.23px로 설정
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            // 추후 notion 연결 필요2
                            print('텍스트가 클릭되었습니다.2');
                          },
                          child: const Text(
                            '보기',
                            style: TextStyle(
                              color: Color(0xFFC3C3C3),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF_Pro',
                              letterSpacing: -0.23,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              children: [
                ButtonMain(
                  text: '다음',
                  bgcolor: Colors.white,
                  textColor: const Color(0xFF6B4D38),
                  borderColor: const Color(0xFF6B4D38),
                  opacity: buttonOpacity,
                  onPress: () {
                    if (bottonWork) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpSetId(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 68,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
