import 'package:flutter/material.dart';
import 'package:flutter_mow/services/bookmark_service.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/input_text_field.dart';

class AddBookmarkList extends StatefulWidget {
  const AddBookmarkList({
    super.key,
  });

  @override
  State<AddBookmarkList> createState() => _AddBookmarkListState();
}

class _AddBookmarkListState extends State<AddBookmarkList> {
  final TextEditingController listTitleController =
      TextEditingController(); // 새로운 리스트 제목을 입력하는 컨트롤러
  List<Color> colorList = [
    const Color(0xFF6B4D38), //color=1
    const Color(0xFF8A5E34), //color=2
    const Color(0xFFDB7A23), //color=3
    const Color(0xFFF46141), //color=4
    const Color(0xFFF5EF5E), //color=5
    const Color(0xFF95ED7F), //color=6
    const Color(0xFF77CAF9), //color=7
    const Color(0xFFAF93EB), //color=8
  ]; // 새로운 리스트를 만들 때 고를 수 있는 색들
  int selectedColor = -1; // 고른 색 저장(-1: 고르지 않음)
  bool selectColor = false; // 색을 골랐는지 여부를 저장

  @override
  void initState() {
    super.initState();
  }

  //확인 버튼 클릭(새 리스트 추가)
  void onClickAddButtonHandler() async {
    //제목이랑 색상을 선택해야만 넘어감
    if (listTitleController.text.isNotEmpty && selectColor) {
      bool addSuccess = await BookmarkService.addBookmarkList(
        listTitleController.text,
        selectedColor,
      );
      if (addSuccess) {
        print('새 리스트 추가 성공');
      } else {
        // print('새 리스트 추가 실패');
      }
      setState(() {
        selectColor = false;
        selectedColor = -1;
        Navigator.of(context).pop();
      });
    }
  }

  //색상 클릭
  void onClickColorHandler(int color) {
    // 이미 선택된 색상 클릭
    if (selectedColor == color) {
      setState(() {
        selectColor = false;
        selectedColor = -1;
      });
      // 정상적으로 리스트 클릭
    } else {
      setState(() {
        selectColor = true;
        selectedColor = color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 427.0,
      padding: const EdgeInsets.only(
          left: 31.0, right: 31.0, top: 40.0, bottom: 56.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 34.0),
            child: Text(
              '새 리스트 추가',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          //리스트 제목 입력칸
          InputTextField(
            label: '입력해주세요',
            labelColor: const Color(0xFFC3C3C3),
            borderColor: const Color(0xFFCCD1DD),
            obscureText: false,
            controller: listTitleController,
          ),
          const SizedBox(
            height: 48.0,
          ),
          //색상 선택
          const Text('색상 선택'),
          const SizedBox(
            height: 14.0,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < colorList.length; i++) ...[
                  GestureDetector(
                    onTap: () {
                      onClickColorHandler(i + 1);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorList[i],
                        shape: BoxShape.circle,
                      ),
                      child: i + 1 == selectedColor
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  if (i != colorList.length - 1)
                    const SizedBox(
                      width: 18.0,
                    )
                ]
              ],
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          ButtonMain(
            text: '확인',
            bgcolor: Colors.white,
            textColor: const Color(0xFF6B4D38),
            borderColor: const Color(0xFF6B4D38),
            opacity: (listTitleController.text.isNotEmpty && selectColor)
                ? 1.0
                : 0.5,
            onPress: () {
              onClickAddButtonHandler();
            },
          ),
        ],
      ),
    );
  }
}
