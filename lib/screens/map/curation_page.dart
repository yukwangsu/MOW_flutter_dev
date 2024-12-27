import 'package:flutter/material.dart';
import 'package:flutter_mow/models/curation_page_model.dart';
import 'package:flutter_mow/models/place_detail_model.dart';
import 'package:flutter_mow/services/curation_service.dart';
import 'package:flutter_mow/services/search_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/appbar_back_edit.dart';
import 'package:flutter_mow/widgets/select_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CurationPage extends StatefulWidget {
  final int curationId;
  final int workspaceId;

  const CurationPage({
    super.key,
    required this.curationId,
    required this.workspaceId,
  });

  @override
  State<CurationPage> createState() => _CurationPageState();
}

class _CurationPageState extends State<CurationPage> {
  late Future<CurationPageModel> curation;
  late Future<PlaceDetailModel> workspace;
  late SharedPreferences prefs;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    //큐레이션 api 호출
    curation = CurationService.getCurationById(widget.curationId, 0, 0, 20);
    //장소 api 호출
    workspace = SearchService.getPlaceById(widget.workspaceId);
    initPrefs();
  }

  //SharedPreferences를 사용해서 좋아요를 누른 curation인지 확인.
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedCurations = prefs.getStringList('likedCurations');
    //likedCurations StringList가 있으면 curationId가 likedCurations에 있는지 확인
    if (likedCurations != null) {
      //curationId가 likedCurations에 있으면 isLiked = true로 설정.
      if (likedCurations.contains(widget.curationId.toString()) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      //likedCurations StringList가 없으면 만들기
      await prefs.setStringList('likedCurations', []);
    }
  }

  onHeartTap() async {
    final likedCurations = prefs.getStringList('likedCurations');
    if (likedCurations != null) {
      if (isLiked) {
        await CurationService.cancelLikeCuration(widget.curationId);
        likedCurations.remove(widget.curationId.toString());
      } else {
        await CurationService.likeCuration(widget.curationId);
        likedCurations.add(widget.curationId.toString());
      }
      await prefs.setStringList('likedCurations', likedCurations);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarBackEdit(
          workspaceId: widget.workspaceId, curationId: widget.curationId),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 18.0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: curation,
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
                        return Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFD9D9D9),
                              ),
                              width: double.infinity,
                              height: 368,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // 큐레이션 배경 이미지(첫번 째 사진)
                                  snapshot.data!.imageList.isEmpty
                                      // 이미지가 없을 경우
                                      ? Container(
                                          color: const Color(0xFFD9D9D9))
                                      // 이미지가 있을 경우
                                      : Image.network(
                                          snapshot.data!.imageList[0],
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                                color: const Color(
                                                    0xFFD9D9D9)); // 로딩 중일 때 회색 화면 유지
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                                color: const Color(
                                                    0xFFD9D9D9)); // 로딩 실패 시 회색 화면 표시
                                          },
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, bottom: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //태그 (최대 2개이긴 하지만 혹시 모르니 좌우로 스크롤 가능하게)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (int n = 0;
                                                  n <
                                                      snapshot
                                                          .data!
                                                          .featureTagsList
                                                          .length;
                                                  n++) ...[
                                                curationPageTagWidget(snapshot
                                                    .data!.featureTagsList[n]),
                                                const SizedBox(
                                                  width: 6.0,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        //큐레이션 제목
                                        Column(
                                          children: [
                                            Text(
                                              snapshot.data!.curationTitle,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                shadows: [
                                                  Shadow(
                                                    // 그림자의 x, y 이동량
                                                    offset: const Offset(1, 1),
                                                    blurRadius:
                                                        10.0, // 그림자 흐림 정도
                                                    color: Colors.white
                                                        .withOpacity(
                                                            1.0), // 그림자 색상 및 투명도
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        //큐레이션 작성일
                                        Row(
                                          children: [
                                            Text(
                                              formatDateTime(
                                                  snapshot.data!.createdAt),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //큐레이션 작성자 정보
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/curation_user_default_img.svg'),
                                      const SizedBox(
                                        width: 6.0,
                                      ),
                                      Text(
                                        snapshot.data!.userNickname,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: const Color(0xFFC3C3C3)),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                  //이미지(최대 열장)
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        snapshot.data!.imageList.length,
                                        (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          int currentIndex =
                                                              index;
                                                          return SizedBox(
                                                            height: 500.0,
                                                            child: PageView
                                                                .builder(
                                                              controller:
                                                                  PageController(
                                                                      initialPage:
                                                                          index),
                                                              itemCount:
                                                                  snapshot
                                                                      .data!
                                                                      .imageList
                                                                      .length,
                                                              onPageChanged:
                                                                  (newIndex) {
                                                                setState(() {
                                                                  currentIndex =
                                                                      newIndex;
                                                                });
                                                              },
                                                              itemBuilder:
                                                                  (context,
                                                                      pageIndex) {
                                                                return Container(
                                                                  color: Colors
                                                                      .black,
                                                                  child: Image
                                                                      .network(
                                                                    snapshot.data!
                                                                            .imageList[
                                                                        pageIndex],
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    loadingBuilder:
                                                                        (context,
                                                                            child,
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null)
                                                                        return child;
                                                                      return Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          value: loadingProgress.expectedTotalBytes != null
                                                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                              : null,
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return const Center(
                                                                        child:
                                                                            Text(
                                                                          '이미지를 불러올 수 없습니다.',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: 180,
                                                height: 180,
                                                color: const Color(0xFFD9D9D9),
                                                child: Image.network(
                                                  snapshot
                                                      .data!.imageList[index],
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Container(
                                                        color: const Color(
                                                            0xFFD9D9D9));
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                  //큐레이션 글
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data!.text,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 200,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 70.0,
                                  ),
                                  Container(
                                    height: 2.0,
                                    width: 18.0,
                                    color: const Color(0xFF6B4D38),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  //가게 정보
                                  //FutureBuilder로 불러오기
                                  FutureBuilder(
                                      future: workspace,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // 데이터가 로드 중일 때 로딩 표시
                                          return const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: Color(0xFFAD7541),
                                              ),
                                            ],
                                          );
                                        } else if (snapshot.hasError) {
                                          // 오류가 발생했을 때
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          // 장소를 성공적으로 불러왔을 때
                                          return Column(
                                            children: [
                                              // 상호명
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 75.0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '상호명',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data!.workspaceName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              // 주소
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 75.0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '주소',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.location,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              //영업시간
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 75.0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '영업시간',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  openHourWidget(snapshot.data!
                                                      .workspaceOperationTime),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              //가게 URL
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 75.0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'URL',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _openWebsite(snapshot
                                                          .data!.spaceUrl);
                                                    },
                                                    child: Text(
                                                      '홈페이지로 이동하기',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   snapshot.data!.spaceUrl,
                                                  //   overflow:
                                                  //       TextOverflow.ellipsis,
                                                  //   maxLines: 2,
                                                  //   style: Theme.of(context)
                                                  //       .textTheme
                                                  //       .titleSmall,
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 92.0,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // 큐레이션 좋아요 버튼
          Positioned(
            bottom: 40.0,
            left: 20.0,
            child: GestureDetector(
              onTap: () {
                onHeartTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // 동그라미 모양 설정
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // 그림자 색상과 투명도
                      blurRadius: 5.0, // 흐림 정도
                      spreadRadius: 0.5, // 확산 정도
                      offset: const Offset(0, 3), // 그림자의 위치 (x, y)
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  isLiked
                      ? 'assets/icons/curation_like_button_filled_icon.svg'
                      : 'assets/icons/curation_like_button_unfilled_icon.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget curationPageTagWidget(String tagName) {
    return SelectButton(
        height: 24,
        padding: 12,
        bgColor: Colors.white,
        radius: 1000,
        text: tagName,
        textColor: const Color(0xFF9D9D9D),
        textSize: 12.0,
        onPress: () {});
  }

  Widget openHourWidget(Map<String, String> openHour) {
    List<String> daysOfWeek = [
      '월요일',
      '화요일',
      '수요일',
      '목요일',
      '금요일',
      '토요일',
      '일요일',
    ];
    List<String> daysOfWeekFirstWord = [
      '월',
      '화',
      '수',
      '목',
      '금',
      '토',
      '일',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int n = 0; n < daysOfWeek.length; n++) ...[
          Row(
            children: [
              Text(
                daysOfWeekFirstWord[n],
                style: Theme.of(context).textTheme.titleSmall,
              ),
              openHour[daysOfWeek[n]] == null
                  ? Text(
                      '  (알 수 없음)',
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  : Text(
                      '  ${openHour[daysOfWeek[n]]}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
        ],
      ],
    );
  }

  String formatDateTime(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month =
        dateTime.month.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 0 추가
    String day = dateTime.day.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 0 추가
    return '$year.$month.$day';
  }
}
