import 'package:flutter/material.dart';

const Map<String, int> tagMap = {
  // 작업 편의 태그 (1~10)
  "# 한산해요": 1, "# 공간이 복잡해요": 2, "# 의자가 불편해요": 3, "# 책상이 좁아요": 4, "# 책상이 넓어요": 5,
  "# 의자가 편해요": 6,
  // 분위기 태그 (11~20)
  "# 조용해요": 11,
  "# 시끄러워요": 12,
  "# 어두워요": 13,
  "# 밝아요": 14,
  "# 아늑해요": 15,
  "# 인테리어가 깔끔해요": 16,
  "# 혼자 작업하기 좋아요": 17,
  "# 대화하기 좋아요": 18,
  "# 뷰가 좋아요": 19,
  "# 감각적이에요": 20,
  // 분위기 추가 태그 (21~30)
  "# 다시 오고 싶어요": 21, "# 음악이 좋아요": 22, "# 회의하기에 좋아요": 23,
  // 메뉴 태그 (31~40)
  "# 비싸요": 31, "# 메뉴가 다양해요": 32, "# 메뉴가 적어요": 33, "# 커피가 맛있어요": 34,
  "# 디저트가 맛있어요": 35, "# 저렴해요": 36,
  // 서비스 태그 (41~50)
  "# 친절해요": 41, "# 오래 작업하기 좋아요": 42, "# 오랜 시간 작업하기 어려워요": 43,
  "# 와이파이가 잘 터져요": 44, "# 에어컨이 잘 나와요": 45,
  // 기타 태그 (51~60)
  "# 찾아가기 편해요": 51, "# 무료로 이용이 가능해요": 52, "# 주차가 가능해요": 53, "# 주차할 공간이 없어요": 54,
  "# 24시간 운영이에요": 55, "# 화장실이 깨끗해요": 56, "# 화장실이 불편해요": 57,
};

const Map<int, String> reversedTagMap = {
  // 작업 편의 태그 (1~10)
  1: "# 한산해요",
  2: "# 공간이 복잡해요",
  3: "# 의자가 불편해요",
  4: "# 책상이 좁아요",
  5: "# 책상이 넓어요",
  6: "# 의자가 편해요",
  // 분위기 태그 (11~20)
  11: "# 조용해요",
  12: "# 시끄러워요",
  13: "# 어두워요",
  14: "# 밝아요",
  15: "# 아늑해요",
  16: "# 인테리어가 깔끔해요",
  17: "# 혼자 작업하기 좋아요",
  18: "# 대화하기 좋아요",
  19: "# 뷰가 좋아요",
  20: "# 감각적이에요",
  // 분위기 추가 태그 (21~30)
  21: "# 다시 오고 싶어요",
  22: "# 음악이 좋아요",
  23: "# 회의하기에 좋아요",
  // 메뉴 태그 (31~40)
  31: "# 비싸요",
  32: "# 메뉴가 다양해요",
  33: "# 메뉴가 적어요",
  34: "# 커피가 맛있어요",
  35: "# 디저트가 맛있어요",
  36: "# 저렴해요",
  // 서비스 태그 (41~50)
  41: "# 친절해요",
  42: "# 오래 작업하기 좋아요",
  43: "# 오랜 시간 작업하기 어려워요",
  44: "# 와이파이가 잘 터져요",
  45: "# 에어컨이 잘 나와요",
  // 기타 태그 (51~60)
  51: "# 찾아가기 편해요",
  52: "# 무료로 이용이 가능해요",
  53: "# 주차가 가능해요",
  54: "# 주차할 공간이 없어요",
  55: "# 24시간 운영이에요",
  56: "# 화장실이 깨끗해요",
  57: "# 화장실이 불편해요",
};

//  "# " 제거
Map<int, String> reversedTagMapString = reversedTagMap.map(
  (key, value) => MapEntry(key, value.replaceFirst('# ', '')),
);

// 작업 편의 태그 (1~10)
const List<String> workConvenienceTags = [
  "# 한산해요",
  "# 공간이 복잡해요",
  "# 의자가 불편해요",
  "# 책상이 좁아요",
  "# 책상이 넓어요",
  "# 의자가 편해요",
];

// 분위기 태그 (11~20)
const List<String> atmosphereTags = [
  "# 조용해요",
  "# 시끄러워요",
  "# 어두워요",
  "# 밝아요",
  "# 아늑해요",
  "# 인테리어가 깔끔해요",
  "# 혼자 작업하기 좋아요",
  "# 대화하기 좋아요",
  "# 뷰가 좋아요",
  "# 감각적이에요",
];

