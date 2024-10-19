import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/reset%20password/enter_code.dart';
import 'package:flutter_mow/services/signup_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/sub_text.dart';
import 'package:flutter_mow/widgets/text_start.dart';
import 'package:flutter_mow/widgets/input_text.dart';

class EnterEmail extends StatefulWidget {
  const EnterEmail({super.key});

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  final TextEditingController idController = TextEditingController();

  bool isEmailNull = false;
  double buttonOpacity = 0.5;
  bool bottonWork = false;

  @override
  void initState() {
    super.initState();
    idController.addListener(_checkEmailInput);
  }

  @override
  void dispose() {
    idController.removeListener(_checkEmailInput);
    idController.dispose();
    super.dispose();
  }

  void _checkEmailInput() {
    if (idController.text.contains('@')) {
      bottonWork = true;
      setState(() {
        buttonOpacity = 1.0;
      });
    } else {
      bottonWork = false;
      setState(() {
        buttonOpacity = 0.5;
      });
    }
  }

  emailExisted() {
    setState(() {
      isEmailNull = false;
    });
  }

  emailNotExisted() {
    setState(() {
      isEmailNull = true;
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
                text: '가입시 사용한',
              ),
              const TextStart(
                text: '이메일을 입력해주세요.',
              ),
              const SizedBox(
                height: 60,
              ),
              InputText(
                label: '이메일 입력',
                labelColor: const Color(0xFFC3C3C3),
                borderColor: isEmailNull
                    ? const Color(0xFFFF2E2E)
                    : const Color(0xFFCCD1DD),
                obscureText: false,
                controller: idController,
              ),
              if (isEmailNull) ...[
                const Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 31,
                        ),
                        SubText(
                            text: '등록되지 않은 이메일입니다.',
                            textColor: Color(0xFFFF2E2E)),
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              children: [
                ButtonMain(
                  text: '인증코드 받기',
                  bgcolor: Colors.white,
                  textColor: const Color(0xFF6B4D38),
                  borderColor: const Color(0xFF6B4D38),
                  opacity: buttonOpacity,
                  onPress: () async {
                    if (bottonWork) {
                      bool isEmailNull = await SignupService.checkEmail(
                        idController.text,
                      );
                      if (!isEmailNull) {
                        emailExisted();
                        print('send email to ${idController.text}');
                        String authCode = await SignupService.sendEmail(
                          idController.text,
                        );
                        //context.mounted: mounted는 StatefulWidget의 State 객체가 위젯 트리에 연결(mounted)되어 있는지를 나타내는 속성이다.
                        //context.mounted는 현재의 BuildContext가 여전히 유효한 상태인지, 즉 State가 아직도 위젯 트리에 연결되어 있는지를 확인하는 데 사용된다.
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnterCode(
                              email: idController.text,
                              authCode: authCode,
                            ),
                          ),
                        );
                      } else {
                        emailNotExisted();
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
