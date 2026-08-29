import 'dart:math' as math;
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
      verticalOffset: -70,
      horizontalOffset: -35,
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
            padding: const EdgeInsets.all(11),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: ScaleTransition(
                scale: searchScaleAnimation,
                child: SvgPicture.asset(ChatifyVectors.searchOutline, width: 18, height: 18, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground, BlendMode.srcIn)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
