import 'package:flutter/material.dart';

class AppbarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppbarBack({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  //PreferredSizeWidget으로 수정
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      //elevation - 음영
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF6B4D38),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
