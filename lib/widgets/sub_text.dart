import 'package:flutter/material.dart';

class SubText extends StatelessWidget {
  final String text;
  final Color textColor;

  const SubText({
    super.key,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
        fontFamily: 'SF_Pro',
        color: textColor,
      ),
    );
  }
}
