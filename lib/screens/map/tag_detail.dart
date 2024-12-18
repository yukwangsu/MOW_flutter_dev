import 'package:flutter/material.dart';
import 'package:flutter_mow/models/place_list_model.dart';
import 'package:flutter_mow/models/word_cloud_model.dart';
import 'package:flutter_mow/screens/map/add_review.dart';
import 'package:flutter_mow/screens/map/write_curation.dart';
import 'package:flutter_mow/services/review_service.dart';
import 'package:flutter_mow/services/search_service.dart';
import 'package:flutter_mow/variables.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_main.dart';
import 'package:flutter_svg/svg.dart';

class TagDetail extends StatefulWidget {
  final int workspaceId;

  const TagDetail({
    super.key,
    required this.workspaceId,
  });

  @override
  State<TagDetail> createState() => _TagDetailState();
}

class _TagDetailState extends State<TagDetail> {
  late Future<WordCloudModel> wordCloudTags;

  @override
  void initState() {
    super.initState();
    wordCloudTags = ReviewService.getTags(widget.workspaceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //스크롤 X
            Padding(
              padding: const EdgeInsets.only(top: 28, left: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '태그 상세보기',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    '화면에 보이지 못한 모든 태그들을 모았어요!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 28.0,
            ),

            //스크롤 O
            const SizedBox(
              height: 20.0,
            ),
            FutureBuilder(
              future: wordCloudTags,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터가 로드 중일 때 로딩 표시
                  return const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFFAD7541),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 200.0,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  // 오류가 발생했을 때
                  return Expanded(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // // 성공적으로 불러왔을 때
                  Map<String, dynamic> tagCountMap = snapshot.data!.tagCount;
                  int tagCountLength = tagCountMap.length;
                  print(tagCountLength);
                  // Step 1: Map을 List로 변환
                  List<MapEntry<String, dynamic>> mapEntries =
                      tagCountMap.entries.toList();
                  // Step 2: List를 value 기준으로 내림차순 정렬
                  mapEntries.sort((a, b) => b.value.compareTo(a.value));
                  // Step 3: 정렬된 List를 Map으로 변환
                  Map<String, dynamic> sortedMap = Map.fromEntries(mapEntries);
                  print(sortedMap);
                  List<String> tagCountMapKeyList = sortedMap.keys.toList();
                  print(tagCountMapKeyList);
                  if (tagCountMapKeyList.isEmpty) {
                    return const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '태그가 존재하지 않아요',
                                style: TextStyle(color: Color(0xffc3c3c3)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 200.0,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(top: 0.0),
                        itemCount: tagCountMapKeyList.length,
                        itemBuilder: (context, index) {
                          return tagElement(tagCountMapKeyList[index],
                              sortedMap[tagCountMapKeyList[index]]);
                        },
                        //separatorBuilder는 사이에 공간을 만드는 역할.
                        separatorBuilder: (context, index) => const Column(
                          children: [
                            SizedBox(
                              height: 4.0,
                            ),
                            ListBorderLine(),
                            SizedBox(
                              height: 4.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: ButtonMain(
                  text: "나도 추가하기",
                  bgcolor: const Color(0xFF6B4D38),
                  textColor: Colors.white,
                  borderColor: const Color(0xFF6B4D38),
                  opacity: 1.0,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddReview(workspaceId: widget.workspaceId),
                      ),
                    ).then((_) {
                      // *** 이 화면으로 돌아왔을 때 디테일 화면을 다시 로딩 => 리뷰 업데이트***
                      setState(() {
                        wordCloudTags =
                            ReviewService.getTags(widget.workspaceId);
                      });
                    });
                  }),
            ),
            const SizedBox(
              height: 26.0,
            ),
          ],
        ),
      ),
    );
  }

// 태그 리스트
  Widget tagElement(
    String tagName,
    int tagCount,
  ) {
    return SizedBox(
      height: 37.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              reversedTagMap[int.parse(tagName)]!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$tagCount 회',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: const Color(0xFF828282)),
            ),
          ],
        ),
      ),
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
