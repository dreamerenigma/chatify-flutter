import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/chat_api.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../chat/models/user_model.dart';
import '../../screens/archive/archive_screen.dart';

class ArchivePrivacySection extends StatelessWidget {
  final UserModel user;

  const ArchivePrivacySection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: () {
            Navigator.push(context, createPageRoute(ArchiveScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 36, right: 22, top: 14, bottom: 14),
            child: Row(
              children: [
                Icon(Icons.archive_outlined, size: 24, color: color),
                const SizedBox(width: 22),
                Text(S.of(context).inArchive, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: color)),
                const Spacer(),
                StreamBuilder<int>(
                  stream: ChatApi.getArchivedUsersCount(user.id),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;

                    if (count == 0) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(count.toString(), style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: color)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
