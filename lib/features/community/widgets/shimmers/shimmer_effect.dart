import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/app_colors.dart';

class ShimmerEffect extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double angle;

  const ShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.angle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Shimmer.fromColors(
        baseColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: ChatifyColors.white, borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
    );
  }
}
