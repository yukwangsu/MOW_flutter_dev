import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LongDialog extends StatelessWidget {
  String contentTitle;
  String content;
  String? icon;

  LongDialog({
    super.key,
    required this.contentTitle,
    required this.content,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // Dialog: 희려진 부분도 모두 포함
      child: Dialog(
        child: Container(
            height: 105.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. contentTitle
                  Text(
                    contentTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  // 2. content
                  IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          content,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: const Color(0xFFC3C3C3)),
                        ),
                        if (icon != null) ...[
                          const SizedBox(
                            width: 8.0,
                          ),
                          SvgPicture.asset(icon!),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
