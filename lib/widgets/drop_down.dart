import 'package:flutter/material.dart';
import 'package:flutter_mow/widgets/input_text.dart';
import 'package:flutter_svg/svg.dart';

class DropDown extends StatefulWidget {
  final TextEditingController controller;

  const DropDown({
    super.key,
    required this.controller,
  });

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  //초기값 = '직장인'
  String selectedValue = '직장인';
  final List<String> jobList = [
    '대학생',
    '직장인',
    '디자이너',
    '개발자',
    '직접입력',
  ];
  bool isOpen = false;
  bool dropdownMode = true;
  bool inputMode = false;

  @override
  void initState() {
    super.initState();
    widget.controller.text = selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // dropdown mode
        if (dropdownMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFCCD1DD),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 14.0,
                      top: 13.5,
                      bottom: 13.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 21.0,
                          child: Text(
                            selectedValue,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SvgPicture.asset(
                          isOpen
                              ? 'assets/icons/dropdown_up_padding.svg'
                              : 'assets/icons/dropdown_down_padding.svg',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                if (isOpen)
                  Container(
                    padding: const EdgeInsets.only(
                      top: 9.0,
                      bottom: 9.0,
                      left: 18.0,
                      right: 31.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFCCD1DD),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < jobList.length; i++) ...[
                          GestureDetector(
                            behavior:
                                HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
                            onTap: () {
                              setState(() {
                                if (jobList[i] == '직접입력') {
                                  selectedValue = '';
                                  widget.controller.text = '';
                                  isOpen = !isOpen;
                                  dropdownMode = false;
                                  inputMode = true;
                                } else {
                                  selectedValue = jobList[i];
                                  widget.controller.text = selectedValue;
                                  isOpen = !isOpen;
                                }
                              });
                            },
                            child: SizedBox(
                              height: 41.0,
                              child: Row(
                                children: [
                                  Text(
                                    jobList[i],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
              ],
            ),
          ),
        if (inputMode)
          InputText(
            label: '직접입력',
            labelColor: const Color(0xFFC3C3C3),
            borderColor: const Color(0xFFCCD1DD),
            obscureText: false,
            controller: widget.controller,
          ),
      ],
    );
  }
}
