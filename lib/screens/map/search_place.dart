import 'package:flutter/material.dart';
import 'package:flutter_mow/models/place_list_model.dart';
import 'package:flutter_mow/screens/map/write_curation.dart';
import 'package:flutter_mow/services/search_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPlace extends StatefulWidget {
  final double userLatitude;
  final double userLongitude;

  const SearchPlace({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  State<SearchPlace> createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(); // 포커스 노드 추가, 가게 이름으로 검색 중인지 확인
  late Future<PlaceListModel> placeModel;

  // url로 이동하는 함수
  Future<void> _openWebsite(String link) async {
    final Uri url = Uri.parse(link);
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // 기본 브라우저에서 열기
      );
    } catch (e) {
      print('링크 열기 실패: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        // 검색할 텍스트 입력을 완료했기 때문에 다시 검색
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    placeModel = SearchService.searchPlaceList(
      searchController.text,
      1,
      '',
      [],
      widget.userLatitude,
      widget.userLongitude,
    );
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
                      '공간을 선택해주세요',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 18.0,
              ),
              searchBar(searchController),
              //스크롤 O
              const SizedBox(
                height: 20.0,
              ),
              FutureBuilder(
                future: placeModel,
                builder: (context, snapshot) {
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
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<WorkspaceDtoModel> placeList =
                        snapshot.data!.workspaceDtoList;
                    return Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(top: 0.0),
                        itemCount: placeList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == placeList.length) {
                            return addSpaceWidget();
                          } else {
                            return placeElement(placeList[index]);
                          }
                          return null;
                        },
                        //separatorBuilder는 사이에 공간을 만드는 역할.
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 24.0),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //장소 검색창
  Widget searchBar(
    TextEditingController searchController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: searchBox(
              const Color(0xFF6B4D38),
              searchController,
            ),
          ),
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
          hintText: '지역, 상호명, 키워드 검색',
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: const Color(0xFFC3C3C3)),
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
              setState(() {
                FocusScope.of(context).unfocus();
              });
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

// 장소 리스트
  Widget placeElement(
    WorkspaceDtoModel place,
  ) {
    return Column(
      children: [
        // place list
        GestureDetector(
          behavior: HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
          onTap: () async {
            print('workspaceId: ${place.workspaceId}');
            // WriteCurationScreen으로 이동했다가 돌아오면 curation_place mode로 돌아감
            final selectedSpaceId = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WriteCurationScreen(workspaceId: place.workspaceId),
              ),
            );
            // 1. 큐레이션을 작성한 경우 작성한 장소의 curation_place mode로 돌아감
            if (selectedSpaceId != null) {
              print(
                  '큐레이션 작성 성공[search_place.dart]: selectedSpaceId: $selectedSpaceId');
              Navigator.pop(context, selectedSpaceId);
            } else {
              print(
                  '큐레이션 작성 실패[search_place.dart]: selectedSpaceId: $selectedSpaceId');
              // 2. 장소는 선택했지만 큐레이션을 작성하지 않은경우 다시 장소 선택화면을 보여줌
            }
          },
          child: Container(
            padding: const EdgeInsets.only(
                top: 6.0, right: 8.0, bottom: 6.0, left: 8.0),
            decoration: BoxDecoration(
              //배경색
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06), // 그림자 색상
                  offset: const Offset(0, 4), // 그림자 위치 (x, y)
                  blurRadius: 4.0, // 블러 정도
                  spreadRadius: 0.0, // 확산 정도
                ),
              ],
            ),
            child: SizedBox(
              //SizedBox를 사용함으로써 height를 최대 크기로 고정함
              height: 80.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 큐레이션 이미지
                  Container(
                      width: 80.0,
                      height: 80.0,
                      color: const Color(0xFFD9D9D9), // 기본 배경색을 회색으로 설정
                      child: place.workspaceThumbnailUrl == 'no image'
                          ?
                          // 1. 이미지가 없을 경우
                          Image.asset('assets/images/default_image_80.png')

                          // 2. 이미지가 있을 경우
                          : Image.network(
                              place.workspaceThumbnailUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                    color: const Color(
                                        0xFFD9D9D9)); // 로딩 중일 때 회색 화면 유지
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                    color: const Color(
                                        0xFFD9D9D9)); // 로딩 실패 시 회색 화면 표시
                              },
                            )),

                  const SizedBox(
                    width: 14.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 가게 이름
                        Text(
                          place.workspaceName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        // 가게 종류
                        Text(
                          place.workspaceType,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: const Color(0xFFC3C3C3)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 장소제보 칸
  Widget addSpaceWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 20.0,
        ),
        GestureDetector(
          onTap: () async {
            // 구글 폼으로 이동
            _openWebsite('https://forms.gle/HLVaeMseWx5vkNFR8');
          },
          child: Container(
            height: 60.0,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 219, 219, 219),
                borderRadius: BorderRadius.circular(10.0)),
            child: Center(
              child: Text('장소제보하기',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
