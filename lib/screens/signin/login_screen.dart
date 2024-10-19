import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/map.dart';
import 'package:flutter_mow/screens/reset%20password/enter_email.dart';
import 'package:flutter_mow/screens/info/hi.dart';
import 'package:flutter_mow/screens/signup/agree.dart';
import 'package:flutter_mow/services/signin_service.dart';
import 'package:flutter_mow/services/signup_service.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/input_bottom.dart';
import 'package:flutter_mow/widgets/sub_text.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //아이디, 비밀번호 text controller 선언
  final TextEditingController idController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  late bool isIdWrong = false;

  idCorrect() {
    setState(() {
      isIdWrong = false;
    });
  }

  idWrong() {
    setState(() {
      isIdWrong = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  SvgPicture.asset('assets/icons/login_cat.svg'),
                  const SizedBox(
                    height: 30,
                  ),
                  InputBottom(
                    label: '아이디',
                    labelColor: const Color(0xFF6B4D38),
                    borderColor: const Color(0xFF6B4D38),
                    obscureText: false,
                    controller: idController,
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  InputBottom(
                    label: '비밀번호',
                    labelColor: const Color(0xFF6B4D38),
                    borderColor: const Color(0xFF6B4D38),
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //아이디, 비밀번호 오류시 에러 메세지
                  Row(
                    children: [
                      SubText(
                        text: '아이디 혹은 비밀번호가 맞지 않습니다.',
                        textColor:
                            isIdWrong ? const Color(0xFFFF2E2E) : Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //로그인 버튼
                  ButtonMain(
                    text: '로그인',
                    bgcolor: const Color(0xFF6B4D38),
                    textColor: Colors.white,
                    borderColor: const Color(0xFF6B4D38),
                    opacity: 1.0,
                    onPress: () async {
                      print('login id: ${idController.text}');
                      print('login pw: ${passwordController.text}');
                      // 아이디, 비밀번호 확인
                      bool success = await SigninService.signin(
                        idController.text,
                        passwordController.text,
                      );
                      //유효한 아이디와 비밀번호를 입력했는지 확인
                      if (success) {
                        idCorrect();
                        //사용자 정보를 입력했는지 안 했는지 확인
                        bool isDetailNull = await SigninService.checkDetails();
                        //context.mounted: mounted는 StatefulWidget의 State 객체가 위젯 트리에 연결(mounted)되어 있는지를 나타내는 속성이다.
                        //context.mounted는 현재의 BuildContext가 여전히 유효한 상태인지, 즉 State가 아직도 위젯 트리에 연결되어 있는지를 확인하는 데 사용된다.
                        if (!context.mounted) return;
                        //사용자 정보를 입력하지 않은 경우 입력화면으로 이동
                        if (isDetailNull) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoHi(
                                email: idController.text,
                                passwd: passwordController.text,
                              ),
                            ),
                          );
                          //사용자 정보를 입력한 경우 지도 화면으로 이동
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapScreen(),
                            ),
                          );
                        }
                      } else {
                        idWrong();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //추후 컴포넌트화 작업 필요
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //비밀번호 변경 버튼
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EnterEmail(),
                            ),
                          );
                        },
                        child: const Text(
                          '비밀번호를 잊었어요',
                          style: TextStyle(
                            color: Color(0xFFC3C3C3),
                            fontSize: 14,
                            fontFamily: 'SF_Pro',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      //경계선
                      Container(
                        width: 1,
                        height: 20,
                        color: const Color(0xFFD9D9D9),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      //회원가입 버튼
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpAgree(),
                            ),
                          );
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            color: Color(0xFFC3C3C3),
                            fontSize: 14,
                            fontFamily: 'SF_Pro',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Expanded: 최대로 키우기
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD9D9D9),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Text(
                          '소셜 로그인',
                          style: TextStyle(
                            color: Color(0xFFC3C3C3),
                            fontSize: 14,
                            fontFamily: 'SF_Pro',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD9D9D9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          SignupService.googleSignup();
                        },
                        child: Image.asset('assets/images/google.png'),
                      ),
                      const SizedBox(
                        width: 22,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset('assets/images/kakao.png'),
                      ),
                    ],
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
