import 'dart:io';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../common/widgets/buttons/custom_search_button.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/devices/device_utility.dart';
import '../../../../utils/dialogs/no_internet_connection_dialog.dart';

class AppBarActions extends StatefulWidget {
  final VoidCallback? onVideoCall;
  final VoidCallback? onAudioCall;
  final VoidCallback? onSearch;
  final void Function(int)? onPopupItemSelected;

  const AppBarActions({
    super.key,
    this.onVideoCall,
    this.onAudioCall,
    this.onSearch,
    this.onPopupItemSelected,
  });

  @override
  State<AppBarActions> createState() => _AppBarActionsState();
}

class _AppBarActionsState extends State<AppBarActions> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;
  late Animation<double> _searchScaleAnimation;
  bool get isMobile => Platform.isIOS || Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(parent: _searchController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Platform.isWindows) ...[
          Container(
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey, width: 1),
              color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.transparent,
            ),
            child: Row(
              children: [
                _buildIcon(
                  context,
                  message: S.of(context).videoCall,
                  icon: HeroIcon(HeroIcons.videoCamera, size: 22),
                  onTap: () async {
                    if (await DeviceUtils.hasInternetConnection()) {
                      widget.onVideoCall?.call();
                    } else {
                      showNoInternetConnectionDialog(context);
                    }
                  },
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                ),
                if (!isMobile) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: VerticalDivider(
                      color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                      thickness: 1,
                      width: 1,
                    ),
                  ),
                ],
                _buildIcon(
                  context,
                  message: S.of(context).audioCall,
                  icon: SvgPicture.asset(ChatifyVectors.calls, width: 22, height: 22, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  onTap: () async {
                    if (await DeviceUtils.hasInternetConnection()) {
                      widget.onAudioCall?.call();
                    } else {
                      showNoInternetConnectionDialog(context);
                    }
                  },
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
              ],
            ),
          ),
        ],
        if (isMobile) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: widget.onVideoCall,
                mouseCursor: SystemMouseCursors.basic,
                borderRadius: BorderRadius.circular(30),
                splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: HeroIcon(HeroIcons.videoCamera, size: 26, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                ),
              ),
              SizedBox(width: 6),
              InkWell(
                onTap: widget.onAudioCall,
                mouseCursor: SystemMouseCursors.basic,
                borderRadius: BorderRadius.circular(30),
                splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.steelGrey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    ChatifyVectors.calls,
                    width: 24,
                    height: 24,
                    color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (Platform.isWindows) const SizedBox(width: 5),
        if (!Platform.isWindows)
          PopupMenuButton<int>(
            tooltip: S.of(context).more,
            padding: EdgeInsets.zero,
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            icon: const Icon(Icons.more_vert, size: 26),
            onSelected: widget.onPopupItemSelected,
            itemBuilder: (context) => [
              _popupItem(context, 1, S.of(context).groupData),
              _popupItem(context, 2, S.of(context).mediaGroups),
              _popupItem(context, 3, S.of(context).search),
              _popupItem(context, 4, S.of(context).noSound),
              _popupItem(context, 5, S.of(context).disappearingMessages),
              _popupItem(context, 6, S.of(context).wallpaper),
              _popupItem(context, 7, S.of(context).addToList),
              _popupItem(context, 8, S.of(context).more),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        if (Platform.isWindows)
        CustomSearchButton(
          searchController: _searchController,
          searchScaleAnimation: _searchScaleAnimation,
          onPressed: widget.onSearch,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  PopupMenuItem<int> _popupItem(BuildContext context, int value, String title) {
    return PopupMenuItem<int>(
      value: value,
      child: Text(
        title,
        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context, {
    required String message,
    required Widget icon,
    required VoidCallback? onTap,
    required BorderRadius borderRadius,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  }) {
    return CustomTooltip(
      message: message,
      verticalOffset: -70,
      horizontalOffset: -35,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.basic,
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
        borderRadius: borderRadius,
        child: Container(padding: padding, child: icon),
      ),
    );
  }
}
