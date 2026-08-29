import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/custom_tooltip.dart';

class FullScreenVideoAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FullScreenVideoAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  FullScreenVideoAppBarState createState() => FullScreenVideoAppBarState();
}

class FullScreenVideoAppBarState extends State<FullScreenVideoAppBar> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
            leading: _buildIconButton(
              context: context,
              icon: Icon(Icons.arrow_back, color: ChatifyColors.white, size: Platform.isWindows ? 18 : 24),
              onTap: () => Navigator.pop(context),
              message: S.of(context).back,
            ),
            actions: [
              _buildIconButton(
                context: context,
                icon: SvgPicture.asset(
                  isFavorited ? ChatifyVectors.starFilled : ChatifyVectors.star,
                  width: Platform.isWindows ? 19 : 24,
                  height: Platform.isWindows ? 19 : 24,
                  colorFilter: const ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn),
                ),
                onTap: () => setState(() => isFavorited = !isFavorited),
                message: S.of(context).imageAddToFavorites,
              ),
              _buildIconButton(
                context: context,
                icon: Platform.isWindows ? Icon(FluentIcons.emoji_20_regular) : Icon(FluentIcons.arrow_forward_16_filled, size: Platform.isWindows ? 20 : 24),
                onTap: () {},
                message: S.of(context).reactToMessage,
              ),
              _buildIconButton(
                context: context,
                icon: Platform.isWindows ? Icon(FluentIcons.more_horizontal_20_filled) : Icon(Icons.more_vert, size: Platform.isWindows ? 18 : 24),
                onTap: () {},
                message: S.of(context).otherOptionsHidden,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIconButton({
  required BuildContext context,
  required Widget icon,
  required VoidCallback onTap,
  required String message,
  Color? backgroundColor,
  EdgeInsets padding = const EdgeInsets.all(12),
  double borderRadius = 8,
}) {
  return CustomTooltip(
    message: message,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      splashColor: ChatifyColors.transparent,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      mouseCursor: SystemMouseCursors.basic,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(color: backgroundColor ?? ChatifyColors.transparent, borderRadius: BorderRadius.circular(borderRadius)),
        child: icon,
      ),
    ),
  );
}
