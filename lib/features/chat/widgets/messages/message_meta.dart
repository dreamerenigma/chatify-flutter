import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/date_util.dart';
import '../../models/message_model.dart';

class MessageMeta extends StatelessWidget {
  final MessageModel message;
  final bool isWebOrWindows;

  const MessageMeta({
    super.key,
    required this.message,
    required this.isWebOrWindows,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Tooltip(
        verticalOffset: -50,
        waitDuration: const Duration(milliseconds: 800),
        exitDuration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        message: '${DateUtil.getFormattedDateLabel(context: context, timestamp: message.sent)}, ' '${DateUtil.getFormattedTime(context: context, time: message.sent)}',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateUtil.getFormattedTime(context: context, time: message.sent),
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, fontSize: isWebOrWindows ? 10 : ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              ChatifyVectors.doubleCheck,
              width: isWebOrWindows ? 13 : 19,
              height: isWebOrWindows ? 13 : 19,
              colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.darkGrey, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
