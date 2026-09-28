import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/date_util.dart';

class ChatDateBadgeWidget extends StatelessWidget {
  final DateTime date;

  const ChatDateBadgeWidget({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateUtil.getChatMessageDateLabel(context: context, timestamp: Timestamp.fromDate(date));

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.08 * 255).toInt()), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Text(
          dateLabel,
          style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}