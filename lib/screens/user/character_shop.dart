import 'package:flutter/material.dart';
import 'package:flutter_mow/models/character_model.dart';
import 'package:flutter_mow/services/character_service.dart';
import 'package:flutter_mow/widgets/appbar_back.dart';
import 'package:flutter_mow/widgets/button_free_width.dart';

class CharacterShop extends StatefulWidget {
  const CharacterShop({
    super.key,
  });

  @override
  State<CharacterShop> createState() => _CharacterShopState();
}

class _CharacterShopState extends State<CharacterShop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarBack(),
      body: Column(children: []),
    );
  }
}