// 분위기 추가 태그 (21~30)
const List<String> additionalAtmosphereTags = [
  "# 다시 오고 싶어요",
  "# 음악이 좋아요",
  "# 회의하기에 좋아요",
];

// 메뉴 태그 (31~40)
const List<String> menuTags = [
  "# 비싸요",
  "# 메뉴가 다양해요",
  "# 메뉴가 적어요",
  "# 커피가 맛있어요",
  "# 디저트가 맛있어요",
  "# 저렴해요",
];

// 서비스 태그 (41~50)
const List<String> serviceTags = [
  "# 친절해요",
  "# 오래 작업하기 좋아요",
  "# 오랜 시간 작업하기 어려워요",
  "# 와이파이가 잘 터져요",
  "# 에어컨이 잘 나와요",
];

// 기타 태그 (51~60)
const List<String> otherTags = [
  "# 찾아가기 편해요",
  "# 무료로 이용이 가능해요",
  "# 주차가 가능해요",
  "# 주차할 공간이 없어요",
  "# 24시간 운영이에요",
  "# 화장실이 깨끗해요",
  "# 화장실이 불편해요",
];

const List<Color> colorList = [
  Color(0xFF6B4D38), // color=1
  Color(0xFF8A5E34), // color=2
  Color(0xFFDB7A23), // color=3
  Color(0xFFF46141), // color=4
  Color(0xFFF5EF5E), // color=5
  Color(0xFF95ED7F), // color=6
  Color(0xFF77CAF9), // color=7
  Color(0xFFAF93EB), // color=8
];

// List<String> day = [
//   'Sunday',
//   'Monday',
//   'Tuesday',
//   'Wednesday',
//   'Thursday',
//   'Friday',
//   'Saturday',
// ];

List<String> day = [
  '일요일',
  '월요일',
  '화요일',
  '수요일',
  '목요일',
  '금요일',
  '토요일',
];

// Map<String, String> dayMap = {
//   'Sunday': '일',
//   'Monday': '월',
//   'Tuesday': '화',
//   'Wednesday': '수',
//   'Thursday': '목',
//   'Friday': '금',
//   'Saturday': '토',
// };

Map<String, String> dayMap = {
  '일요일': '일',
  '월요일': '월',
  '화요일': '화',
  '수요일': '수',
  '목요일': '목',
  '금요일': '금',
  '토요일': '토',
};

Map<String, List<Map<String, dynamic>>> characterItems = {
  '상의': [
    {
      'itemCode': 1000,
      'image': 'assets/images/character_items/top_1.png',
      'price': 12,
      'name': '후드티',
      'isSale': true,
    },
    {
      'itemCode': 2000,
      'image': 'assets/images/character_items/top_2.png',
      'price': 12,
      'name': '셔츠',
      'isSale': true,
    },
    {
      'itemCode': 3000,
      'image': 'assets/images/character_items/top_3.png',
      'price': 12,
      'name': '티셔츠',
      'isSale': false,
    },
  ],
  '하의': [
    {
      'itemCode': 100,
      'image': 'assets/images/character_items/bottom_1.png',
      'price': 12,
      'name': '초록 바지',
      'isSale': true,
    },
    {
      'itemCode': 200,
      'image': 'assets/images/character_items/bottom_2.png',
      'price': 12,
      'name': '빨간 바지',
      'isSale': true,
    },
    {
      'itemCode': 300,
      'image': 'assets/images/character_items/bottom_3.png',
      'price': 12,
      'name': '청바지',
      'isSale': false,
    },
  ],
  '소품': [
    {
      'itemCode': 10,
      'image': 'assets/images/character_items/accessory_1.png',
      'price': 12,
      'name': '안경',
      'isSale': true,
    },
    {
      'itemCode': 20,
      'image': 'assets/images/character_items/accessory_2.png',
      'price': 12,
      'name': '노트북',
      'isSale': true,
    },
    {
      'itemCode': 30,
      'image': 'assets/images/character_items/accessory_3.png',
      'price': 12,
      'name': '커피',
      'isSale': false,
    },
  ],
  '시즌': [
    {
      'itemCode': 1,
      'image': 'assets/images/character_items/season_1.png',
      'price': 12,
      'name': '선글라스',
      'isSale': false,
    },
    {
      'itemCode': 2,
      'image': 'assets/images/character_items/season_2.png',
      'price': 12,
      'name': '우산',
      'isSale': false,
    },
    {
      'itemCode': 3,
      'image': 'assets/images/character_items/season_3.png',
      'price': 12,
      'name': '수박',
      'isSale': false,
    },
  ],
};
