import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showEditListsBottomSheet(BuildContext context) {
  List<Map<String, String>> presets = [
    {'title': 'Непрочитанное', 'subtitle': S.of(context).preset},
    {'title': 'Избранное', 'subtitle': ''},
    {'title': 'Группы', 'subtitle': S.of(context).preset},
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.close, size: 26), onPressed: () => Navigator.pop(context)),
                Text(S.of(context).editLists, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.normal)),
                IconButton(
                  icon: const Icon(Icons.check, size: 26),
                  onPressed: () => {
                    Navigator.pop(context),
                  }
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.of(context).editListsFiltersChangeDisplay,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).yourLists, style: TextStyle(color: ChatifyColors.buttonSecondary, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).unread, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                          const SizedBox(height: 8),
                          Text(
                            S.of(context).preset,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(FluentIcons.delete_24_regular, size: 24, color: ChatifyColors.buttonSecondary),
                          SizedBox(width: 16),
                          Icon(AkarIcons.two_line_horizontal, size: 24, color: ChatifyColors.buttonSecondary),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                      const Icon(AkarIcons.two_line_horizontal, size: 24, color: ChatifyColors.buttonSecondary),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${S.of(context).groups[0].toUpperCase()}${S.of(context).groups.substring(1)}', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                          const SizedBox(height: 8),
                          Text(
                            S.of(context).preset,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(FluentIcons.delete_24_regular, size: 24, color: ChatifyColors.buttonSecondary),
                          SizedBox(width: 16),
                          Icon(AkarIcons.two_line_horizontal, size: 24, color: ChatifyColors.buttonSecondary),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).availablePresets,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          S.of(context).deleteOnePresetListsUnreadGroups,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
