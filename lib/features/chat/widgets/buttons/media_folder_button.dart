import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

class MediaFolderButton extends StatelessWidget {
  final VoidCallback? onTap;

  const MediaFolderButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.lightGrey,
            borderRadius: BorderRadius.circular(16), border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.grey, width: 1),
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.4 * 255).toInt()), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: SvgPicture.asset(ChatifyVectors.folder, width: 18, height: 18, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
            ),
          ),
        ),
      ),
    );
  }
}
