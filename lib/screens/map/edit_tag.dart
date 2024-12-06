import 'package:flutter/material.dart';
import 'package:flutter_mow/variables.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_mow/widgets/select_button_without_icon.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTag extends StatefulWidget {
  const EditTag({
    super.key,
  });

  @override
  State<EditTag> createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {
  List<bool> isTagOpen = [true, true, true, true, true];
  List<String> taggedList = [];
  List<String> appliedSearchTags = [];

  @override
  void initState() {
    super.initState();
    loadTaggedList(); // 시작 시 태그 리스트를 불러옴
    loadAppliedSearchTags(); // 시작 시 검색 태그 불러옴
  }

  // 태그 리스트 저장
  Future<void> saveTaggedList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('taggedList', taggedList);
  }

  // 태그 리스트 불러오기
  Future<void> loadTaggedList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      taggedList =
          prefs.getStringList('taggedList') ?? []; // 저장된 리스트가 없으면 빈 리스트 사용
    });
  }

  // tag 선택시 사용되는 함수
  void toogleTag(String tagContent) {
    setState(() {
      if (taggedList.contains(tagContent)) {
        taggedList.remove(tagContent);
        appliedSearchTags.remove(tagContent);
      } else {
        taggedList.add(tagContent);
      }
      // 스토리지에 저장
      saveTaggedList();
      saveAppliedSearchTags();
    });
  }

  // 검색 태그 저장
  Future<void> saveAppliedSearchTags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('appliedSearchTags', appliedSearchTags);
  }

  // 검색 태그 불러오기
  Future<void> loadAppliedSearchTags() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      appliedSearchTags = prefs.getStringList('appliedSearchTags') ??
          []; // 저장된 리스트가 없으면 빈 리스트 사용
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 28.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '태그 편집',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            '검색에 이용할 태그들을 선택해주세요!',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // *** 이하 Scroll ***
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 10.0,
                      children: [
                        selectButtonWidget('# 공간이 넓어요'),
                        selectButtonWidget('# 공간이 보통이에요'),
                      ],
                    ),
                    const SizedBoxHeight10(),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 10.0,
                      children: [
                        selectButtonWidget('# 좌석이 많아요'),
                        selectButtonWidget('# 좌석이 보통이에요'),
                      ],
                    ),
                    const SizedBoxHeight10(),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 10.0,
                      children: [
                        selectButtonWidget('# 콘센트가 많아요'),
                        selectButtonWidget('# 콘센트가 보통이에요'),
                      ],
                    ),

                    const SizedBox(
                      height: 16.0,
                    ),

                    // 작업 편의 tab
                    tagTitleWidget(
                      '작업 편의',
                      0,
                    ),
                    // 작업 편의 tags
                    if (isTagOpen[0])
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 10.0,
                          children: workConvenienceTags.map((tag) {
                            return selectButtonWidget(tag);
                          }).toList(),
                        ),
                      ),

                    // 분위기 tab
                    tagTitleWidget(
                      '분위기',
                      1,
                    ),
                    // 분위기 tags
                    if (isTagOpen[1])
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 10.0,
                              children: atmosphereTags.map((tag) {
                                return selectButtonWidget(tag);
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 10.0,
                              children: additionalAtmosphereTags.map((tag) {
                                return selectButtonWidget(tag);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                    // 메뉴 tab
                    tagTitleWidget(
                      '메뉴',
                      2,
                    ),
                    // 메뉴 tags
                    if (isTagOpen[2])
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 10.0,
                          children: menuTags.map((tag) {
                            return selectButtonWidget(tag);
                          }).toList(),
                        ),
                      ),

                    // 서비스 tab
                    tagTitleWidget(
                      '서비스',
                      3,
                    ),
                    // 서비스 tags
                    if (isTagOpen[3])
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 10.0,
                          children: serviceTags.map((tag) {
                            return selectButtonWidget(tag);
                          }).toList(),
                        ),
                      ),

                    // 기타 tab
                    tagTitleWidget(
                      '기타',
                      4,
                    ),
                    // 기타 tags
                    if (isTagOpen[4])
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 10.0,
                          children: otherTags.map((tag) {
                            return selectButtonWidget(tag);
                          }).toList(),
                        ),
                      ),

                    //마지막 여백
                    const SizedBox(
                      height: 72.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tagTitleWidget(String title, int numberOfTag) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            isTagOpen[numberOfTag] = !isTagOpen[numberOfTag];
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, //임의 수정
                fontWeight: FontWeight.bold,
              ),
            ),
            SvgPicture.asset(isTagOpen[numberOfTag]
                ? 'assets/icons/dropdown_up_padding.svg'
                : 'assets/icons/dropdown_down_padding.svg'),
          ],
        ),
      ),
    );
  }

  Widget selectButtonWidget(String textContent) {
    return SelectButtonWithoutIcon(
      height: 32.0,
      padding: 14.0,
      bgColor: taggedList.contains(textContent)
          ? const Color(0xFF6B4D38)
          : Colors.white,
      radius: 1000,
      text: textContent,
      textColor: taggedList.contains(textContent)
          ? Colors.white
          : const Color(0xFF6B4D38),
      borderWidth: taggedList.contains(textContent) ? null : 1.0,
      borderColor:
          taggedList.contains(textContent) ? null : const Color(0xFFAD7541),
      borderOpacity: taggedList.contains(textContent) ? null : 0.4,
      onPress: () {
        toogleTag(textContent);
      },
    );
  }
}

class SizedBoxWidth10 extends StatelessWidget {
  const SizedBoxWidth10({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 10.0,
    );
  }
}

class SizedBoxHeight10 extends StatelessWidget {
  const SizedBoxHeight10({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10.0,
    );
  }
}

class SizedBoxWidth6 extends StatelessWidget {
  const SizedBoxWidth6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 6.0,
    );
  }
}
