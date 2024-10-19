import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/signup/set_passwd.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/sub_text.dart';
import 'package:flutter_mow/widgets/text_start.dart';
import 'package:flutter_mow/widgets/input_4digit.dart';
import 'package:flutter_svg/svg.dart';

class SignUpEnterCode extends StatefulWidget {
  final String email;
  final String authCode;

  const SignUpEnterCode({
    super.key,
    required this.email,
    required this.authCode,
  });

  @override
  State<SignUpEnterCode> createState() => _SignUpEnterCode();
}

class _SignUpEnterCode extends State<SignUpEnterCode> {
  final List<TextEditingController> digitControllers =
      List<TextEditingController>.generate(4, (_) => TextEditingController());

  late bool isCodeWrong = false;
  double buttonOpacity = 0.5;
  bool buttonWork = false;

  @override
  void initState() {
    super.initState();
    for (var controller in digitControllers) {
      controller.addListener(_checkDigitsFilled);
    }
  }

  @override
  void dispose() {
    for (var controller in digitControllers) {
      controller.removeListener(_checkDigitsFilled);
    }
    super.dispose();
  }

  void _checkDigitsFilled() {
    bool allFilled =
        digitControllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      buttonWork = true;
      setState(() {
        buttonOpacity = 1.0;
      });
    } else {
      buttonWork = false;
      setState(() {
        buttonOpacity = 0.5;
      });
    }
  }

  codeCorrect() {
    setState(() {
      isCodeWrong = false;
    });
  }

  codeWrong() {
    setState(() {
      isCodeWrong = true;
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
                text: '이메일로 전송된',
              ),
              const TextStart(
                text: '인증코드를 알려주세요!',
              ),
              const SizedBox(
                height: 60,
              ),
              Input4digit(
                digitControllers: digitControllers,
              ),
              //코드가 틀렸을 때 에러 메시지를 보여줌
              if (isCodeWrong) ...[
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset('assets/icons/check_wrong.svg'),
                      const SizedBox(
                        width: 9,
                      ),
                      const SubText(
                        text: '인증코드가 일치하지 않아요',
                        textColor: Color(0xFFC3C3C3),
                      ),
                    ],
                  ),
                ),
              ],
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
                  onPress: () async {
                    if (buttonWork) {
                      String code = '';
                      for (var controller in digitControllers) {
                        code += controller.text;
                      }
                      //인증코드가 맞는지 확인
                      if (code == widget.authCode) {
                        codeCorrect();
                        print('input code is $code');
                        print('auth code is ${widget.authCode}');
                        print('info[email: ${widget.email}]');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpSetPw(
                              email: widget.email,
                            ),
                          ),
                        );
                      } else {
                        codeWrong();
                      }
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
