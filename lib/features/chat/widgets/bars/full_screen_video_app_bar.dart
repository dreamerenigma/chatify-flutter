import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
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
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
              size: Platform.isWindows ? 18 : 24,
              message: S.of(context).back,
            ),
            actions: [
              _buildIconButton(
                context: context,
                icon: isFavorited ? PhosphorIcons.star_fill : PhosphorIcons.star,
                onTap: () => setState(() => isFavorited = !isFavorited),
                size: Platform.isWindows ? 19 : 24,
                message: S.of(context).imageAddToFavorites,
              ),
              _buildIconButton(
                context: context,
                icon: Platform.isWindows ? FluentIcons.emoji_20_regular : FluentIcons.arrow_forward_16_filled,
                onTap: () {},
                size: Platform.isWindows ? 20 : 24,
                message: S.of(context).reactToMessage,
              ),
              _buildIconButton(
                context: context,
                icon: Platform.isWindows ? FluentIcons.more_horizontal_20_filled : Icons.more_vert,
                onTap: () {},
                size: Platform.isWindows ? 18 : 24,
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
  required IconData icon,
  required VoidCallback onTap,
  required String message,
  double size = 24,
  Color color = ChatifyColors.white,
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
        child: Icon(icon, color: color, size: size),
      ),
    ),
  );
}
