import 'package:flutter/material.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/select_button.dart';
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
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    tagListWidget(
                      '# 공간이 넓어요',
                      '# 좌석이 많아요',
                      null,
                    ),
                    const SizedBoxHeight10(),
                    tagListWidget(
                      '# 콘센트가 많아요',
                      null,
                      null,
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
                    if (isTagOpen[0]) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: tagListWidget(
                          '# 한산해요',
                          '# 의자가 편해요',
                          '# 책상이 넓어요',
                        ),
                      ),
                    ],

                    // 분위기 tab
                    tagTitleWidget(
                      '분위기',
                      1,
                    ),
                    // 분위기 tags
                    if (isTagOpen[1]) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Column(
                          children: [
                            tagListWidget(
                              '# 뷰가 좋아요',
                              '# 조용해요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 아늑해요',
                              '# 인테리어가 깔끔해요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 어두워요',
                              '# 밝아요',
                              '# 다시 오고 싶어요',
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 음악이 좋아요',
                              '# 대화하기 좋아요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 감각적이에요',
                              '# 혼자 작업하기 좋아요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 회의하기에 좋아요',
                              null,
                              null,
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 메뉴 tab
                    tagTitleWidget(
                      '메뉴',
                      2,
                    ),
                    // 메뉴 tags
                    if (isTagOpen[2]) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Column(
                          children: [
                            tagListWidget(
                              '# 저렴해요',
                              '# 매뉴가 다양해요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 커피가 맛있어요',
                              '# 디저트가 맛있어요',
                              null,
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 서비스 tab
                    tagTitleWidget(
                      '서비스',
                      3,
                    ),
                    // 서비스 tags
                    if (isTagOpen[3]) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Column(
                          children: [
                            tagListWidget(
                              '# 친절해요',
                              '# 와이파이가 잘 터져요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 에어컨이 잘 나와요',
                              '# 오래 작업하기 좋아요',
                              null,
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 기타 tab
                    tagTitleWidget(
                      '기타',
                      4,
                    ),
                    // 기타 tags
                    if (isTagOpen[4]) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Column(
                          children: [
                            tagListWidget(
                              '# 화장실이 깨끗해요',
                              '# 찾아가기 편해요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 무료로 이용이 가능해요',
                              '# 주차가 가능해요',
                              null,
                            ),
                            const SizedBoxHeight10(),
                            tagListWidget(
                              '# 24시간 운영이에요',
                              null,
                              null,
                            ),
                          ],
                        ),
                      ),
                    ],

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
          GestureDetector(
            onTap: () {
              setState(() {
                isTagOpen[numberOfTag] = !isTagOpen[numberOfTag];
              });
            },
            child: SvgPicture.asset(isTagOpen[numberOfTag]
                ? 'assets/icons/dropdown_up_padding.svg'
                : 'assets/icons/dropdown_down_padding.svg'),
          ),
        ],
      ),
    );
  }

  Widget tagListWidget(
      String tagContent1, String? tagContent2, String? tagContent3) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // tag Content 1
                    selectButtonWidget(
                      tagContent1,
                    ),
                    if (tagContent2 != null) ...[
                      const SizedBoxWidth6(),
                      // tag Content 2
                      selectButtonWidget(
                        tagContent2,
                      ),
                      if (tagContent3 != null) ...[
                        const SizedBoxWidth6(),
                        // tag Content 3
                        selectButtonWidget(
                          tagContent3,
                        ),
                      ]
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget selectButtonWidget(String textContent) {
    return SelectButton(
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
      textSize: 14.0,
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
