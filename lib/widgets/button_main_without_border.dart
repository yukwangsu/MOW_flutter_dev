import 'package:flutter/material.dart';

class ButtonMainWithoutBorder extends StatelessWidget {
  final String text;
  final Color bgcolor;
  final Color textColor;
  final double opacity;

  const ButtonMainWithoutBorder({
    super.key,
    required this.text,
    required this.bgcolor,
    required this.textColor,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: bgcolor.withOpacity(opacity), // 투명도 적용
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13.5),
            child: Center(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
