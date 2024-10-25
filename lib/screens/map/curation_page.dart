import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mow/models/curation_page_model.dart';
import 'package:flutter_mow/services/curation_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';

class CurationPage extends StatefulWidget {
  final int curationId;

  const CurationPage({
    super.key,
    required this.curationId,
  });

  @override
  State<CurationPage> createState() => _CurationPageState();
}

class _CurationPageState extends State<CurationPage> {
  late Future<CurationPageModel> curation;

  @override
  void initState() {
    super.initState();
    //api 호출
    curation = CurationService.getCurationById(widget.curationId, 0, 0, 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarBack(),
      body: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          Container(
            decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
            width: double.infinity,
            height: 368,
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
                    return Text(snapshot.data!.curationTitle);
                  }
                }),
          )
        ],
      ),
    );
  }
}
