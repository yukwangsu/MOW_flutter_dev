import 'package:flutter/material.dart';
import 'package:flutter_mow/services/bookmark_service.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/button_main_without_border.dart';
import 'package:flutter_mow/widgets/input_text_field.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_mow/widgets/select_button_without_icon.dart';

class CurationTag extends StatefulWidget {
  final List<String> initialSelectedTags;

  const CurationTag({
    super.key,
    required this.initialSelectedTags,
  });

  @override
  State<CurationTag> createState() => _CurationTagState();
}

class _CurationTagState extends State<CurationTag> {
  final int maximumTagCnt = 2;

  final List<String> curationTagList = [
    '감성적인',
    '자연적인',
    '모던한',
    '차분한',
    '빈티지',
    '커피 맛집',
    '디저트 맛집',
    '한적한',
    '아기자기한',
    '아늑한',
    '재미있는',
    '웨커이션',
    '작업하기 좋은',
    '볼거리가 많은',
  ];
  List<String> selectedTagList = [];

  @override
  void initState() {
    super.initState();
    //기존에 선택된 태그들 저장하기(***얕은 복사 방지***)
    selectedTagList = List.from(widget.initialSelectedTags);
  }

  //태그를 선택했을 때
  void toogleTag(String tagName) {
    if (selectedTagList.contains(tagName)) {
      //이미 선택된 태그일 경우 취소
      setState(() {
        selectedTagList.remove(tagName);
      });
    } else {
      //기존에 선택된 태그가 아닐 경우
      if (selectedTagList.length == maximumTagCnt) {
        // 1. 이미 두개가 선택된 경우 앞에 태그를 제거하고 새로 추가
        setState(() {
          selectedTagList.removeAt(0);
          selectedTagList.add(tagName);
        });
      } else {
        // 2. 선택된 태그의 개수가 한개 이하일 경우 그냥 새로 추가
        setState(() {
          selectedTagList.add(tagName);
        });
      }
    }
  }

  //선택 완료 버튼을 눌렀을 때
  void onClickButtonHandler() {
    //선택된 태그가 있을 경우
    if (selectedTagList.isNotEmpty) {
      setState(() {
        // 이전화면으로 돌아가면서 데이터를 전달
        Navigator.of(context).pop(selectedTagList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 485.0,
      padding: const EdgeInsets.only(
          left: 25.5, right: 25.5, top: 40.0, bottom: 56.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '태그 선택',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  '최대 2개까지 선택할 수 있어요!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          //태그 선택(Expanded를 사용하여 남은 영역을 모두 사용)
          Expanded(
            // 다른 영역을 침범하게 될 경우 위아래로 스크롤
            child: SingleChildScrollView(
              // Wrap: 화면 너비를 초과하면 자동으로 다음 줄로 넘어가게 해주는 위젯
              child: Wrap(
                spacing: 6.0, // 각 항목 간 간격
                runSpacing: 12.0, // 줄 간 간격
                children: [
                  for (int n = 0; n < curationTagList.length; n++)
                    selectButtonWidget(curationTagList[n]),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 48.0,
          ),
          //선택 완료 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.5),
            child: GestureDetector(
              onTap: () {
                onClickButtonHandler();
              },
              child: ButtonMainWithoutBorder(
                  text: '선택 완료',
                  bgcolor: const Color(0xFF6B4D38),
                  textColor: Colors.white,
                  opacity: (selectedTagList.isNotEmpty) ? 1.0 : 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectButtonWidget(String textContent) {
    return SelectButtonWithoutIcon(
      height: 40.0,
      padding: 14.0,
      bgColor: selectedTagList.contains(textContent)
          ? const Color(0xFF6B4D38)
          : Colors.white,
      radius: 1000,
      text: textContent,
      textColor: selectedTagList.contains(textContent)
          ? Colors.white
          : const Color(0xFF6B4D38),
      textSize: 14.0,
      borderWidth: selectedTagList.contains(textContent) ? null : 1.0,
      borderColor: selectedTagList.contains(textContent)
          ? null
          : const Color(0xFFAD7541),
      borderOpacity: selectedTagList.contains(textContent) ? null : 0.4,
      onPress: () {
        toogleTag(textContent);
      },
    );
  }
}
