import 'package:flutter/material.dart';
import 'package:flutter_mow/widgets/button_free_width.dart';

class CharacterAskBuy extends StatefulWidget {
  const CharacterAskBuy({
    super.key,
  });

  @override
  State<CharacterAskBuy> createState() => _CharacterAskBuyState();
}

class _CharacterAskBuyState extends State<CharacterAskBuy> {
  @override
  void initState() {
    super.initState();
  }

  //삭제 버튼을 눌렀을 때
  void onClickBuyButtonHandler() {
    setState(() {
      // 이전화면으로 돌아가면서 데이터를 전달
      Navigator.of(context).pop(true);
    });
  }

  //취소 버튼을 눌렀을 때
  void onClickCancelButtonHandler() {
    setState(() {
      // 이전화면으로 돌아가면서 데이터를 전달
      Navigator.of(context).pop(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 211.0,
      padding: const EdgeInsets.only(left: 31.0, right: 31.0, top: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '아이템을 구매하시겠어요?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 40.0,
          ),
          // 버튼
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onClickCancelButtonHandler();
                  },
                  child: const ButtonFreeWidth(
                    text: '취소',
                    bgcolor: Colors.white,
                    textColor: Color(0xFF6B4D38),
                    borderColor: Color(0xFF6B4D38),
                    opacity: 1.0,
                  ),
                ),
              ),
              const SizedBox(
                width: 11.0,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onClickBuyButtonHandler();
                  },
                  child: const ButtonFreeWidth(
                    text: '구매',
                    bgcolor: Color(0xFF6B4D38),
                    textColor: Colors.white,
                    borderColor: Color(0xFF6B4D38),
                    opacity: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
