import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

class EncryptionInfoBlock extends StatelessWidget {
  final bool withContainer;

  const EncryptionInfoBlock({
    super.key,
    this.withContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).chatsCallsConfidential, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          S.of(context).endToEndEncryptionMessagesCalls,
          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          SvgPicture.asset(ChatifyVectors.text, width: 16, height: 16, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          S.of(context).textVoiceMessages,
          width: 13,
        ),
        _buildInfoRow(
          SvgPicture.asset(ChatifyVectors.calls, width: 20, height: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          S.of(context).audioVideoCalls,
          width: 10,
        ),
        _buildInfoRow(
          const Icon(FluentIcons.attach_20_regular, size: 19),
          S.of(context).photosVideosDocuments,
          width: 12,
        ),
        _buildInfoRow(
          SvgPicture.asset(ChatifyVectors.locationPin, width: 19, height: 19, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          S.of(context).yourLocation,
          width: 12,
        ),
        _buildInfoRow(
          SvgPicture.asset(ChatifyVectors.status, width: 19, height: 19, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          S.of(context).statusUpdates,
          width: 12,
        ),
      ],
    );

    return withContainer
      ? Container(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 22),
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(15))),
          alignment: Alignment.centerLeft,
          child: content,
        )
      : content;
  }

  static Widget _buildInfoRow(Widget icon, String text, {double width = 8}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: width),
          Flexible(child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300))),
        ],
      ),
    );
  }
}

