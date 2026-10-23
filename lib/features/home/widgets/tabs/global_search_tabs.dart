import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/global_search_tab_type.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../utils/helper/global_search_tab_helper.dart';

class GlobalSearchTabs extends StatefulWidget {
  final ValueChanged<GlobalSearchTabType>? onTabChanged;

  const GlobalSearchTabs({
    super.key,
    this.onTabChanged,
  });

  @override
  State<GlobalSearchTabs> createState() => _GlobalSearchTabsState();
}

class _GlobalSearchTabsState extends State<GlobalSearchTabs> {
  static const List<GlobalSearchTabType> _tabs = [
    GlobalSearchTabType.unread,
    GlobalSearchTabType.photo,
    GlobalSearchTabType.video,
    GlobalSearchTabType.links,
    GlobalSearchTabType.gif,
    GlobalSearchTabType.audio,
    GlobalSearchTabType.documents,
    GlobalSearchTabType.stickers,
    GlobalSearchTabType.survey,
    GlobalSearchTabType.contacts,
    GlobalSearchTabType.groups,
    GlobalSearchTabType.communities,
    GlobalSearchTabType.channels,
    GlobalSearchTabType.bots,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _tabs.length,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            final tab = _tabs[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
              child: Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  borderRadius: BorderRadius.circular(30),
                  splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                  onTap: () => widget.onTabChanged?.call(tab),
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.08 * 255).toInt()), blurRadius: 4, offset: const Offset(0, 1))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GlobalSearchTabHelper.getTabIcon(tab, context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black),
                        const SizedBox(width: 7),
                        Text(
                          GlobalSearchTabHelper.getTabTitle(tab),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
