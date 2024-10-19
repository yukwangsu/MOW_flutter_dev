import 'package:flutter/material.dart';

class InputBottom extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color borderColor;
  final bool obscureText;
  final TextEditingController controller; //입력값 controller

  const InputBottom({
    super.key,
    required this.label,
    required this.labelColor,
    required this.borderColor,
    required this.obscureText,
    required this.controller, //입력값 controller
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, //입력값 controller
      cursorColor: Colors.black, //커서 색깔
      obscureText: obscureText, // 항상보이게 하는가, 안보이게 하는가
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: borderColor, // 클릭 시 색상 변경
          ),
        ),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never, // 라벨이 떠오르지 않게 설정
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: labelColor,
            ),
        contentPadding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
        isDense: true,
      ),
    );
  }
}
