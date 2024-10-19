import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/info/set_mbti.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/drop_down.dart';
import 'package:flutter_mow/widgets/sub_text.dart';
import 'package:flutter_mow/widgets/text_start.dart';

class SetJob extends StatelessWidget {
  final String email;
  final String passwd;
  final String name;
  final int? age;
  final String sex;

  SetJob({
    super.key,
    required this.email,
    required this.passwd,
    required this.name,
    required this.age,
    required this.sex,
  });

  final TextEditingController jobController = TextEditingController();

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
                text: '현재 어떤 일을 하고 있나요?',
              ),
              const SizedBox(
                height: 4,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: SubText(
                  text: '추천 컨텐츠를 위해서만 사용할 정보에요',
                  textColor: Color(0xFFC3C3C3),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              DropDown(
                controller: jobController,
              ),
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
                  opacity: 1.0,
                  onPress: () {
                    print('''info[email: $email, 
                          passwd: $passwd, 
                          name: $name, 
                          age: $age, 
                          sex: $sex,
                          job: ${jobController.text}]''');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetMbti(
                          email: email,
                          passwd: passwd,
                          name: name,
                          age: age,
                          sex: sex,
                          job: jobController.text,
                        ),
                      ),
                    );
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
