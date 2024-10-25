import 'package:flutter/material.dart';
import 'package:flutter_mow/screens/map/curation_page.dart';

class CurationList extends StatelessWidget {
  final String title;
  final String placeName;
  final String thumb;
  final int curationId;

  const CurationList({
    super.key,
    required this.title,
    required this.placeName,
    required this.thumb,
    required this.curationId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('curationId: $curationId');

        //MaterialPageRoute: statelessWidget을 route로 감싸서 다른 스크린처럼 보이게한다.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurationPage(
              curationId: curationId,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        width: 228,
        height: 390,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: const Color(0XFFE4E3E2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //widget의 ID를 태그로 가진 Hero를 만든다 (삭제..).
            //CurationDetail으로 이동할 때 동일한 태그를 가진다면 화면이 자연스럽게 전환된다.
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              width: 228,
              height: 317,
              //자르기 -> BorderRadius 반영
              clipBehavior: Clip.hardEdge,

              //container 내용
              child: Image.network(
                thumb,
                fit: BoxFit.cover, // 이미지를 Container에 가득 채우기
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            // 큐레이션 제목과 상호명
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    placeName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0XFFC3C3C3),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
