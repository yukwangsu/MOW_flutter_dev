import 'package:flutter/material.dart';

class ButtonMain extends StatelessWidget {
  final String text;
  final Color bgcolor;
  final Color textColor;
  final Color borderColor;
  final double opacity;
  final Function onPress;

  const ButtonMain({
    super.key,
    required this.text,
    required this.bgcolor,
    required this.textColor,
    required this.borderColor,
    required this.opacity,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onPress(), // 함수를 호출하지 않고 참조를 전달
            style: ElevatedButton.styleFrom(
              backgroundColor: bgcolor,
              foregroundColor: textColor.withOpacity(opacity),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: borderColor.withOpacity(opacity),
                  width: 2,
                ),
              ),
              elevation: 0, // Remove the shadow
              padding: const EdgeInsets.symmetric(
                vertical: 12.5,
                horizontal: 80,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF_Pro',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
