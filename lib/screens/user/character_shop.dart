import 'package:flutter/material.dart';
import 'package:flutter_mow/models/character_model.dart';
import 'package:flutter_mow/services/character_service.dart';
import 'package:flutter_mow/variables.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_free_width.dart';
import 'package:flutter_mow/widgets/character_ask_buy.dart';
import 'package:flutter_mow/widgets/short_dialog.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_mow/widgets/select_button_without_icon.dart';
import 'package:flutter_svg/svg.dart';

class CharacterShop extends StatefulWidget {
  const CharacterShop({
    super.key,
  });

  @override
  State<CharacterShop> createState() => _CharacterShopState();
}

class _CharacterShopState extends State<CharacterShop> {
  List<String> categoryList = ['상의', '하의', '소품', '시즌']; // 카테고리들
  Map<String, int> categoryCodeLocationMap = {
    '상의': 1,
    '하의': 2,
    '소품': 3,
    '시즌': 4,
  };
  String selectedCategory = '상의'; // 선택된 카테고리(기본값: '상의')
  int selectedItemIndex = -1; // 선택한 아이템 index
  late Future<int> reward; // 보유한 젤리 개수 저장하는 변수
  late Future<int> characterComp; // 캐릭터 조합 저장하는 변수
  late Future<List<dynamic>> ownedItems; // 보유한 아이템 저장하는 변수

  @override
  void initState() {
    super.initState();

    // 보유한 젤리 개수 불러오기
    reward = CharacterService.getMyReward();

    // 캐릭터 조합 불러오기
    characterComp = CharacterService.getCharacterComp();

    // 보유한 아이템 불러오기
    ownedItems = CharacterService.getOwnedItems();
  }

  // 카테고리 버튼을 눌렀을 때
  void onClickCategoryButton(String clickedCategory) {
    setState(() {
      selectedItemIndex = -1; // 선택한 아이템 초기화
      selectedCategory = clickedCategory;
    });
  }

