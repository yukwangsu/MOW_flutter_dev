import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/curation_page.dart';
import 'package:flutter_mow/screens/map/edit_curation.dart';
import 'package:flutter_mow/services/curation_service.dart';
import 'package:flutter_mow/widgets/curation_ask_delete.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppbarBackEdit extends StatelessWidget implements PreferredSizeWidget {
  final int workspaceId;
  final int curationId;

  const AppbarBackEdit({
    super.key,
    required this.workspaceId,
    required this.curationId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    late Future<List<dynamic>> myCuration;
    //myCuration api 호출
    myCuration = CurationService.getCurationMine();
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF6B4D38),
          ),
          onPressed: () {
            // 본인이 작성한 큐레이션 페이지 방문한 후 뒤로가기를 누르면
            // 사용자가 큐레이션을 삭제하거나 수정했을 가능성이 있기 때문에 reload를 true로 전달한다.
            print('본인이 작성한 큐레이션 페이지에서 뒤로가기 버튼을 누름!!');
            Navigator.pop(context, true);
          },
        ),
      ),
      actions: [
        FutureBuilder(
          future: myCuration,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터가 로드 중일 때 로딩 표시
              return const Text('');
            } else if (snapshot.hasError) {
              // 오류가 발생했을 때
              return const Text('err');
            } else {
              // myCuration 로딩 완료
              if (snapshot.data!.contains(curationId)) {
                // myCuration에 존재하는 curationId인 경우 수정, 삭제 아이콘을 추가함
                return // 수정 아이콘
                    Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          'assets/icons/edit_icon.svg',
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCurationScreen(
                                workspaceId: workspaceId,
                                curationId: curationId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    // 삭제 아이콘
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          'assets/icons/delete_icon.svg',
                        ),
                        onTap: () async {
                          var result = await showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return const CurationAskDelete();
                            },
                          );
                          if (result != null && result) {
                            //삭제 버튼을 눌러서 result가 true일 때
                            print('큐레이션이 삭제되었습니다');
                            final deleteResult =
                                await CurationService.deleteCurationById(
                                    curationId);
                            Navigator.pop(context, deleteResult);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                  ],
                );
              } else {
                // else: myCuration에 존재하지 않을 경우 아무것도 보여주지 않음
                return const Text('');
              }
            }
          },
        ),
      ],
    );
  }
}
