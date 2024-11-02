import 'package:flutter/material.dart';
import 'package:flutter_mow/services/curation_service.dart';
import 'package:flutter_mow/widgets/curation_ask_delete.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppbarBackEdit extends StatelessWidget implements PreferredSizeWidget {
  final int workspaceId;

  const AppbarBackEdit({
    super.key,
    required this.workspaceId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 26.0),
          child: GestureDetector(
            child: SvgPicture.asset(
              'assets/icons/edit_icon.svg',
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: GestureDetector(
            child: SvgPicture.asset(
              'assets/icons/delete_icon.svg',
            ),
            onTap: () async {
              var result = await showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                backgroundColor: Colors.white,
                builder: (BuildContext context) {
                  return const CurationAskDelete();
                },
              );
              if (result != null && result) {
                //삭제 버튼을 눌러서 result가 true일 때
                print('큐레이션이 삭제되었습니다');
                CurationService.deleteCurationById(workspaceId);
                Navigator.pop(context);
              }
            },
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
