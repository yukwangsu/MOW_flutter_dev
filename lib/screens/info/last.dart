import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/map.dart';
import 'package:flutter_mow/services/signup_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/text_start.dart';

class Last extends StatelessWidget {
  final String email;
  final String passwd;
  final String name;
  final int? age;
  final String sex;
  final String job;
  final String mbti;

  const Last({
    super.key,
    required this.email,
    required this.passwd,
    required this.name,
    required this.age,
    required this.sex,
    required this.job,
    required this.mbti,
  });

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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              TextStart(
                text: '이제 우리만의',
              ),
              TextStart(
                text: '공간을 찾으러 가봐요 !',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset('assets/images/cat_tail.png'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              children: [
                ButtonMain(
                  text: '출발',
                  bgcolor: const Color(0xFF6B4D38),
                  textColor: Colors.white,
                  borderColor: const Color(0xFF6B4D38),
                  opacity: 1.0,
                  onPress: () {
                    print('''info[email: $email, 
                          passwd: $passwd, 
                          name: $name, 
                          age: $age, 
                          sex: $sex,
                          job: $job,
                          mbti: $mbti]''');
                    //json 형식으로 변환해서 api 작업하기
                    SignupService.signupDetails(
                      name,
                      age!,
                      sex,
                      job,
                      mbti,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(),
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
