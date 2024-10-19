import 'package:flutter/material.dart';

class TextStart extends StatelessWidget {
  final String text;
  // final String text2;
  // final Widget widget;

  const TextStart({
    super.key,
    required this.text,
    // required this.text2,
    // required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(
          //   height: 25,
          // ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'SF_Pro',
              color: Colors.black,
            ),
          ),
          // Text(
          //   text2,
          //   style: const TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w400,
          //     fontFamily: 'SF_Pro',
          //     color: Colors.black,
          //   ),
          // ),
          // const SizedBox(
          //   height: 60,
          // ),
          // widget,
        ],
      ),
    );
  }
}
