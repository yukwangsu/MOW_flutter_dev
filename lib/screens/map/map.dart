import 'package:flutter/material.dart';
import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/screens/map/add_review.dart';
import 'package:flutter_mow/screens/map/edit_tag.dart';
import 'package:flutter_mow/services/search_service.dart';
import 'package:flutter_mow/widgets/button_main.dart';
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
  bool reloadDetailspace = false;
  late int workspaceId;
  late Future<PlaceDetailModel> place;
  //리뷰 작성
  num addReviewScore = 0;
  int addReviewWidenessDegree = -1;
  int addReviewChairDegree = -1;
  int addReviewOutletDegree = -1;
  final TextEditingController addReviewTextcontroller = TextEditingController();

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
                        : reviewMode(),
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus(); // 화면의 다른 곳을 클릭하면 포커스 해제
              },
              child: Padding(
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
    // //테스트용
    // late String name;
    // late double score;
    // late int reviewCount;
    // late String adress;
    // late String phoneNumber;
    // late int isOpen;
    // late String openingHour;
    // late List<String> topThreeTags;
    // late String link;
    // late List<String> reviews;

    // //테스트용
    // name = "스타벅스 연세로점";
    // score = 4.3;
    // reviewCount = 234;
    // adress = "서울 서대문구 34나길 6";
    // phoneNumber = "02-123-1231";
    // isOpen = 2;
    // openingHour = '수 09:00 - 21:00';
    // topThreeTags = ['# 콘센트 많아요', '# 콘센트 많아요', '# 콘센트 많아요'];
    // link = "https://www.yonsei.com";
    // reviews = ['좋아요', '멋있어요', '깔끔해요', '좋아요', '멋있어요', '깔끔해요'];

    //처음 들어왔을 때만 api요청하기. bottomsheet을 조절하면서 발생하는 setstate로는
    //api를 요청하지 않는다.
    if (reloadDetailspace) {
      place = SearchService.getPlaceById(workspaceId);
      reloadDetailspace = false;
    }

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
        // 스크롤되는 부분
        FutureBuilder(
            future: place,
            builder: (context, snapshot) {
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
                // 정상적으로 데이터를 가져왔을 때
                PlaceDetailModel placeDetail = snapshot.data!;
                return (Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0.0),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                // 가게 이름
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      placeDetail.workspaceName,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    SvgPicture.asset(
                                        'assets/icons/share_icon.svg')
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                // 가게 별점, 리뷰
                                Row(
                                  children: [
                                    // 별점
                                    for (int i = 0;
                                        i < placeDetail.starscore.round();
                                        i++) ...[
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
                                      '(${placeDetail.reviewCnt})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0),
                                // 가게 위치, 연락처
                                Row(
                                  children: [
                                    // 주소
                                    Text(
                                      placeDetail.location.substring(0, 7),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBoxWidth4(),
                                    SvgPicture.asset(
                                        'assets/icons/dropdown_down_padding.svg'),
                                    const SizedBox(
                                      width: 58.0,
                                    ),
                                    Text(
                                      '연락처',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
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
                                      placeDetail.workspaceStatus == 0
                                          ? '영업중'
                                          : placeDetail.workspaceStatus == 1
                                              ? '브레이크 타임'
                                              : placeDetail.workspaceStatus == 2
                                                  ? '영업종료'
                                                  : '휴무',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: const Color(0xFF6B4D38)),
                                    ),
                                    const SizedBoxWidth4(),
                                    Text(
                                      '・',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: const Color(0xFF6B4D38)),
                                    ),
                                    const SizedBoxWidth4(),
                                    // 영업시간
                                    Text(
                                      setOpenHour(
                                          placeDetail.workspaceOperationTime),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 21.5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SelectButton(
                                    height: 37.0,
                                    padding: 8.0,
                                    bgColor: const Color(0xFFFFF8F1),
                                    radius: 12.0,
                                    text:
                                        '# 콘센트 ${placeDetail.outletDegree == 0 ? '많아요' : placeDetail.outletDegree == 1 ? '보통이에요' : '적어요'}',
                                    textColor: const Color(0xFF6B4D38),
                                    textSize: 16.0,
                                    onPress: () {},
                                  ),
                                  const SizedBoxWidth6(),
                                  SelectButton(
                                    height: 37.0,
                                    padding: 8.0,
                                    bgColor: const Color(0xFFFFF8F1),
                                    radius: 12.0,
                                    text:
                                        '# 공간 ${placeDetail.widenessDegree == 0 ? '넓어요' : placeDetail.widenessDegree == 1 ? '보통이에요' : '좁아요'}',
                                    textColor: const Color(0xFF6B4D38),
                                    textSize: 16.0,
                                    onPress: () {},
                                  ),
                                  const SizedBoxWidth6(),
                                  SelectButton(
                                    height: 37.0,
                                    padding: 8.0,
                                    bgColor: const Color(0xFFFFF8F1),
                                    radius: 12.0,
                                    text:
                                        '# 좌석 ${placeDetail.chairDegree == 0 ? '많아요' : placeDetail.chairDegree == 1 ? '보통이에요' : '적어요'}',
                                    textColor: const Color(0xFF6B4D38),
                                    textSize: 16.0,
                                    onPress: () {},
                                  ),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  placeDetail.spaceUrl,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '리뷰',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    GestureDetector(
                                      // *** 빈 공간까지 터치 감지 ***
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddReview(),
                                          ),
                                        ).then((_) {
                                          // *** 이 화면으로 돌아왔을 때 디테일 화면을 다시 로딩 => 리뷰 없데이트***
                                          reloadWorkspaces = true;
                                          bottomsheetMode = 'detail';
                                          setState(() {});
                                        });
                                      },
                                      child: Row(
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
                                                  color:
                                                      const Color(0xFF6B4D38),
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                placeDetail.reviews.isEmpty
                                    //리뷰가 존재하지 않을 때
                                    ? const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '첫 리뷰를 남겨주세요!',
                                            style: TextStyle(
                                                color: Color(0xffc3c3c3)),
                                          ),
                                        ],
                                      )
                                    // 리뷰가 존재할 때
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (int i = 0;
                                              i < placeDetail.reviews.length;
                                              i++) ...[
                                            reviewList(placeDetail.reviews[i]),
                                            if (i <
                                                placeDetail.reviews.length - 1)
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
                ));
              }
            }),
      ],
    );
  }

  Widget reviewMode() {
    return Column(children: [
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      //초기화 해야하는 변수들
                      addReviewScore = 0;
                      addReviewWidenessDegree = -1;
                      addReviewChairDegree = -1;
                      addReviewOutletDegree = -1;
                      addReviewTextcontroller.text = '';
                      //
                      reloadWorkspaces = true;
                      bottomsheetMode = 'detail';
                      setState(() {});
                    },
                    child: SvgPicture.asset('assets/icons/back_icon.svg')),
              ],
            ),
          ),
          const SizedBox(
            height: 28.0,
          )
        ],
      ),
      //스크롤 되는 부분
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0.0),
          itemCount: 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              // *** 빈 공간까지 터치 감지 ***
              behavior: HitTestBehavior.opaque,
              // 리뷰가 아닌 다른 공간 터치시 unfocus
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(children: [
                  //리뷰 작성
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text('리뷰 작성'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  const Row(
                    children: [
                      Text('별점'),
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
                      for (int i = 0; i < 5 - addReviewScore.round(); i++) ...[
                        GestureDetector(
                            onTap: () {
                              addReviewScore = addReviewScore.round() + i + 1;
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
                  const Row(
                    children: [
                      Text('태그'),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Row(
                    children: [
                      Text('해당 공간에 어울리는 태그를 골라주세요!'),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Row(
                    children: [
                      Text('공간'),
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
                  const Row(
                    children: [
                      Text('좌석 수'),
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
                  const Row(
                    children: [
                      Text('콘센트 수'),
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
                  const Row(
                    children: [
                      Text('추가적으로 어떤 태그가 어울릴까요? (pass)'),
                    ],
                  ),
                  //추가 태그 선택 (생략)
                  const SizedBox(
                    height: 56,
                  ),
                  //줄글 리뷰
                  const Row(
                    children: [
                      Text('줄글리뷰'),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Row(
                    children: [
                      Text('줄글리뷰 작성시 1젤리를 추가로 더 드려요!!'),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //줄글리뷰 입력칸(생략)
                  TextField(
                    controller: addReviewTextcontroller,
                    focusNode: searchFocusNode,
                    maxLines: 7, // 여러 줄 입력 가능
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '리뷰를 입력하세요',
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
                        onPress: () {}),
                  ),
                  const SizedBox(
                    height: 56,
                  ),
                ]),
              ),
            );
          },
        ),
      )
    ]);
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
                  reloadDetailspace = true;
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
                                setDistance(distance),
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

  //거리를 입력받으면 m, km로 반환
  String setDistance(double distance) {
    late num adjustDistance;
    if (distance > 1) {
      adjustDistance = (distance * 10).round() / 10;
      return '${adjustDistance}km';
    } else {
      adjustDistance = (distance * 1000).round();
      return '${adjustDistance}m';
    }
  }

  String setOpenHour(Map<String, String> hour) {
    // 현재 요일 가져오기 (0: 월요일, 6: 일요일)
    int currentWeekday = DateTime.now().weekday;

    // 요일을 Map의 키와 연결 및 첫 글자 정의
    String day;
    String dayInitial; // 요일의 첫 글자
    switch (currentWeekday) {
      case 1:
        day = 'Monday';
        dayInitial = '월';
        break;
      case 2:
        day = 'Tuesday';
        dayInitial = '화';
        break;
      case 3:
        day = 'Wednesday';
        dayInitial = '수';
        break;
      case 4:
        day = 'Thursday';
        dayInitial = '목';
        break;
      case 5:
        day = 'Friday';
        dayInitial = '금';
        break;
      case 6:
        day = 'Saturday';
        dayInitial = '토';
        break;
      case 7:
        day = 'Sunday';
        dayInitial = '일';
        break;
      default:
        day = 'Unknown';
        dayInitial = '';
    }

    // 해당 요일의 영업 시간을 반환 (없으면 기본값으로 '정보 없음')
    String hours = hour[day] ?? '정보 없음';

    // 요일 첫 글자와 함께 반환
    return '$dayInitial $hours';
  }

  // List<String> setTopThreeTag(String tags) {
  //     List<int> list = tags.split(',')
  //                     .map(int.parse)
  //                     .take(3) // 처음 3개의 요소만 가져옴
  //                     .toList();

  // }

  Widget reviewList(dynamic reviewObj) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/icons/review_user_default_img.svg'),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reviewObj.userNickname,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                //reviewObj.createdAt.year 는 int 타입이므로 String으로 변환
                Text(
                  '${reviewObj.createdAt.year.toString()}. ${reviewObj.createdAt.month.toString().padLeft(2, '0')}. ${reviewObj.createdAt.day.toString().padLeft(2, '0')}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: const Color(0xFFC3C3C3)),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          reviewObj.reviewText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
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

  //장소 검색창
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
