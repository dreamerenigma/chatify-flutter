import 'dart:io';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class VideoMessageButton extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final Function(File) onVideoRecord;

  const VideoMessageButton({
    super.key,
    required this.onPressed,
    required this.onLongPress,
    required this.onVideoRecord,
  });

  @override
  VideoMessageButtonState createState() => VideoMessageButtonState();
}

class VideoMessageButtonState extends State<VideoMessageButton> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.3* 255).toInt()) : ChatifyColors.steelGrey,
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: SvgPicture.asset(ChatifyVectors.videoMessage, width: 22, height: 22, colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn)),
          ),
        ),
      ),
    );
  }
}
