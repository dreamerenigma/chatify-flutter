import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class ChangeGroupAdminsScreen extends StatelessWidget {
  const ChangeGroupAdminsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.isDarkMode ? ChatifyColors.white.withAlpha((0.1 * 255).toInt()) : ChatifyColors.black.withAlpha((0.1* 255).toInt());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(color: ChatifyColors.white, boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 0, blurRadius: 0.5, offset: const Offset(0, 0.5))]),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Изменить админов группы', style: TextStyle(color: ChatifyColors.borderSecondary, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                Text('Выбрано: 0 из 3', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
              ],
            ),
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
