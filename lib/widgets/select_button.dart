import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectButton extends StatelessWidget {
  final double height;
  final double padding;
  final Color bgColor;
  final double radius;
  final String text;
  final Color textColor;
  final double textSize;
  final Color? borderColor; // nullable 테두리 색상
  final double? borderWidth; // 테두리 두께
  final double? borderOpacity; // 테두리 투명도
  final String? svgIconPath; // 아이콘 추가
  final bool? isIconFirst; // 아이콘이 텍스트보다 먼저 배열
  final Color? iconColor;
  final double? lineHeight;
  final Function onPress;

  const SelectButton({
    super.key,
    required this.height,
    required this.padding,
    required this.bgColor,
    required this.radius,
    required this.text,
    required this.textColor,
    required this.textSize,
    this.borderColor,
    this.borderWidth,
    this.borderOpacity,
    this.svgIconPath,
    this.isIconFirst,
    this.iconColor,
    this.lineHeight,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: () => onPress(), // 함수를 호출하지 않고 참조를 전달
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
          ), // 텍스트와 버튼 사이 거리
          minimumSize: Size(0, height), // 최소 높이 설정
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius), // 테두리 반경 설정
            side: borderColor != null
                ? BorderSide(
                    color: borderColor!.withOpacity(borderOpacity!),
                    width: borderWidth!,
                  )
                : BorderSide.none, // 테두리 설정하지 않음
          ),
          splashFactory: NoSplash.splashFactory, // 스플래시 효과 제거
        ),
        child: Row(
          children: [
            if (isIconFirst == null || !isIconFirst!) ...[
              Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF_Pro',
                  color: textColor,
                  height: lineHeight == null ? 1.2 : lineHeight!,
                ),
              ),
              if (svgIconPath != null)
                const SizedBox(width: 4.0), // 아이콘과 텍스트 사이의 간격
              if (svgIconPath != null) // 아이콘이 있으면 표시
                SvgPicture.asset(
                  svgIconPath!,
                ),
            ] else ...[
              if (svgIconPath != null) // 아이콘이 있으면 표시
                if (iconColor == null)
                  SvgPicture.asset(
                    svgIconPath!,
                  )
                else
                  SvgPicture.asset(
                    svgIconPath!,
                    color: iconColor,
                  ),
              if (svgIconPath != null)
                const SizedBox(width: 4.0), // 아이콘과 텍스트 사이의 간격
              Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF_Pro',
                  color: textColor,
                  height: lineHeight == null ? 1.2 : lineHeight!,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
