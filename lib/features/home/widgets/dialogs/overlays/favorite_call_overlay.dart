import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/devices/device_utility.dart';
import '../../../../../utils/popups/custom_tooltip.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

Future<void> showFavoriteCallOverlay(BuildContext context, Offset position) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: Navigator.of(context));
  final Animation<Offset> offsetAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset.zero).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
  const fakeGroupImage = 'https://via.placeholder.com/150';

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                animationController.reverse().then((_) {
                  overlayEntry.remove();
                  completer.complete();
                  animationController.dispose();
                });
              },
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: SlideTransition(
              position: offsetAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: 350,
                    height: 550,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 12),
                          child: _buildFavoriteCalls(context, fakeGroupImage),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();

  return completer.future;
}

Widget _buildFavoriteCalls(BuildContext context, String groupImage) {
  return Padding(
    padding: const EdgeInsets.only(left: 6),
    child: Material(
      color: ChatifyColors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w600, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
              Row(
                children: [
                  CustomTooltip(
                    message: S.of(context).editFavorites,
                    horizontalOffset: -70,
                    child: InkWell(
                      onTap: () {},
                      mouseCursor: SystemMouseCursors.basic,
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(6),
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(JamIcons.pencil, size: 20),
                      ),
                    ),
                  ),
                  CustomTooltip(
                    message: S.of(context).addToFavorites,
                    horizontalOffset: -70,
                    child: InkWell(
                      onTap: () {},
                      mouseCursor: SystemMouseCursors.basic,
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(6),
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(FluentIcons.add_28_filled, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: CachedNetworkImage(
                    width: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                    height: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                    imageUrl: groupImage,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                      foregroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                      foregroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                      child: SvgPicture.asset(
                        ChatifyVectors.communityUsers,
                        color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey,
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Семейная', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500, fontFamily: 'Roboto')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
