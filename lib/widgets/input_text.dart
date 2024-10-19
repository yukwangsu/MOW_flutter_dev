import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color borderColor;
  final bool obscureText;
  final TextEditingController controller; //입력값 controller

  const InputText({
    super.key,
    required this.label,
    required this.labelColor,
    required this.borderColor,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: TextField(
        controller: controller, //입력값 controller
        cursorColor: Colors.black, // 커서 색깔
        obscureText: obscureText, // 항상 보이게 하는가, 안 보이게 하는가
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          // border: InputBorder.none, //밑줄 없애기
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
              width: 2, // 테두리 두께 설정
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor, // 클릭 시 색상 변경
              width: 2, // 테두리 두께 설정
            ),
            borderRadius: BorderRadius.circular(12), // 테두리 모서리 둥글게 설정
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never, // 라벨이 떠오르지 않게 설정
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: labelColor),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.5, horizontal: 20),
          isDense: true,
        ),
      ),
    );
  }
}
