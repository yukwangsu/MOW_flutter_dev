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
  // late Future<String> userNickname; // 닉네임 저장하는 변수

  @override
  void initState() {
    super.initState();
    //큐레이션 api 호출
    curation = CurationService.getCurationById(widget.curationId, 0, 0, 20);
    //장소 api 호출
    workspace = SearchService.getPlaceById(widget.workspaceId);
    // //사용자(큐레이션 작성자) 닉네임 가져오기
    // userNickname = getUserNickname();
  }

  // Future<String> getUserNickname() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? savedNickname = prefs.getString('userNickname');
  //   return savedNickname ?? '{userNickname}';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarBackEdit(
          workspaceId: widget.workspaceId, curationId: widget.curationId),
      body: Column(
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
                          decoration:
                              const BoxDecoration(color: Color(0xFFD9D9D9)),
                          width: double.infinity,
                          height: 368,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //태그 (최대 2개이긴 하지만 좌우로 스크롤 가능하게)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (int n = 0;
                                          n <
                                              snapshot
                                                  .data!.featureTagsList.length;
                                          n++) ...[
                                        curationPageTagWidget(
                                            snapshot.data!.featureTagsList[n]),
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
                                          .headlineLarge,
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
                                      formatDateTime(snapshot.data!.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  children: [
                                    Container(
                                      width: 186,
                                      height: 248,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 6.0,
                                    ),
                                    Container(
                                      width: 186,
                                      height: 248,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 6.0,
                                    ),
                                    Container(
                                      width: 186,
                                      height: 248,
                                      color: Colors.grey,
                                    ),
                                  ],
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
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
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
                                      return Text('Error: ${snapshot.error}');
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '상호명',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                snapshot.data!.workspaceName,
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '주소',
                                                      style: Theme.of(context)
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '영업시간',
                                                      style: Theme.of(context)
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'URL',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                snapshot.data!.spaceUrl,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              ),
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
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
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
                      '  Closed',
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
