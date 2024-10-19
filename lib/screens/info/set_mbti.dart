import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/info/last.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/select_button_fix.dart';
import 'package:flutter_mow/widgets/sub_text.dart';
import 'package:flutter_mow/widgets/text_start.dart';

class SetMbti extends StatefulWidget {
  final String email;
  final String passwd;
  final String name;
  final int? age;
  final String sex;
  final String job;

  const SetMbti({
    super.key,
    required this.email,
    required this.passwd,
    required this.name,
    required this.age,
    required this.sex,
    required this.job,
  });

  @override
  State<SetMbti> createState() => _SetMbtiState();
}

class _SetMbtiState extends State<SetMbti> {
  late String mbti = '';

  void setMbti(String value) {
    setState(() {
      mbti = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
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
                text: 'MBTI가 궁금해요!',
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: SubText(
                  text: '추천 컨텐츠를 위해서만 사용할 정보에요',
                  textColor: Color(0xFFC3C3C3),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Column(
                children: [
                  buildRow(['INTJ', 'INTP']),
                  const SizedBox(height: 40),
                  buildRow(['ENTJ', 'ENTP']),
                  const SizedBox(height: 40),
                  buildRow(['INFJ', 'INFP']),
                  const SizedBox(height: 40),
                  buildRow(['ENFJ', 'ENFP']),
                  const SizedBox(height: 40),
                  buildRow(['ISTJ', 'ISFJ']),
                  const SizedBox(height: 40),
                  buildRow(['ESTJ', 'ESFJ']),
                  const SizedBox(height: 40),
                  buildRow(['ISTP', 'ISFP']),
                  const SizedBox(height: 40),
                  buildRow(['ESTP', 'ESFP']),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                ButtonMain(
                  text: '다음',
                  bgcolor: Colors.white,
                  textColor: const Color(0xFF6B4D38),
                  borderColor: const Color(0xFF6B4D38),
                  opacity: mbti.isNotEmpty ? 1.0 : 0.5,
                  onPress: () {
                    if (mbti.isNotEmpty) {
                      print('''info[email: ${widget.email}, 
                          passwd: ${widget.passwd}, 
                          name: ${widget.name}, 
                          age: ${widget.age}, 
                          sex: ${widget.sex},
                          job: ${widget.job},
                          mbti: $mbti]''');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Last(
                            email: widget.email,
                            passwd: widget.passwd,
                            name: widget.name,
                            age: widget.age,
                            sex: widget.sex,
                            job: widget.job,
                            mbti: mbti,
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

  Widget buildRow(List<String> mbtiList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: mbtiList.map((mbtiType) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), //16 * 2 = 32
          child: SelectButtonFix(
            height: 45,
            width: 120,
            bgColor: mbti == mbtiType ? const Color(0xFF6B4D38) : Colors.white,
            radius: 10,
            text: mbtiType,
            textColor:
                mbti == mbtiType ? Colors.white : const Color(0xFF6B4D38),
            borderColor: mbti == mbtiType
                ? const Color(0xFF6B4D38)
                : const Color(0xFFAD7541),
            borderWidth: 1.0,
            onPress: () {
              setMbti(mbtiType);
            },
          ),
        );
      }).toList(),
    );
  }
}
