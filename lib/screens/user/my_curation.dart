import 'package:flutter/material.dart';
import 'package:flutter_mow/models/simple_curation_model.dart';
import 'package:flutter_mow/screens/map/add_review.dart';
import 'package:flutter_mow/screens/map/curation_page.dart';
import 'package:flutter_mow/screens/signin/login_screen.dart';
import 'package:flutter_mow/services/curation_service.dart';
import 'package:flutter_mow/services/delete_account.dart';
import 'package:flutter_mow/services/signout_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_free_width.dart';
import 'package:flutter_svg/svg.dart';

class MyCuration extends StatefulWidget {
  const MyCuration({
    super.key,
  });

  @override
  State<MyCuration> createState() => _MyCurationState();
}

class _MyCurationState extends State<MyCuration> {
  late Future<MyCurationListModel> myCurationList;

  @override
  void initState() {
    super.initState();
    myCurationList = CurationService.getMyCuration();
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
            height: 28.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              '내가 쓴 큐레이션',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 36.0,
          ),
          // 큐레이션들
          FutureBuilder(
            future: myCurationList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 데이터가 로드 중일 때 로딩 표시
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    CircularProgressIndicator(
                      color: Color(0xFFAD7541),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                // 오류가 발생했을 때
                return const Text('err');
              } else {
                // myCurationList 로딩 완료
                final myCurationListResult = snapshot.data!.myCurationList;
                if (myCurationListResult.isEmpty) {
                  return const Column(
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '내가 쓴 큐레이션이 없습니다!',
                            style: TextStyle(color: Color(0xffc3c3c3)),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 0.0),
                      itemCount: myCurationListResult.length,
                      itemBuilder: (context, index) {
                        return curationList(
                          myCurationListResult[index],
                        );
                      },
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget curationList(
    MyCurationModel curation,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // place list
          GestureDetector(
            behavior: HitTestBehavior.opaque, // *** 빈 공간까지 터치 감지 ***
            onTap: () {
              print('curationId: ${curation.curationId}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurationPage(
                      curationId: curation.curationId,
                      workspaceId: curation.workspaceId),
                ),
              ).then((_) {
                // *** 이 화면으로 돌아왔을 때 화면을 다시 로딩(curation list를 새로 고침)
                setState(() {
                  myCurationList = CurationService.getMyCuration();
                });
              });
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
                        child: Image.network(
                          curation.curationPhoto,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
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
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 큐레이션 제목
                              Text(
                                curation.curationTitle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              // 큐레이션 상호명, 좋아요 개수
                              Text(
                                curation.workSpaceName,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: const Color(0xFFC3C3C3)),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0, // 오른쪽 끝에 배치
                            bottom: 0, // 아래쪽 끝에 배치
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/curation_simple_heart.svg'),
                                const SizedBox(width: 2.5),
                                Text(
                                  '${curation.likes}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //list padding
          const SizedBox(
            height: 24.0,
          ),
        ],
      ),
    );
  }
}
