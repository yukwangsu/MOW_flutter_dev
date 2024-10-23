import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  final Function onPress; // 콜백 함수

  const SwitchButton({super.key, required this.onPress});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        widget.onPress();
        setState(() {
          isSwitched = !isSwitched;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 86,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF000000).withOpacity(0.1),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  isSwitched ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "M",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color:
                            isSwitched ? Colors.white : const Color(0xFF6B4D38),
                      ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "C",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color:
                            isSwitched ? const Color(0xFF6B4D38) : Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
