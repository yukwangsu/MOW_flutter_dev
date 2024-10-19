import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/edit_tag.dart';
import 'package:flutter_mow/services/search_service.dart';
import 'package:flutter_mow/widgets/curation_list.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late double screenHeight; // 화면 높이 저장
  late double screenWidth; // 화면 넓이 저장
  late double latitude; // 현 위치 위도
  late double longitude; // 현 위치 경도
  bool isLoadingMap = true; // 지도가 로딩중인지 기록
  double bottomSheetHeight = 134; // 초기 높이 (134픽셀)
  double minbottomSheetHeight = 134; // 최소 높이 (134픽셀)
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode(); // 포커스 노드 추가, 가게 이름으로 검색 중인지 확인
  String selectedOrder = '거리순'; // 초기 정렬 기준: '거리순'
  int order = 1;
  String locationType = '';
  List<String> taggedList = [];
  List<String> appliedSearchTags = [];
  bool reloadWorkspaces = true;
  List<dynamic>? copyWorkspaceList = [];
  String bottomsheetMode = 'normal';
  late int workspaceId;

  @override
  void initState() {
    super.initState();
    loadTaggedList(); // 시작 시 태그 리스트 불러옴
    loadAppliedSearchTags(); // 시작 시 검색 태그 불러옴
    // TextField가 포커스될 때 콜백 설정
    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        reloadWorkspaces = false;
        //키보드가 올라와있기 때문에 최소 높이를 screenHeight*0.5 으로 설정
        minbottomSheetHeight = screenHeight * 0.5;
        if (bottomSheetHeight < screenHeight * 0.5) {
          setState(() {
            bottomSheetHeight =
                screenHeight * 0.5; // 키보드가 나타났을 때 bottomSheetHeight 조정
          });
        }
      } // TextField에 포커스가 풀렸을 때
      else if (!searchFocusNode.hasFocus) {
        // 검색할 텍스트 입력을 완료했기 때문에 Workspace 검색
        reloadWorkspaces = true;
        setState(() {
          //키보드가 내려갔기 때문에 최소 높이를 원래대로 134픽셀로 설정
          minbottomSheetHeight = 134;
        });
      }
    });
    // 위치 정보 가져오기
    getCurrentLocation();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose(); // 포커스 노드 해제
    super.dispose();
  }

  // 검색 태그 저장
  Future<void> saveAppliedSearchTags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('appliedSearchTags', appliedSearchTags);
  }

  // 검색 태그 불러오기
  Future<void> loadAppliedSearchTags() async {
    final prefs = await SharedPreferences.getInstance();
    reloadWorkspaces = true;
    setState(() {
      appliedSearchTags = prefs.getStringList('appliedSearchTags') ??
          []; // 저장된 리스트가 없으면 빈 리스트 사용
    });
  }

  // 검색 태그 수정
  void toogleAppliedSearchTags(String tagContent) async {
    if (appliedSearchTags.contains(tagContent)) {
      appliedSearchTags.remove(tagContent);
    } else {
      appliedSearchTags.add(tagContent);
    }
    // 스토리지에 저장
    await saveAppliedSearchTags();
    reloadWorkspaces = true;
    // 수정이 완료되면 setState
    setState(() {});
  }

  // 태그 리스트 불러오기
  Future<void> loadTaggedList() async {
    final prefs = await SharedPreferences.getInstance();
    reloadWorkspaces = true;
    setState(() {
      taggedList =
          prefs.getStringList('taggedList') ?? []; // 저장된 리스트가 없으면 빈 리스트 사용
    });
  }

  // 현위치 가져오기 (좌표가 이상할 경우 -> 신촌으로 고정)
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    // *** 추후에 위치 정보를 변수에 저장해야함. ***
    latitude = position.longitude < 0 ? 37.5583605 : position.latitude;
    longitude = position.longitude < 0 ? 126.9368894 : position.longitude;
    print('********latitude: ${position.latitude}');
    print('********longitude: ${position.longitude}');
    isLoadingMap = false;
    reloadWorkspaces = true;
    setState(() {});
    return position;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height; //화면 높이
    screenWidth = MediaQuery.of(context).size.width; //화면 넓이
    return Scaffold(
      resizeToAvoidBottomInset: false, //키보드가 올라와도 화면이 그대로 유지
      backgroundColor: const Color.fromARGB(255, 231, 215, 199),
      body: Stack(
        children: [
          // 지도 로딩중 화면
          if (isLoadingMap)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: SvgPicture.asset('assets/icons/login_cat.svg'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '지도 준비중...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // 지도 로딩이 끝났을 때 화면
          if (!isLoadingMap)
            NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(latitude, longitude),
                  zoom: 15,
                ),
                rotationGesturesEnable: false, // 지도 회전 금지
                scrollGesturesFriction: 0.5, // 마찰계수
                zoomGesturesFriction: 0.5, // 마찰계수
                //줌 제한 (커질수록 더 자세히 보임)
                minZoom: 12, // default is 0
                maxZoom: 17, // default is 21
                // 지도 영역을 대한민국 인근으로 제한
                extent: const NLatLngBounds(
                  southWest: NLatLng(31.43, 122.37),
                  northEast: NLatLng(38.35, 132.0),
                ),
                // 지도에 표시되는 언어를 영어로 제한
                locale: const Locale('ko'),
                // 현위치로 이동하는 버튼 비/활성화
                locationButtonEnable: false,
              ),
              onMapReady: (controller) {
                print("네이버 맵 로딩됨!");
              },
            ),

          // bottomsheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                reloadWorkspaces = false;
                setState(() {
                  // 드래그할 때 높이를 조정
                  bottomSheetHeight -= details.primaryDelta!;

                  // 최소 높이는 134, 최대 높이는 화면 높이의 0.936
                  bottomSheetHeight = bottomSheetHeight.clamp(
                      minbottomSheetHeight, screenHeight * 0.936);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: bottomSheetHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFE4E3E2), // 경계선 색상
                    width: 1.0, // 경계선 두께
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                // 모드에 따라 bottomsheet가 변함
                child: bottomsheetMode == 'normal'
                    ? normalMode()
                    : bottomsheetMode == 'detail'
                        ? detailMode()
                        : normalMode(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget normalMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //스크롤되지 않는 부분(바, 검색창, 버튼)
        Column(
          children: [
            const Bar(),
            //검색창
            searchBar(
              searchController,
            ),
            const SizedBox(height: 20),
            //카테고리, 태그 선택
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                // tag가 없을 경우 '카테고리, 태그 선택' Row가 가운데에 오는 것을 방지하고자 padding을 늘리고
                // tag가 있다면 다시 padding을 줄임.
                right: taggedList.isEmpty ? screenWidth - 281.0 : 10.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SelectButton(
                      height: 32,
                      padding: 14,
                      bgColor: const Color(0xFFFFFCF8),
                      radius: 1000,
                      text: '편집',
                      textColor: const Color(0xFF6B4D38),
                      textSize: 14.0,
                      borderColor: const Color(0xFFAD7541),
                      borderWidth: 1.0,
                      borderOpacity: 1.0,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditTag(),
                          ),
                        ).then((_) {
                          // *** 이 화면으로 돌아왔을 때 loadTaggedList를 호출 ***
                          loadTaggedList();
                          loadAppliedSearchTags();
                        });
                      },
                    ),
                    const SizedBoxWidth10(),
                    SelectButton(
                      height: 32,
                      padding: 14,
                      bgColor: const Color(0xFFFFFCF8),
                      radius: 1000,
                      text: selectedOrder, // Dynamic button text
                      textColor: const Color(0xFF6B4D38),
                      textSize: 14.0,
                      borderColor: const Color(0xFFAD7541),
                      borderWidth: 1.0,
                      borderOpacity: 0.4,
                      svgIconPath: 'assets/icons/search_place_order_icon.svg',
                      onPress: () {
                        // ***거리순 클릭시 BottomSheet 올라오게 처리***
                        showModalBottomSheet(
                          context: context,
                          // shape를 사용해서 BorderRadius 설정.
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              height: 180.0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildOrderList(context, '거리순', 1),
                                  const ListBorderLine(), //bottom sheet 경계선
                                  buildOrderList(context, '별점순', 2),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBoxWidth10(),
                    SelectButton(
                      height: 32,
                      padding: 14,
                      bgColor: const Color(0xFFFFFCF8),
                      radius: 1000,
                      text: locationType.isEmpty ? '공간구분' : locationType,
                      textColor: const Color(0xFF6B4D38),
                      textSize: 14.0,
                      borderColor: const Color(0xFFAD7541),
                      borderWidth: 1.0,
                      borderOpacity: 0.4,
                      svgIconPath: 'assets/icons/down_icon.svg',
                      onPress: () {
                        showModalBottomSheet(
                          context: context,
                          // shape를 사용해서 BorderRadius 설정.
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              height: 350.0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildPlaceList(context, '모든 공간'),
                                  const ListBorderLine(), //bottom sheet 경계선
                                  buildPlaceList(context, '카페'),
                                  const ListBorderLine(),
                                  buildPlaceList(context, '도서관'),
                                  const ListBorderLine(),
                                  buildPlaceList(context, '스터디카페'),
                                  const ListBorderLine(),
                                  buildPlaceList(context, '기타 작업공간'),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // tag 버튼
                    for (int n = 0; n < taggedList.length; n++) ...[
                      const SizedBoxWidth10(),
                      tagButtonWidget(taggedList[n]),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),

        // 스크롤되는 부분(장소 리스트)
        // 1. 장소를 reload하는 setstate 일 경우 showWorkspace 진행
        if (reloadWorkspaces)
          isLoadingMap
              //사용자의 위치를 받아오기 중
              ? Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0.0),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFFAD7541),
                          ),
                        ],
                      );
                    },
                  ),
                )
              //사용자의 위치를 받아왔을 때
              : showWorkspace(
                  searchController,
                  order,
                  locationType,
                  appliedSearchTags,
                  latitude,
                  longitude,
                ),
        // 2. bottomsheet을 올리는 setstate 일 경우 (복사본 데이터 사용)
        if (!reloadWorkspaces)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0.0),
              itemCount: copyWorkspaceList!.length,
              itemBuilder: (context, index) {
                return placeList(
                  copyWorkspaceList?[index]['workspaceId'],
                  copyWorkspaceList?[index]['workspaceName'],
                  copyWorkspaceList?[index]['workspaceType'],
                  copyWorkspaceList?[index]['starscore'],
                  copyWorkspaceList?[index]['reviewCnt'],
                  copyWorkspaceList?[index]['location'],
                  copyWorkspaceList?[index]['distance'],
                );
              },
            ),
          )
      ],
    );
  }

  Widget detailMode() {
    late String name;
    late double score;
    late int reviewCount;
    late String adress;
    late String phoneNumber;
    late int isOpen;
    late String openingHour;
    late List<String> topThreeTags;
    late String link;
    late List<String> reviews;

    //테스트용
    name = "스타벅스 연세로점";
    score = 4.3;
    reviewCount = 234;
    adress = "서울 서대문구 34나길 6";
    phoneNumber = "02-123-1231";
    isOpen = 2;
    openingHour = '수 09:00 - 21:00';
    topThreeTags = ['# 콘센트 많아요', '# 콘센트 많아요', '# 콘센트 많아요'];
    link = "https://www.yonsei.com";
    reviews = ['좋아요', '멋있어요', '깔끔해요', '좋아요', '멋있어요', '깔끔해요'];

    return Column(
      children: [
        // 스크롤되지 않는 부분[bar, arrow]
        Column(
          children: [
            // 바
            const Bar(),
            const SizedBox(
              height: 4.0,
            ),
            // 뒤로가기 아이콘
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        reloadWorkspaces = false;
                        bottomsheetMode = 'normal';
                        setState(() {});
                      },
                      child: SvgPicture.asset('assets/icons/back_arrow.svg')),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            )
          ],
        ),
        // 스크롤되는 부분 (추후 FutureBuilder 사용)
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 0.0),
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        // 가게 이름
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SvgPicture.asset('assets/icons/share_icon.svg')
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        // 가게 별점, 리뷰
                        Row(
                          children: [
                            // 별점
                            for (int i = 0; i < score.round(); i++) ...[
                              SvgPicture.asset(
                                  'assets/icons/star_fill_icon.svg'),
                            ],
                            for (int i = 0; i < 5 - 4.round(); i++) ...[
                              SvgPicture.asset(
                                  'assets/icons/star_unfill_icon.svg'),
                            ],
                            const SizedBox(
                              width: 8.0,
                            ),
                            // 리뷰 개수
                            Text(
                              '($reviewCount)',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        // 가게 위치, 연락처
                        Row(
                          children: [
                            // 주소
                            Text(
                              adress.substring(0, 7),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBoxWidth4(),
                            SvgPicture.asset(
                                'assets/icons/dropdown_down_padding.svg'),
                            const SizedBox(
                              width: 58.0,
                            ),
                            Text(
                              '연락처',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBoxWidth4(),
                            SvgPicture.asset(
                                'assets/icons/dropdown_down_padding.svg'),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        // 현재 영업 유무, 영업 시간 등 표시
                        Row(
                          children: [
                            Text(
                              isOpen == 0
                                  ? '영업중'
                                  : isOpen == 1
                                      ? '브레이크 타임'
                                      : isOpen == 2
                                          ? '영업종료'
                                          : '휴무',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: const Color(0xFF6B4D38)),
                            ),
                            const SizedBoxWidth4(),
                            Text(
                              '・',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: const Color(0xFF6B4D38)),
                            ),
                            const SizedBoxWidth4(),
                            Text(
                              openingHour,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: const Color(0xFF6B4D38)),
                            ),
                            const SizedBoxWidth4(),
                            SvgPicture.asset(
                                'assets/icons/dropdown_down_padding.svg'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Top3 태그
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < topThreeTags.length; i++) ...[
                            SelectButton(
                              height: 37.0,
                              padding: 8.0,
                              bgColor: const Color(0xFFFFF8F1),
                              radius: 12.0,
                              text: topThreeTags[i],
                              textColor: const Color(0xFF6B4D38),
                              textSize: 16.0,
                              onPress: () {},
                            ),
                            if (i < topThreeTags.length - 1)
                              const SizedBoxWidth6(), // 마지막 항목 뒤에는 추가 안되도록
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBoxHeight20(),
                  // 저장하기, 길찾기 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectButton(
                        height: 36.0,
                        padding: 10.0,
                        bgColor: const Color(0xFFFFFCF8),
                        radius: 12.0,
                        text: '저장하기',
                        textColor: const Color(0xFF6B4D38),
                        textSize: 16.0,
                        borderColor: const Color(0xFF6B4D38),
                        borderOpacity: 1.0,
                        borderWidth: 1.0,
                        lineHeight: 1.5,
                        svgIconPath: "assets/icons/unsave_icon.svg",
                        isIconFirst: true,
                        onPress: () {},
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      SelectButton(
                        height: 36.0,
                        padding: 10.0,
                        bgColor: const Color(0xFFFFFCF8),
                        radius: 12.0,
                        text: '길찾기',
                        textColor: const Color(0xFF6B4D38),
                        textSize: 16.0,
                        borderColor: const Color(0xFF6B4D38),
                        borderOpacity: 1.0,
                        borderWidth: 1.0,
                        lineHeight: 1.5,
                        svgIconPath: "assets/icons/navigation_icon.svg",
                        isIconFirst: true,
                        onPress: () {},
                      ),
                    ],
                  ),
                  const SizedBoxHeight30(),
                  // 상세정보, 리뷰 등등
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ListBorderLine(),
                        const SizedBoxHeight30(),
                        //상세정보
                        Text(
                          '상세정보',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 28,
                          width: double.infinity,
                        ),
                        Text(
                          '웹사이트',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          link,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                        ),
                        const SizedBoxHeight30(),
                        const ListBorderLine(),
                        const SizedBoxHeight30(),
                        //리뷰
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '리뷰',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/review_icon.svg'),
                                const SizedBoxWidth4(),
                                Text(
                                  '리뷰쓰기',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: const Color(0xFF6B4D38),
                                      ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < reviews.length; i++) ...[
                              reviewList(reviews[i]),
                              if (i < reviews.length - 1)
                                const SizedBox(
                                  height: 32,
                                ), // 마지막 항목 뒤에는 추가 안되도록
                            ],
                          ],
                        ),
                        const SizedBox(
                          height: 72,
                        ),
                      ],
                    ),
                  ),

                  // 큐레이션 상세페이지 (listview 사용-> 옆으로 스크롤)
                  //임시 코드
                  // const CurationList(
                  //   title: '큐레이션 제목입니다.',
                  //   placeName: '상호명',
                  //   thumb:
                  //       'https://media.istockphoto.com/id/1400194993/ko/%EC%82%AC%EC%A7%84/%EC%B9%B4%ED%91%B8%EC%B9%98%EB%85%B8-%EC%98%88%EC%88%A0%EC%A7%81.jpg?s=612x612&w=0&k=20&c=lum31BwhnHLtD647HI-RGcWRSNyZEBQ063C2rrNYdoE=',
                  //   curationId: 1,
                  // ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget showWorkspace(
    TextEditingController controller, // 입력값 controller
    int order,
    String locationType,
    List<String> appliedSearchTags,
    double latitude,
    double longitute,
  ) {
    return FutureBuilder<List<dynamic>?>(
      future: SearchService.searchPlace(
        controller.text,
        order,
        locationType,
        appliedSearchTags,
        latitude,
        longitute,
      ), // 비동기 데이터 호출
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터가 로드 중일 때 로딩 표시
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0.0),
              itemCount: 1,
              itemBuilder: (context, index) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFFAD7541),
                    ),
                  ],
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          // 오류가 발생했을 때
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0.0),
              itemCount: 1,
              itemBuilder: (context, index) {
                return Text('Error: ${snapshot.error}');
              },
            ),
          );
        } else {
          // 데이터가 성공적으로 로드되었을 때
          print("!!!!!!!!!!!!장소 리스트 로딩 완료!!!!!!!!!!!!!!!");
          final workspaceList = snapshot.data;
          copyWorkspaceList = workspaceList; //데이터 복사
          print('----------rebuild showWorkspace search result----------');
          print('workspaceList: $workspaceList');
          print('your keyword: ${controller.text}');
          print('your order: $order');
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0.0),
              itemCount: workspaceList!.length,
              itemBuilder: (context, index) {
                return placeList(
                  workspaceList[index]['workspaceId'],
                  workspaceList[index]['workspaceName'],
                  workspaceList[index]['workspaceType'],
                  workspaceList[index]['starscore'],
                  workspaceList[index]['reviewCnt'],
                  workspaceList[index]['location'],
                  workspaceList[index]['distance'],
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget placeList(
    int id,
    String name,
    String category,
    double score,
    int reviewCnt,
    String address,
    double distance,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // place list
          Column(
            children: [
              // 장소 클릭시 detail 화면으로 넘어감.
              GestureDetector(
                behavior: HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
                onTap: () {
                  bottomsheetMode = 'detail';
                  reloadWorkspaces = false;
                  workspaceId = id;
                  print('workspaceId: $id');
                  setState(() {});
                },
                child: Row(
                  children: [
                    //가게 이미지
                    Container(
                      decoration: const BoxDecoration(color: Colors.black),
                      width: 80.0,
                      height: 80.0,
                    ),
                    const SizedBox(
                      width: 14.0,
                    ),
                    //가게 정보
                    Expanded(
                      child: Column(
                        children: [
                          //가게 정보 첫번째 줄: 이름, 카테고리
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  //가게 이름
                                  Text(
                                    name.length > 9 //가게 이름 크기 제한
                                        ? '${name.substring(0, 9)}...'
                                        : name,
                                    // name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBoxWidth10(),
                                  //가게 카테고리
                                  Text(
                                    category.length > 8 //가게 카테고리 크기 제한
                                        ? '${category.substring(0, 8)}...'
                                        : category,
                                    // category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: const Color(0xFFC3C3C3)),
                                  ),
                                ],
                              ),
                              SvgPicture.asset('assets/icons/unsave_icon.svg'),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          // 가게 정보 두번째 줄: 별점, 리뷰
                          Row(
                            children: [
                              // 별점
                              for (int i = 0; i < score.round(); i++) ...[
                                SvgPicture.asset(
                                    'assets/icons/star_fill_icon.svg'),
                              ],
                              for (int i = 0; i < 5 - score.round(); i++) ...[
                                SvgPicture.asset(
                                    'assets/icons/star_unfill_icon.svg'),
                              ],
                              const SizedBox(
                                width: 8.0,
                              ),
                              // 리뷰 개수
                              Text(
                                '($reviewCnt)',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          // 가게 정보 세번째 줄: 위치, 거리, 연락처
                          Row(
                            children: [
                              // 주소
                              Text(
                                address.substring(0, 7),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBoxWidth4(),
                              SvgPicture.asset(
                                  'assets/icons/dropdown_down_padding.svg'),
                              const SizedBoxWidth4(),
                              // 거리
                              Text(
                                '${distance.round()}m',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                '연락처',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBoxWidth4(),
                              SvgPicture.asset(
                                  'assets/icons/dropdown_down_padding.svg'),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //list padding
              const SizedBox(
                height: 24.0,
              ),
              const ListBorderLine(),
              const SizedBox(
                height: 24.0,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget reviewList(String content) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget buildOrderList(
      BuildContext context, String listContent, int orderContent) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // default Padding을 0으로 설정
      title: Text(
        listContent,
        style: TextStyle(
          color:
              (order == orderContent) ? const Color(0xFF6B4D38) : Colors.black,
          fontSize: 16.0,
          fontWeight:
              (order == orderContent) ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: () {
        reloadWorkspaces = true;
        setState(() {
          selectedOrder = listContent;
          order = orderContent;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget buildPlaceList(BuildContext context, String listContent) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // default Padding을 0으로 설정
      title: Text(
        listContent,
        style: TextStyle(
          color: (locationType == listContent)
              ? const Color(0xFF6B4D38)
              : Colors.black,
          fontSize: 16.0,
          fontWeight:
              (locationType == listContent) ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: () {
        reloadWorkspaces = true;
        setState(() {
          locationType = listContent;
        });
        //Navigator.of(context).pop()이 ModalBottomSheet 내의 context에만 영향을 주어,
        //다른 화면으로 돌아가지 않고, ModalBottomSheet만 닫는다.
        Navigator.of(context).pop();
      },
    );
  }

  Widget searchBar(
    TextEditingController searchController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: searchBox(
              const Color(0xFF6B4D38),
              searchController,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          SvgPicture.asset('assets/icons/circle_icon.svg'),
        ],
      ),
    );
  }

  //검색창
  Widget searchBox(
    Color borderColor,
    TextEditingController controller, // 입력값 controller
  ) {
    return SizedBox(
      height: 38.0,
      child: TextField(
        controller: controller, // 입력값 controller
        focusNode: searchFocusNode, // 포커스 노드 연결
        cursorColor: const Color(0xFF6B4D38), // 커서 색깔
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
              width: 1, // 테두리 두께 설정
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor, // 클릭 시 색상 변경
              width: 1, // 테두리 두께 설정
            ),
            borderRadius: BorderRadius.circular(12), // 테두리 모서리 둥글게 설정
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          // TextField내부에 아이콘 추가
          suffixIcon: GestureDetector(
            onTap: () async {
              // 돋보기 클릭시 setState를 통해 workspace를 다시 불러온다.
              reloadWorkspaces = true;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: SvgPicture.asset(
                'assets/icons/search_icon.svg',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tagButtonWidget(String tagName) {
    return SelectButton(
      height: 32.0,
      padding: 14.0,
      bgColor: appliedSearchTags.contains(tagName)
          ? const Color(0xFF6B4D38)
          : Colors.white,
      radius: 1000,
      text: tagName,
      textColor: appliedSearchTags.contains(tagName)
          ? Colors.white
          : const Color(0xFF6B4D38),
      textSize: 14.0,
      borderWidth: appliedSearchTags.contains(tagName) ? null : 1.0,
      borderColor:
          appliedSearchTags.contains(tagName) ? null : const Color(0xFFAD7541),
      borderOpacity: appliedSearchTags.contains(tagName) ? null : 0.4,
      onPress: () {
        toogleAppliedSearchTags(tagName);
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

class SizedBoxHeight30 extends StatelessWidget {
  const SizedBoxHeight30({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30.0,
    );
  }
}

class SizedBoxHeight24 extends StatelessWidget {
  const SizedBoxHeight24({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24.0,
    );
  }
}

class SizedBoxHeight20 extends StatelessWidget {
  const SizedBoxHeight20({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20.0,
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

class SizedBoxWidth4 extends StatelessWidget {
  const SizedBoxWidth4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 4.0,
    );
  }
}

class Bar extends StatelessWidget {
  const Bar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF8A5E34),
              borderRadius: BorderRadius.circular(1000.0),
            ),
          ),
        ),
      ],
    );
  }
}
