import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/enums/global_search_tab_type.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/helper/global_search_tab_helper.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

class GlobalSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBack;
  final GlobalSearchTabType? selectedTab;
  final VoidCallback? onClearSelection;

  const GlobalSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBack,
    this.selectedTab,
    this.onClearSelection,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    Widget? getSuffixActionIcon(GlobalSearchTabType? tab, BuildContext context) {
      final color = context.isDarkMode ? ChatifyColors.white : ChatifyColors.black;

      switch (tab) {
        case GlobalSearchTabType.photo:
          return Icon(Icons.list, color: color, size: 23);
        case GlobalSearchTabType.video:
          return Icon(Icons.list, color: color, size: 23);
        case GlobalSearchTabType.gif:
          return Icon(Icons.list, color: color, size: 23);
        case GlobalSearchTabType.stickers:
          return SvgPicture.asset(ChatifyVectors.apps, width: 23, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
        default:
          return null;
      }
    }

    return SafeArea(
      child: SizedBox(
        height: 62,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Container(
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white, borderRadius: BorderRadius.circular(35)),
            child: TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Поиск по Chatify',
                  hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      IconButton(tooltip: 'Назад', onPressed: onBack, icon: Icon(Icons.arrow_back_rounded, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                      if (selectedTab != null) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GlobalSearchTabHelper.getTabIcon(selectedTab!, context.isDarkMode ? ChatifyColors.black : ChatifyColors.white),
                              const SizedBox(width: 6),
                              Text(
                                GlobalSearchTabHelper.getTabTitle(selectedTab!),
                                style: TextStyle(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                    ],
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedTab != null) ...[
                        Builder(
                          builder: (context) {
                            final actionIcon = getSuffixActionIcon(selectedTab, context);

                            if (actionIcon == null) {
                              return const SizedBox.shrink();
                            }

                            return IconButton(tooltip: 'Действие категории', onPressed: () {}, icon: actionIcon);
                          },
                        ),
                      ],

                      if (controller.text.isNotEmpty || selectedTab != null)
                        IconButton(
                          tooltip: 'Очистить',
                          onPressed: () {
                            controller.clear();
                            onChanged('');
                            onClearSelection?.call();
                            focusNode.requestFocus();
                          },
                          icon: Icon(Icons.close_rounded, size: 25, color: context.isDarkMode? ChatifyColors.white : ChatifyColors.black),
                        ),
                    ],
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

