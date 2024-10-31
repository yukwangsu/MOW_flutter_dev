import 'package:flutter/material.dart';
import 'package:flutter_mow/models/bookmark.dart';
import 'package:flutter_mow/services/bookmark_service.dart';
import 'package:flutter_mow/widgets/add_bookmark_list.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_svg/svg.dart';

class BookmarkList extends StatefulWidget {
  final int workspaceId;

  const BookmarkList({
    super.key,
    required this.workspaceId,
  });

  @override
  State<BookmarkList> createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  bool selectList = false; // 리스트를 선택했는지 저장
  int selectedListId = -1; // 선택된 리스트의 아이디 저장
  Future<BookmarkListModel> bookmarkList =
      BookmarkService.getBookmarkList(); // 리스트 데이터 저장
  Map<int, Color> colorMap = {
    1: const Color(0xFF6B4D38), //color=1
    2: const Color(0xFF8A5E34), //color=2
    3: const Color(0xFFDB7A23), //color=3
    4: const Color(0xFFF46141), //color=4
    5: const Color(0xFFF5EF5E), //color=5
    6: const Color(0xFF95ED7F), //color=6
    7: const Color(0xFF77CAF9), //color=7
    8: const Color(0xFFAF93EB), //color=8
  };

  @override
  void initState() {
    super.initState();
  }

  //확인 버튼 클릭(리스트 선택)
  void onClickButtonHandler() async {
    //리스트를 선택해야만 넘어감
    if (selectList) {
      bool addSuccess = await BookmarkService.addPlaceToBookmark(
          selectedListId, widget.workspaceId);
      if (addSuccess) {
        print('리스트에 추가 성공');
      } else {
        // print('리스트에 추가 실패');
      }
      setState(() {
        selectList = false;
        selectedListId = -1;
        Navigator.of(context).pop();
      });
    }
  }

  //리스트 클릭
  void onClickListHandler(int id) {
    // 이미 선택된 리스트 클릭
    if (selectedListId == id) {
      setState(() {
        selectList = false;
        selectedListId = -1;
      });
      // 정상적으로 리스트 클릭
    } else {
      setState(() {
        selectList = true;
        selectedListId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 544.0,
      padding: const EdgeInsets.only(
          left: 31.0, right: 31.0, top: 40.0, bottom: 56.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 34.0),
            child: Text(
              '어디에 저장할까요?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // 북마크 리스트 불러오기
          FutureBuilder<BookmarkListModel>(
            future: bookmarkList,
            builder: (BuildContext context,
                AsyncSnapshot<BookmarkListModel> snapshot) {
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
                //데이터 로딩 완료
              } else {
                //북마크 리스트가 없을 때
                if (snapshot.data!.bookmarkList.isEmpty) {
                  return Expanded(
                    child: Column(
                      children: [
                        bookmarkListAddWidget(
                          context,
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                  //북마크 리스트가 있을 때
                } else {
                  return Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 0.0),
                      itemCount: snapshot.data!.bookmarkList.length,
                      itemBuilder: (context, index) {
                        //북마크 리스트 새로 만들기
                        if (index == 0) {
                          return Column(
                            children: [
                              bookmarkListAddWidget(
                                context,
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              bookmarkListWidget(
                                  context, snapshot.data!.bookmarkList[index]),
                            ],
                          );
                        } else {
                          return bookmarkListWidget(
                              context, snapshot.data!.bookmarkList[index]);
                        }
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12.0),
                    ),
                  );
                }
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 46.0),
            child: ButtonMain(
                text: '확인',
                bgcolor: Colors.white,
                textColor: const Color(0xFF6B4D38),
                borderColor: const Color(0xFF6B4D38),
                opacity: selectList ? 1.0 : 0.5,
                onPress: () {
                  onClickButtonHandler();
                }),
          )
        ],
      ),
    );
  }

//북마크 리스트 새로 만들기 칸
  Widget bookmarkListAddWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //새로운 showModalBottomSheet
        showModalBottomSheet(
          context: context,
          //showModalBottomSheet의 높이가 화면의 절반으로 제한
          //그러나 isScrollControlled를 사용하면 높이 제한이 풀리고 스크롤이 가능해짐
          //여기서 listview를 사용하기 때문에 스크롤은 사용하지 않음.
          isScrollControlled: true,
          // shape를 사용해서 BorderRadius 설정.
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            // add_bookmark_list.dart로 이동
            return const AddBookmarkList();
          },
        ).then((_) {
          setState(() {
            //리스트를 추가한 뒤 돌아오면 리스트를 다시 로드함.
            bookmarkList = BookmarkService.getBookmarkList();
          });
        });
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color(0xFFF3F3F3),
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.only(
            top: 12.0, right: 14.0, bottom: 12.0, left: 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //아이콘
            SvgPicture.asset('assets/icons/bookmark_list_add_icon.svg'),
            const SizedBox(
              width: 14.0,
            ),
            Text(
              '새로 만들기',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }

  //기존에 있는 북마크 리스트 칸
  Widget bookmarkListWidget(BuildContext context, BookmarkModel bookmark) {
    return GestureDetector(
      onTap: () {
        onClickListHandler(bookmark.bookmarkListId);
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: bookmark.bookmarkListId == selectedListId
                ? const Color(0xFF6B4D38)
                : const Color(0xFFF3F3F3),
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.only(
            top: 12.0, right: 14.0, bottom: 12.0, left: 14.0),
        child: Row(
          children: [
            //아이콘(색이 각각 다름)
            SvgPicture.asset(
              'assets/icons/bookmark_list_icon.svg',
              colorFilter:
                  ColorFilter.mode(colorMap[bookmark.color]!, BlendMode.srcIn),
            ),
            const SizedBox(
              width: 14.0,
            ),
            //제목, 장소 개수
            SizedBox(
              height: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //제목
                  Text(
                    bookmark.bookmarkListTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  //장소
                  Text(
                    '공간 ${bookmark.bookmarkCnt}곳',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: const Color(0xFFB9B9B9)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
