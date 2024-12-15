import 'package:flutter/material.dart';

class UserMarkerIcon extends StatelessWidget {
  const UserMarkerIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0, // 전체 컨테이너 크기
      height: 35.0,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2), // 반투명한 검정 원
        shape: BoxShape.circle, // 반투명 원의 모양
      ),
      child: Center(
        child: Container(
          width: 17.0, // 흰색 테두리 포함한 내부 원 크기
          height: 17.0,
          decoration: BoxDecoration(
            color: Colors.blue, // 파란 원의 색상
            shape: BoxShape.circle, // 내부 원의 모양
            border: Border.all(
              color: Colors.white, // 테두리 색상
              width: 2.0, // 테두리 두께
            ),
          ),
        ),
      ),
    );
  }
}
