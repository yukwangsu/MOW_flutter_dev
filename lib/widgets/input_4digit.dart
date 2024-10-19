import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input4digit extends StatefulWidget {
  final List<TextEditingController> digitControllers; //입력값 controller

  const Input4digit({
    super.key,
    required this.digitControllers,
  });

  @override
  State<Input4digit> createState() => _Input4digitState();
}

class _Input4digitState extends State<Input4digit> {
  //숫자 하나 입력하면 자동으로 다음 칸으로 이동
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
          (index) => SizedBox(
            width: 78,
            height: 88,
            child: TextField(
              showCursor: false, //커서 안 보이게
              // cursorColor: Colors.black, // 커서 색깔
              obscureText: false, // 항상 보이게 설정
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1), // 입력 길이 제한
              ],
              focusNode: _focusNodes[index],
              controller: widget.digitControllers[index], //widget 필수
              onChanged: (value) {
                if (value.length == 1 && index < _focusNodes.length - 1) {
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                }
              },
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.normal,
                height: 1.0,
              ), // 글자 크기 설정
              textAlign: TextAlign.center, // 글자 가로 정렬
              textAlignVertical: TextAlignVertical.center, // 글자 세로 정렬
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFCCD1DD), // 원하는 색상으로 변경
                    width: 3, // 테두리 두께 설정
                  ),
                  borderRadius: BorderRadius.circular(12), // 테두리 모서리 둥글게 설정
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF6B4D38), // 클릭 시 색상 변경
                    width: 3, // 테두리 두께 설정
                  ),
                  borderRadius: BorderRadius.circular(12), // 테두리 모서리 둥글게 설정
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18), // 패딩 조정
                isDense: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