  // 아이템을 눌렀을 때
  void onClickItem(
      int itemIndex, bool isOwned, int itemPrice, int itemCode) async {
    setState(() {
      selectedItemIndex = itemIndex; // 선택된 아이템 index 조정
    });
    if (isOwned) {
      // // 보유한 아이템일 경우 -> 아이템 착장
      final tempComp = await CharacterService.getCharacterComp(); // 현재 조합 가져오기
      // 조합 변경 로직
      List<String> tempCompStr = tempComp.toString().split('');
      tempCompStr[tempCompStr.length - itemCode.toString().length] =
          itemCode.toString().split('')[0];
      int editedComp = int.parse(tempCompStr.join());
      print('editedComp: $editedComp');
      // 변경된 조합 적용하기
      await CharacterService.editCharacterComp(editedComp);
      reloadAfterChangeComp();
    } else {
      // 보유한 아이템이 아닐 경우 -> 아이템 구매의사 물어보기
      var buyResult = await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return const CharacterAskBuy();
        },
      );
      if (buyResult != null && buyResult) {
        // 구매 버튼을 눌러서 buyResult가 true일 때
        print('아이템 구매 시도');
        // 1. 보유 젤리 확인
        final tempJelly = await CharacterService.getMyReward();
        if (tempJelly >= itemPrice) {
          // // 보유한 젤리가 아이템 가격보다 많으므로 구매 가능
          // 2. 아이템 금액만큼 보유 젤리 차감
          final decreaseResult =
              await CharacterService.decreaseReward(itemPrice);
          if (decreaseResult) {
            // // 젤리 차감을 성공한 경우
            // 3. 아이템 추가
            final addItemResult = await CharacterService.addItem(itemCode);
            if (addItemResult) {
              // // 아이템 추가 성공
              print('아이템 구매 성공');
              reloadAfterBuyItem();
              // 구매 성공 메시지 띄움
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ShortDialog(content: '아이템을 구매했어요!');
                },
              );
            } else {
              // // 아이템 추가 실패 -오류
            }
          } else {
            // // 젤리 차감을 실패한 경우 -오류
          }
        } else {
          // // 보유한 젤리가 아이템 가격보다 적어서 구매 불가
          print('잔액 부족');
          // 젤리가 부족하다는 메시지 메시지 띄워줌
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShortDialog(content: '젤리가 부족해요..');
            },
          );
        }
      }
    }
  }

  // 취소버튼을 눌렀을 때
  void onClickCancelItem() async {
    final tempComp = await CharacterService.getCharacterComp(); // 현재 조합 가져오기
    // 조합 변경 로직
    List<String> tempCompStr = tempComp.toString().split('');
    tempCompStr[categoryCodeLocationMap[selectedCategory]!] = '0';
    int editedComp = int.parse(tempCompStr.join());
    print('editedComp: $editedComp');
    // 변경된 조합 적용하기
    await CharacterService.editCharacterComp(editedComp);
    selectedItemIndex = -1; // 선택한 아이템 초기화
    reloadAfterChangeComp();
  }

  // 아이템 구매 후 잔여 젤리, 보유한 아이템 목록 다시 불러오는 함수
  void reloadAfterBuyItem() {
    setState(() {
      selectedItemIndex = -1; // 선택한 아이템 초기화
      // 보유한 젤리 개수 다시 불러오기
      reward = CharacterService.getMyReward();
      // 보유한 아이템 다시 불러오기
      ownedItems = CharacterService.getOwnedItems();
    });
  }

  // 조합 변경 후 다시 불러오는 함수
  void reloadAfterChangeComp() {
    setState(() {
      // 캐릭터 조합 다시 불러오기
      characterComp = CharacterService.getCharacterComp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15.0,
          ),

          // 1. 꾸미기 상점 상단
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '꾸미기 상점',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // 보유한 젤리
                Row(
                  children: [
                    GestureDetector(
                        onDoubleTap: () async {
                          final tempJelly =
                              await CharacterService.getMyReward();
                          if (tempJelly >= 10) {
                            await CharacterService.decreaseReward(10);
                          } else {
                            await CharacterService.increaseReward(10);
                          }
                          reloadAfterBuyItem();
                        },
                        child: SvgPicture.asset('assets/icons/jelly_icon.svg')),
                    const SizedBox(
                      width: 2.0,
                    ),
                    FutureBuilder<int>(
                      future: reward, // 비동기 데이터 호출
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // 데이터가 로드 중일 때 로딩 표시
                          return Text(
                            ' ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        } else if (snapshot.hasError) {
                          // 오류가 발생했을 때
                          return Text('Error: ${snapshot.error} 보유한 젤리 로딩 실패');
                        } else {
                          // 데이터가 성공적으로 로드되었을 때
                          final resultReward = snapshot.data!;
                          return Text(
                            resultReward.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. 꾸며진 캐릭터 이미지
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 40.0),
              child: FutureBuilder<int>(
                future: characterComp, // 비동기 데이터 호출
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 데이터가 로드 중일 때 로딩 표시
                    return const SizedBox(
                      height: 150.0,
                    );
                  } else if (snapshot.hasError) {
                    // 오류가 발생했을 때
                    return Text('Error: ${snapshot.error} 캐릭터 로딩 실패');
                  } else {
                    // 데이터가 성공적으로 로드되었을 때
                    final resultComp = snapshot.data!;
                    return Image.asset(
                      'assets/images/character/$resultComp.png',
                      width: 150,
                      height: 150.0,
                    );
                  }
                },
              ),
            ),
          ),
          // 경계선 + 그림자
          Container(
            width: double.maxFinite,
            height: 1.0,
            decoration: const BoxDecoration(
              color: Color(0xFFE4E3E2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // 그림자 색상
                  offset: Offset(0, 2), // 그림자의 위치 (x, y)
                  blurRadius: 5.0, // 그림자의 흐림 정도
                  spreadRadius: 0.5, // 그림자의 확산 정도
                ),
              ],
            ),
          ),

          // 3. 소품 카테고리 선택 버튼들
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Wrap(
              spacing: 18.0,
              runSpacing: 15.0,
              children: [
                ...categoryList.map((category) => SelectButtonWithoutIcon(
                    height: 32.0,
                    padding: 18.0,
                    bgColor: selectedCategory == category
                        ? const Color(0xFF6B4D38)
                        : Colors.white,
                    radius: 1000,
                    text: category,
                    textColor: selectedCategory == category
                        ? Colors.white
                        : const Color(0xFF6B4D38),
                    onPress: () {
                      onClickCategoryButton(category);
                    })),
              ],
            ),
          ),

          // 4. 소품들
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FutureBuilder<List<dynamic>>(
              future: ownedItems, // 비동기 데이터 호출
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터가 로드 중일 때 로딩 표시
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFFAD7541),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  // 오류가 발생했을 때
                  return Text('Error: ${snapshot.error} 아이템 로딩 실패');
                } else {
                  // 데이터가 성공적으로 로드되었을 때
                  final resultOwnedItemList = snapshot.data!;
                  return Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      for (int i = 0;
                          i < characterItems[selectedCategory]!.length;
                          i++) ...[
                        itemWidget(
                          i,
                          characterItems[selectedCategory]![i]['name'],
                          characterItems[selectedCategory]![i]['image'],
                          characterItems[selectedCategory]![i]['price'],
                          characterItems[selectedCategory]![i]['itemCode'],
                          characterItems[selectedCategory]![i]['isSale'],
                          resultOwnedItemList,
                        ),
                      ],
                      // 아이템 취소 버튼
                      cancelItemWidget(),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 아이템 위젯
  Widget itemWidget(int itemIndex, String name, String image, int price,
      int code, bool isSale, List<dynamic> ownedItemList) {
    // 보유한 아이템인지 확인
    bool isOwned = ownedItemList.contains(code);
    return GestureDetector(
      onTap: () {
        // 판매중일 경우만 클릭 처리
        if (isSale) {
          onClickItem(itemIndex, isOwned, price, code);
        }
      },
      child: Stack(
        children: [
          Container(
            // 아이템을 선택했을 때 테두리
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2.0,
                  color: itemIndex == selectedItemIndex
                      ? const Color(0xFF6B4D38)
                      : Colors.white),
              borderRadius: BorderRadius.circular(12.0),
            ),
            // 보유 여부에 따라 투명도를 다르게 설정
            child: Opacity(
              opacity: isOwned ? 1.0 : 0.3,
              child: Column(
                children: [
                  // 소품 이미지
                  Image.asset(image),
                  // 소품 이름
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          ),
          // 보유하지 않은 아이템일 경우 가운데에 가격을 보여줌
          if (!isOwned)
            Positioned(
              top: 40.0,
              left: 19.0,
              child: IntrinsicWidth(
                // IntrinsicWidth를 사용해서 width 최소화
                child: isSale
                    ?
                    // 1. 판매중인 아이템일 경우
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/jelly_icon.svg',
                            width: 24.0,
                            height: 24.0,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '$price',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      )
                    :
                    // 2. 판매중인 아이템이 아닐 경우
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '준비 중..',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
              ),
            )
        ],
      ),
    );
  }

  // 아이템을 취소할 위젯
  Widget cancelItemWidget() {
    return GestureDetector(
      onTap: () {
        onClickCancelItem();
      },
      child: SizedBox(
        height: 100.0,
        width: 65.0,
        // 보유 여부에 따라 투명도를 다르게 설정
        child: Column(
          children: [
            // 소품 이미지
            SizedBox(
                height: 78.0,
                width: 40.0,
                child:
                    SvgPicture.asset('assets/icons/character_cancel_icon.svg')),
            Text(
              '빼기',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
