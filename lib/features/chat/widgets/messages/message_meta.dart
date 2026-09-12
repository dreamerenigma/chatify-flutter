import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../personalization/controllers/colors_controller.dart';
import '../../models/message_model.dart';

class MessageMeta extends StatelessWidget {
  final MessageModel message;
  final bool isWebOrWindows;
  final bool showCheck;
  final bool isSender;

  const MessageMeta({
    super.key,
    required this.message,
    required this.isWebOrWindows,
    this.showCheck = true,
    this.isSender = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorsController = Get.find<ColorsController>();
    final bool isRead = message.read.isNotEmpty;
    final Color checkColor = isRead ? colorsController.getColor(colorsController.selectedColorScheme.value) : context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey;

    return Align(
      alignment: Alignment.centerRight,
      child: Tooltip(
        verticalOffset: -50,
        waitDuration: const Duration(milliseconds: 800),
        exitDuration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        message: '${DateUtil.getFormattedDateLabel(context: context, timestamp: message.sent)}, ' '${DateUtil.getFormattedTime(context: context, time: message.sent)}',
        textStyle: isSender
          ? TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300,)
          : null,
            decoration: isSender
            ? BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()): ChatifyColors.buttonGrey),
                boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.2 * 255).toInt(),), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 4))],
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateUtil.getFormattedTime(context: context, time: message.sent),
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, fontSize: isWebOrWindows ? 10 : ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
            ),
            if (showCheck) ...[
              const SizedBox(width: 4),
              SvgPicture.asset(ChatifyVectors.doubleCheck, width: isWebOrWindows ? 13 : 19, height: isWebOrWindows ? 13 : 19, colorFilter: ColorFilter.mode(checkColor, BlendMode.srcIn)),
            ],
          ],
        ),
      ),
    );
  }
}
