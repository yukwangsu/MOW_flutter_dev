import 'package:flutter/material.dart';
import 'package:flutter_mow/widgets/sub_text.dart';
import 'package:flutter_svg/svg.dart';

class SetPasswd extends StatefulWidget {
  final String label;
  final Color labelColor;
  final Color borderColor;
  final bool obscureText;
  final TextEditingController controller; //입력값 controller
  final TextEditingController controllerSame; //입력값 controller

  const SetPasswd({
    super.key,
    required this.label,
    required this.labelColor,
    required this.borderColor,
    required this.obscureText,
    required this.controller, //입력값 controller
    required this.controllerSame, //입력값 controller
  });

  @override
  State<SetPasswd> createState() => _SetPasswdState();
}

class _SetPasswdState extends State<SetPasswd> {
  late bool con1;
  late bool con2;
  late String val1 = '';
  late String val2 = '';
  late bool isSame;

  @override
  void initState() {
    super.initState();
    con1 = false;
    con2 = false;
    isSame = false;
  }

  con1True() {
    setState(() {
      con1 = true;
    });
  }

  con1False() {
    setState(() {
      con1 = false;
    });
  }

  con2True() {
    setState(() {
      con2 = true;
    });
  }

  con2False() {
    setState(() {
      con2 = false;
    });
  }

  same() {
    setState(() {
      isSame = true;
    });
  }

  wrong() {
    setState(() {
      isSame = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Column(
        children: [
          TextField(
            //StatefulWidget 에서는
            controller: widget.controller, //입력값 controller
            cursorColor: Colors.black, // 커서 색깔
            obscureText: widget.obscureText, // 항상 보이게 하는가, 안 보이게 하는가
            onChanged: (value) {
              val1 = value;
              bool hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
              bool hasDigit = value.contains(RegExp(r'[0-9]'));
              bool hasSpecialCharacter =
                  value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
              if (hasLetter && hasDigit && hasSpecialCharacter) {
                con1True(); //괄호 필수
              } else {
                con1False();
              }
              if (value.length >= 8) {
                con2True();
              } else {
                con2False();
              }
              if (value == val2) {
                same();
              }
              if (value != val2) {
                wrong();
              }
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor,
                  width: 2, // 테두리 두께 설정
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor, // 클릭 시 색상 변경
                  width: 2, // 테두리 두께 설정
                ),
                borderRadius: BorderRadius.circular(12), // 테두리 모서리 둥글게 설정
              ),
              labelText: widget.label,
              floatingLabelBehavior:
                  FloatingLabelBehavior.never, // 라벨이 떠오르지 않게 설정
              labelStyle: TextStyle(
                color: widget.labelColor, // 라벨 색상 설정
                fontFamily: 'SF_Pro',
                fontSize: 16,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
              isDense: true,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(con1
                  ? 'assets/icons/check_true.svg'
                  : 'assets/icons/check_false.svg'),
              const SizedBox(
                width: 9,
              ),
              SubText(
                text: '영문, 숫자, 특수문자 포함',
                textColor: con1 ? Colors.black : const Color(0xFFC3C3C3),
              ),
              const SizedBox(
                width: 17,
              ),
              SvgPicture.asset(con2
                  ? 'assets/icons/check_true.svg'
                  : 'assets/icons/check_false.svg'),
              const SizedBox(
                width: 9,
              ),
              SubText(
                text: '최소 8자리',
                textColor: con2 ? Colors.black : const Color(0xFFC3C3C3),
              ),
            ],
          ),
          //이하 옳바른 비밀번호를 입력했을 때 보임.
          if (con1 && con2) ...[
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: widget.controllerSame,
              cursorColor: Colors.black, // 커서 색깔
              obscureText: widget.obscureText, // 항상 보이게 하는가, 안 보이게 하는가
              onChanged: (value) {
                val2 = value;
                if (value == val1) {
                  same(); //괄호 필수
                } else {
                  wrong();
                }
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: 2, // 테두리 두께 설정
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor, // 클릭 시 색상 변경
                    width: 2, // 테두리 두께 설정
                  ),
                  borderRadius: BorderRadius.circular(12), // 테두리 모서리 둥글게 설정
                ),
                labelText: '비밀번호 재입력',
                floatingLabelBehavior:
                    FloatingLabelBehavior.never, // 라벨이 떠오르지 않게 설정
                labelStyle: TextStyle(
                  color: widget.labelColor, // 라벨 색상 설정
                  fontFamily: 'SF_Pro',
                  fontSize: 16,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                isDense: true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(isSame
                    ? 'assets/icons/check_true.svg'
                    : 'assets/icons/check_false.svg'),
                const SizedBox(
                  width: 9,
                ),
                SubText(
                  text: '동일한 비밀번호',
                  textColor: isSame ? Colors.black : const Color(0xFFC3C3C3),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
