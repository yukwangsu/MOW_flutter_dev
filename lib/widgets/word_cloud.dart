import 'package:flutter/material.dart';
import 'package:flutter_mow/main.dart';
import 'package:flutter_mow/models/word_cloud_model.dart';
import 'package:flutter_mow/screens/map/tag_detail.dart';
import 'package:flutter_mow/services/review_service.dart';
import 'package:flutter_mow/variables.dart';
import 'package:flutter_svg/svg.dart';

class WordCloud extends StatefulWidget {
  final int workspaceId;

  const WordCloud({
    super.key,
    required this.workspaceId,
  });

  @override
  State<WordCloud> createState() => _WordCloudState();
}

class _WordCloudState extends State<WordCloud> {
  late Future<WordCloudModel> wordCloud;

  @override
  void initState() {
    super.initState();
    wordCloud = ReviewService.getTags(widget.workspaceId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFFFFCF8),
          height: 170.0,
          child: Column(
            children: [
              const Row(
                children: [],
              ),
              Expanded(
                child: FutureBuilder(
                  future: wordCloud,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 데이터가 로드 중일 때 로딩 표시
                      return const Text('');
                    } else if (snapshot.hasError) {
                      // 오류가 발생했을 때
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // // 성공적으로 불러왔을 때
                      Map<String, dynamic> tagCountMap =
                          snapshot.data!.tagCount;
                      int tagCountLength = tagCountMap.length;
                      print(tagCountLength);
                      // Step 1: Map을 List로 변환
                      List<MapEntry<String, dynamic>> mapEntries =
                          tagCountMap.entries.toList();
                      // Step 2: List를 value 기준으로 내림차순 정렬
                      mapEntries.sort((a, b) => b.value.compareTo(a.value));
                      // Step 3: 정렬된 List를 Map으로 변환
                      Map<String, dynamic> sortedMap =
                          Map.fromEntries(mapEntries);
                      print(sortedMap);
                      List<String> tagCountMapKeyList = sortedMap.keys.toList();
                      print(tagCountMapKeyList);
                      if (tagCountMapKeyList.isEmpty) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '태그가 존재하지 않아요',
                              style: TextStyle(color: Color(0xffc3c3c3)),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 1-1
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // if (tagCountLength >= 7)
                                  //   // 7 순위
                                  //   Text(
                                  //     reversedTagMapString[
                                  //         int.parse(tagCountMapKeyList[6])]!,
                                  //     style:
                                  //         Theme.of(context).textTheme.bodySmall,
                                  //   ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  if (tagCountLength >= 5)
                                    // 5 순위
                                    Text(
                                      reversedTagMapString[
                                          int.parse(tagCountMapKeyList[4])]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                ],
                              ),
                            ),
                            // 1-2
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (tagCountLength >= 1)
                                    // 1 순위
                                    Text(
                                      reversedTagMapString[
                                          int.parse(tagCountMapKeyList[0])]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  if (tagCountLength >= 3)
                                    // 3 순위
                                    Text(
                                      reversedTagMapString[
                                          int.parse(tagCountMapKeyList[2])]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    )
                                ],
                              ),
                            ),
                            // 1-3
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tagCountLength >= 4)
                                    // 4 순위
                                    Text(
                                      reversedTagMapString[
                                          int.parse(tagCountMapKeyList[3])]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  if (tagCountLength >= 2)
                                    // 2 순위
                                    Text(
                                      reversedTagMapString[
                                          int.parse(tagCountMapKeyList[1])]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    )
                                ],
                              ),
                            ),
                            // 1-4
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tagCountLength >= 6)
                                    // 6 순위
                                    Text(
                                      reversedTagMapString[
                                          int.parse(tagCountMapKeyList[5])]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  // if (tagCountLength >= 8)
                                  //   // 8 순위
                                  //   Text(
                                  //     reversedTagMapString[
                                  //         int.parse(tagCountMapKeyList[7])]!,
                                  //     style:
                                  //         Theme.of(context).textTheme.bodySmall,
                                  //   ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 12.0,
          right: 12.0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TagDetail(workspaceId: widget.workspaceId),
                ),
              ).then((_) {
                // *** 이 화면으로 돌아왔을 때 디테일 화면을 다시 로딩 => 리뷰 업데이트***
                setState(() {
                  wordCloud = ReviewService.getTags(widget.workspaceId);
                });
              });
            },
            child: SvgPicture.asset('assets/icons/arrow_right_show_tags.svg'),
          ),
        )
      ],
    );
  }
}
