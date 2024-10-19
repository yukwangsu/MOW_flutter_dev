import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/info/set_job.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_mow/widgets/text_start.dart';

class SetSex extends StatefulWidget {
  final String email;
  final String passwd;
  final String name;
  final int? age;

  const SetSex({
    super.key,
    required this.email,
    required this.passwd,
    required this.name,
    required this.age,
  });

  @override
  State<SetSex> createState() => _SetSexState();
}

class _SetSexState extends State<SetSex> {
  late String sex = '';

  selectMan() {
    setState(() {
      sex = '남자';
    });
  }

  selectWoman() {
    setState(() {
      sex = '여자';
    });
  }

  selectNone() {
    setState(() {
      sex = '선택안함';
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
              TextStart(
                text: '${widget.name} 님의',
              ),
              const TextStart(
                text: '성별이 궁금해요 !',
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Row(
                  children: [
                    SelectButton(
                      height: 49,
                      padding: 26,
                      bgColor: sex == '남자'
                          ? const Color(0xFF6B4D38)
                          : const Color(0xFFFFFCF8),
                      radius: 1000,
                      text: '남자',
                      textColor:
                          sex == '남자' ? Colors.white : const Color(0xFF6B4D38),
                      textSize: 20.0,
                      onPress: () {
                        selectMan();
                      },
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    SelectButton(
                      height: 49,
                      padding: 26,
                      bgColor: sex == '여자'
                          ? const Color(0xFF6B4D38)
                          : const Color(0xFFFFFCF8),
                      radius: 1000,
                      text: '여자',
                      textColor:
                          sex == '여자' ? Colors.white : const Color(0xFF6B4D38),
                      textSize: 20.0,
                      onPress: () {
                        selectWoman();
                      },
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    SelectButton(
                      height: 49,
                      padding: 26,
                      bgColor: sex == '선택안함'
                          ? const Color(0xFF6B4D38)
                          : const Color(0xFFFFFCF8),
                      radius: 1000,
                      text: '선택안함',
                      textColor: sex == '선택안함'
                          ? Colors.white
                          : const Color(0xFF6B4D38),
                      textSize: 20.0,
                      onPress: () {
                        selectNone();
                      },
                    ),
                  ],
                ),
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
                  opacity: sex.isNotEmpty ? 1.0 : 0.5,
                  onPress: () {
                    if (sex.isNotEmpty) {
                      print('''info[email: ${widget.email}, 
                          passwd: ${widget.passwd}, 
                          name: ${widget.name}, 
                          age: ${widget.age}, 
                          sex: $sex]''');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetJob(
                            email: widget.email,
                            passwd: widget.passwd,
                            name: widget.name,
                            age: widget.age,
                            sex: sex,
                          ),
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
