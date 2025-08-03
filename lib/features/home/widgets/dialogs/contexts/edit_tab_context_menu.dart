import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

void showEditTabContextMenu(BuildContext context) async {
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(80, 155, 100, 0),
    items: [
      PopupMenuItem(
        enabled: false,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _buildPopupMenuItem(context, FluentIcons.delete_16_regular, S.of(context).delete, () {
              
            }, isDestructive: true),
            Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
            _buildPopupMenuItem(context, AkarIcons.two_line_horizontal, S.of(context).organizeLists, () {

            }),
          ],
        ),
      ),
    ],
    color: context.isDarkMode ? ChatifyColors.darkSlate : Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

Widget _buildPopupMenuItem(BuildContext context, IconData icon, String text, VoidCallback onTap, {bool isDestructive = false}) {
  final color = isDestructive ? ChatifyColors.red : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black;

  return InkWell(
    onTap: onTap,
    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 23, color: color),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: color, fontSize: ChatifySizes.fontSizeSm)),
        ],
      ),
    ),
  );
}
