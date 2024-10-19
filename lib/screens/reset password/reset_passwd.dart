import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/signin/login_screen.dart';
import 'package:flutter_mow/services/signup_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/set_passwd.dart';
import 'package:flutter_mow/widgets/text_start.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({
    super.key,
    required this.email,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController passwdController = TextEditingController();
  final TextEditingController sameController = TextEditingController();

  double buttonOpacity = 0.5;
  bool bottonWork = false;

  @override
  void initState() {
    super.initState();
    passwdController.addListener(_checkPasswordInput);
    sameController.addListener(_checkPasswordInput);
  }

  @override
  void dispose() {
    passwdController.removeListener(_checkPasswordInput);
    sameController.removeListener(_checkPasswordInput);
    passwdController.dispose();
    sameController.dispose();
    super.dispose();
  }

  void _checkPasswordInput() {
    bool hasLetter = passwdController.text.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = passwdController.text.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacter =
        passwdController.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    if (passwdController.text == sameController.text &&
        passwdController.text.length >= 8 &&
        hasLetter &&
        hasDigit &&
        hasSpecialCharacter) {
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
                text: '새 비밀번호를',
              ),
              const TextStart(
                text: '알려주세요 \u{1f92b}',
              ),
              const SizedBox(
                height: 60,
              ),
              SetPasswd(
                label: '비밀번호 입력',
                labelColor: const Color(0xFFC3C3C3),
                borderColor: const Color(0xFFCCD1DD),
                obscureText: true,
                controller: passwdController,
                controllerSame: sameController,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              children: [
                ButtonMain(
                  text: '비밀번호 변경하기',
                  bgcolor: Colors.white,
                  textColor: const Color(0xFF6B4D38),
                  borderColor: const Color(0xFF6B4D38),
                  opacity: buttonOpacity,
                  onPress: () async {
                    //텍스트가 같은지, 비밀번호 조건에 만족하는지 확인
                    if (bottonWork) {
                      print('your email: ${widget.email}');
                      print('your passwd: ${passwdController.text}');
                      await SignupService.resetPW(
                        widget.email,
                        passwdController.text,
                      );
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
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
