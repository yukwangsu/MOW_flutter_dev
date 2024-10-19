import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/info/set_age.dart';
import 'package:flutter_mow/services/signup_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/sub_text.dart';
import 'package:flutter_mow/widgets/text_start.dart';
import 'package:flutter_mow/widgets/input_text.dart';

class InfoSetName extends StatefulWidget {
  final String email;
  final String passwd;

  const InfoSetName({
    super.key,
    required this.email,
    required this.passwd,
  });

  @override
  State<InfoSetName> createState() => _InfoSetNameState();
}

class _InfoSetNameState extends State<InfoSetName> {
  final TextEditingController nameController = TextEditingController();

  bool isNameExisted = false;
  double buttonOpacity = 0.5;
  bool bottonWork = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_checkNameInput);
  }

  @override
  void dispose() {
    nameController.removeListener(_checkNameInput);
    nameController.dispose();
    super.dispose();
  }

  void _checkNameInput() {
    if (nameController.text.isNotEmpty) {
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

  nameExisted() {
    setState(() {
      isNameExisted = true;
    });
  }

  nameNotExisted() {
    setState(() {
      isNameExisted = false;
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
                text: 'MOW',
              ),
              const TextStart(
                text: '닉네임은 무엇인가요 ?',
              ),
              const SizedBox(
                height: 60,
              ),
              InputText(
                label: '닉네임을 입력해주세요',
                labelColor: const Color(0xFFC3C3C3),
                borderColor: isNameExisted
                    ? const Color(0xFFFF2E2E)
                    : const Color(0xFFCCD1DD),
                obscureText: false,
                controller: nameController,
              ),
              //이미 존재하는 닉네임을 입력했을 때 에러 메세지
              if (isNameExisted) ...[
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
                            text: '이미 존재하는 닉네임입니다.',
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
                  text: '다음',
                  bgcolor: Colors.white,
                  textColor: const Color(0xFF6B4D38),
                  borderColor: const Color(0xFF6B4D38),
                  opacity: buttonOpacity,
                  onPress: () async {
                    if (bottonWork) {
                      print(
                          'info[email: ${widget.email}, passwd: ${widget.passwd}, name: ${nameController.text}]');
                      bool success = await SignupService.checkName(
                        nameController.text,
                      );
                      if (success) {
                        nameNotExisted();
                        //context.mounted: mounted는 StatefulWidget의 State 객체가 위젯 트리에 연결(mounted)되어 있는지를 나타내는 속성이다.
                        //context.mounted는 현재의 BuildContext가 여전히 유효한 상태인지, 즉 State가 아직도 위젯 트리에 연결되어 있는지를 확인하는 데 사용된다.
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetAge(
                              email: widget.email,
                              passwd: widget.passwd,
                              name: nameController.text,
                            ),
                          ),
                        );
                      } else {
                        nameExisted();
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
