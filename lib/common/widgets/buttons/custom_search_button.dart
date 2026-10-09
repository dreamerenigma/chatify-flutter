import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/enums/tooltip_position_type.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/popups/custom_tooltip.dart';

class CustomSearchButton extends StatelessWidget {
  final AnimationController searchController;
  final Animation<double> searchScaleAnimation;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;

  const CustomSearchButton({
    super.key,
    required this.searchController,
    required this.searchScaleAnimation,
    this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      message: 'Поиск в чате (Ctrl+Shift+F)',
      verticalOffset: -40,
      horizontalOffset: -85,
      position: TooltipPositionType.bottom,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(right: 10, top: 10),
        child: InkWell(
          onTapDown: (_) => searchController.forward(),
          onTapUp: (_) => searchController.reverse(),
          onTapCancel: () => searchController.reverse(),
          onTap: () async {
            await searchController.forward();
            await searchController.reverse();
            onPressed?.call();
          },
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(6),
          splashColor: ChatifyColors.transparent,
          highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ScaleTransition(
              scale: searchScaleAnimation,
              child: SvgPicture.asset(ChatifyVectors.searchOutline, width: 20, height: 20, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkBackground, BlendMode.srcIn)),
            ),
          ),
        ),
      ),
    );
  }
}
