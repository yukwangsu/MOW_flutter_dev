import 'package:flutter/material.dart';

class ButtonFreeWidth extends StatelessWidget {
  final String text;
  final Color bgcolor;
  final Color textColor;
  final Color borderColor;
  final double opacity;
  final double? heightPadding;

  const ButtonFreeWidth({
    super.key,
    required this.text,
    required this.bgcolor,
    required this.textColor,
    required this.borderColor,
    required this.opacity,
    this.heightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgcolor.withOpacity(opacity), // 투명도 적용
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 2.0,
          color: borderColor,
        ),
      ),
      padding: EdgeInsets.symmetric(
          vertical: heightPadding == null ? 13.5 : heightPadding!),
      child: Center(
        child: Text(
          text,
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(color: textColor),
        ),
      ),
    );
  }
}
