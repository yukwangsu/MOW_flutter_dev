import 'package:flutter/material.dart';

class SelectButtonFix extends StatelessWidget {
  final double height;
  final double width;
  final Color bgColor;
  final double radius;
  final String text;
  final Color textColor;
  final Color? borderColor; // nullable 테두리 색상
  final double? borderWidth; // 테두리 두께
  final Function onPress;

  const SelectButtonFix({
    super.key,
    required this.height,
    required this.width,
    required this.bgColor,
    required this.radius,
    required this.text,
    required this.textColor,
    this.borderColor,
    this.borderWidth, // 테두리 두께 기본 값
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: () => onPress(), // 함수를 호출하지 않고 참조를 전달
        style: TextButton.styleFrom(
          minimumSize: Size(width, height), // 최소 크기 설정
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius), // 테두리 반경 설정
            side: borderColor != null
                ? BorderSide(
                    color: borderColor!.withOpacity(0.4),
                    width: borderWidth!,
                  )
                : BorderSide.none, // 테두리 설정하지 않음
          ),
          splashFactory: NoSplash.splashFactory, // 스플래시 효과 제거
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF_Pro',
            color: textColor,
          ),
        ),
      ),
    );
  }
}
