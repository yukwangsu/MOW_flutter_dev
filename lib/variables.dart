import 'package:flutter/material.dart';

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

List<String> day = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

Map<String, String> dayMap = {
  'Sunday': '일',
  'Monday': '월',
  'Tuesday': '화',
  'Wednesday': '수',
  'Thursday': '목',
  'Friday': '금',
  'Saturday': '토',
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
