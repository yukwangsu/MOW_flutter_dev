import 'package:flutter/material.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';

class CurationDetail extends StatelessWidget {
  final int curationId;
  final String thumb;

  const CurationDetail({
    super.key,
    required this.curationId,
    required this.thumb,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: Column(
        children: [
          Hero(
            tag: curationId,
            child: Container(
              width: 250,
              clipBehavior: Clip.hardEdge,
              //container 장식
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    //blurRadius: shadow 크기
                    blurRadius: 15,
                    offset: const Offset(10, 10),
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
              //container 내용
              child: Image.network(
                thumb,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
