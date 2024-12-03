import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShortDialog extends StatelessWidget {
  String content;
  String? icon;

  ShortDialog({
    super.key,
    required this.content,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // Dialog: 희려진 부분도 모두 포함
      child: Dialog(
        child: Container(
            height: 84.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      content,
                      style: Theme.of(context).textTheme.bodyLarge,
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
            )),
      ),
    );
  }
}
