import 'package:flutter/material.dart';
import 'package:flutter_mow/services/character_service.dart';
import 'package:flutter_mow/services/review_service.dart';
import 'package:flutter_mow/variables.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_mow/widgets/long_dialog.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_mow/widgets/select_button_without_icon.dart';
import 'package:flutter_mow/widgets/short_dialog.dart';
import 'package:flutter_svg/svg.dart';

class AddReview extends StatefulWidget {
  final int workspaceId;

  const AddReview({
    super.key,
    required this.workspaceId,
  });

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  num addReviewScore = 0;
  int addReviewWidenessDegree = -1;
  int addReviewChairDegree = -1;
  int addReviewOutletDegree = -1;
  final TextEditingController addReviewTextcontroller = TextEditingController();
  final FocusNode addReviewTextFocusNode = FocusNode();

  List<bool> isTagOpen = [false, false, false, false, false];
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
  }

  // tag 선택시 사용되는 함수
  void toogleTag(String tagContent) {
    setState(() {
      if (selectedTags.contains(tagContent)) {
        selectedTags.remove(tagContent);
      } else {
        selectedTags.add(tagContent);
      }
    });
  }

  // 리뷰 작성 버튼을 눌렀을 때
  void onClickButtonHandler() async {
    if (addReviewTextcontroller.text.isNotEmpty) {
      // 줄글리뷰를 작성했을 때
      if (addReviewWidenessDegree > 0) {
        switch (addReviewWidenessDegree) {
          case 0:
            selectedTags.add('# 공간이 넓어요');
            break;
          case 1:
            selectedTags.add('# 공간이 보통이에요');
            break;
          case 2:
            selectedTags.add('# 공간이 좁아요');
            break;
        }
      }
      if (addReviewChairDegree > 0) {
        switch (addReviewChairDegree) {
          case 0:
            selectedTags.add('# 좌석이 많아요');
            break;
          case 1:
            selectedTags.add('# 좌석이 보통이에요');
            break;
          case 2:
            selectedTags.add('# 좌석이 적어요');
            break;
        }
      }
      if (addReviewOutletDegree > 0) {
        switch (addReviewOutletDegree) {
          case 0:
            selectedTags.add('# 콘센트가 많아요');
            break;
          case 1:
            selectedTags.add('# 콘센트가 보통이에요');
            break;
          case 2:
            selectedTags.add('# 콘센트가 적어요');
            break;
        }
      }

      //api 호출
      await ReviewService.addReview(addReviewTextcontroller.text, selectedTags,
          widget.workspaceId, addReviewScore.toDouble());

      Navigator.pop(context);
      CharacterService.increaseReward(1); // 젤리 1개 지급

      // 젤리 지급 메시지 띄움.
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return LongDialog(
              contentTitle: '리뷰 등록 완료!', content: '젤리 1개가 지급되었어요 \u{1F606}');
        },
      );
    } else {
      // 줄글을 작성하지 않았을 때
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShortDialog(content: '줄글 리뷰를 작성해 주세요');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: GestureDetector(
        // *** 빈 공간까지 터치 감지 ***
        behavior: HitTestBehavior.opaque,
        // 리뷰가 아닌 다른 공간 터치시 unfocus
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //스크롤 X
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 28, left: 4.0),
                      child: Text(
                        '리뷰 작성',
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                ],
              ),
              const SizedBox(
                height: 21,
              ),
              //스크롤 O
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 21,
                      ),
                      Row(
                        children: [
                          Text(
                            '별점',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //별 아이콘
                      Row(
                        children: [
                          // 별점
                          for (int i = 0; i < addReviewScore.round(); i++) ...[
                            GestureDetector(
                                onTap: () {
                                  addReviewScore = i + 1;
                                  setState(() {});
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/star_fill_big_icon.svg')),
                          ],
                          for (int i = 0;
                              i < 5 - addReviewScore.round();
                              i++) ...[
                            GestureDetector(
                                onTap: () {
                                  addReviewScore =
                                      addReviewScore.round() + i + 1;
                                  setState(() {});
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/star_unfill_big_icon.svg')),
                          ],
                          const SizedBox(
                            width: 4.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 56,
                      ),
                      //태그 선택
                      Row(
                        children: [
                          Text(
                            '태그',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '해당 공간에 어울리는 태그를 골라주세요!',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Text(
                            '공간',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewWidenessDegree == 2
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 좁아요',
                              textColor: addReviewWidenessDegree == 2
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewWidenessDegree = 2;
                                setState(() {});
                              }),
                          const SizedBoxWidth6(),
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewWidenessDegree == 1
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 보통이에요',
                              textColor: addReviewWidenessDegree == 1
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewWidenessDegree = 1;
                                setState(() {});
                              }),
                          const SizedBoxWidth6(),
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewWidenessDegree == 0
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 넓어요',
                              textColor: addReviewWidenessDegree == 0
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewWidenessDegree = 0;
                                setState(() {});
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Text(
                            '좌석 수',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewChairDegree == 2
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 적어요',
                              textColor: addReviewChairDegree == 2
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewChairDegree = 2;
                                setState(() {});
                              }),
                          const SizedBoxWidth6(),
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewChairDegree == 1
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 보통이에요',
                              textColor: addReviewChairDegree == 1
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewChairDegree = 1;
                                setState(() {});
                              }),
                          const SizedBoxWidth6(),
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewChairDegree == 0
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 많아요',
                              textColor: addReviewChairDegree == 0
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewChairDegree = 0;
                                setState(() {});
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Text(
                            '콘센트 수',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewOutletDegree == 2
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 적어요',
                              textColor: addReviewOutletDegree == 2
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewOutletDegree = 2;
                                setState(() {});
                              }),
                          const SizedBoxWidth6(),
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewOutletDegree == 1
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 보통이에요',
                              textColor: addReviewOutletDegree == 1
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewOutletDegree = 1;
                                setState(() {});
                              }),
                          const SizedBoxWidth6(),
                          SelectButton(
                              height: 40,
                              padding: 14,
                              bgColor: addReviewOutletDegree == 0
                                  ? const Color(0xFF6B4D38)
                                  : Colors.white,
                              radius: 1000,
                              text: '# 많아요',
                              textColor: addReviewOutletDegree == 0
                                  ? Colors.white
                                  : const Color(0xFF6B4D38),
                              textSize: 14,
                              borderColor: const Color(0xFFAD7541),
                              borderOpacity: 0.4,
                              borderWidth: 1.0,
                              lineHeight: 2.0,
                              onPress: () {
                                addReviewOutletDegree = 0;
                                setState(() {});
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const ListBorderLine(),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Text(
                            '추가적으로 어떤 태그가 어울릴까요? ',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      //// 추가 태그 선택
                      const SizedBox(
                        height: 16.0,
                      ),

                      // 1. 작업 편의 tab
                      tagTitleWidget(
                        '작업 편의',
                        0,
                      ),
                      // 작업 편의 tags
                      isTagOpen[0]
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 24.0),
                              child: Wrap(
                                spacing: 6.0,
                                runSpacing: 10.0,
                                children: workConvenienceTags.map((tag) {
                                  return selectButtonWidget(tag);
                                }).toList(),
                              ),
                            )
                          : Container(),

                      // 2. 분위기 tab
                      tagTitleWidget(
                        '분위기',
                        1,
                      ),
                      // 분위기 tags
                      isTagOpen[1]
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 24.0),
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
                                    children:
                                        additionalAtmosphereTags.map((tag) {
                                      return selectButtonWidget(tag);
                                    }).toList(),
                                  ),
                                ],
                              ),
                            )
                          : Container(),

                      // 3. 메뉴 tab
                      tagTitleWidget(
                        '메뉴',
                        2,
                      ),
                      // 메뉴 tags
                      isTagOpen[2]
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 24.0),
                              child: Wrap(
                                spacing: 6.0,
                                runSpacing: 10.0,
                                children: menuTags.map((tag) {
                                  return selectButtonWidget(tag);
                                }).toList(),
                              ),
                            )
                          : Container(),

                      // 4. 서비스 tab
                      tagTitleWidget(
                        '서비스',
                        3,
                      ),
                      // 서비스 tags
                      isTagOpen[3]
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 24.0),
                              child: Wrap(
                                spacing: 6.0,
                                runSpacing: 10.0,
                                children: serviceTags.map((tag) {
                                  return selectButtonWidget(tag);
                                }).toList(),
                              ),
                            )
                          : Container(),

                      // 5. 기타 tab
                      tagTitleWidget(
                        '기타',
                        4,
                      ),
                      // 기타 tags
                      isTagOpen[4]
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 24.0),
                              child: Wrap(
                                spacing: 6.0,
                                runSpacing: 10.0,
                                children: otherTags.map((tag) {
                                  return selectButtonWidget(tag);
                                }).toList(),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 56,
                      ),

                      //줄글 리뷰
                      Row(
                        children: [
                          Text(
                            '줄글리뷰',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '줄글리뷰 작성시 1젤리를 추가로 더 드려요!!',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: const Color(0xFFC3C3C3)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //줄글리뷰 입력칸(생략)
                      TextField(
                        controller: addReviewTextcontroller,
                        focusNode: addReviewTextFocusNode,
                        maxLines: 7, // 여러 줄 입력 가능
                        maxLength: 100, // 최대 입력 가능 문자 수
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10), // 테두리 radius
                            borderSide: const BorderSide(
                              color: Color(0xFFC3C3C3), // 기본 테두리 색상
                              width: 2.0, // 기본 테두리 두께
                            ),
                          ),
                          // 포커스 상태일 때 테두리 스타일 유지
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFC3C3C3), // 포커스 시 테두리 색상
                              width: 2.0, // 포커스 시 테두리 두께
                            ),
                          ),
                          // 포커스가 없을 때 테두리 스타일 고정
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFC3C3C3), // 비활성 상태일 때 테두리 색상
                              width: 2.0, // 비활성 상태일 때 테두리 두께
                            ),
                          ),
                          hintText: addReviewTextFocusNode.hasFocus
                              ? ''
                              : '콘센트, 와이파이는 어땠나요?\n화장실은 사용하기 편했나요?',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: const Color(0xFFC3C3C3)),
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      //완료버튼(생략)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: ButtonMain(
                            text: "완료",
                            bgcolor: const Color(0xFF6B4D38),
                            textColor: Colors.white,
                            borderColor: const Color(0xFF6B4D38),
                            opacity: 1.0,
                            onPress: () {
                              onClickButtonHandler();
                            }),
                      ),
                      const SizedBox(
                        height: 56,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      bgColor: selectedTags.contains(textContent)
          ? const Color(0xFF6B4D38)
          : Colors.white,
      radius: 1000,
      text: textContent,
      textColor: selectedTags.contains(textContent)
          ? Colors.white
          : const Color(0xFF6B4D38),
      borderWidth: selectedTags.contains(textContent) ? null : 1.0,
      borderColor:
          selectedTags.contains(textContent) ? null : const Color(0xFFAD7541),
      borderOpacity: selectedTags.contains(textContent) ? null : 0.4,
      onPress: () {
        toogleTag(textContent);
      },
    );
  }
}

class ListBorderLine extends StatelessWidget {
  const ListBorderLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 1.0,
      decoration: const BoxDecoration(
        color: Color(0xFFE4E3E2),
      ),
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
