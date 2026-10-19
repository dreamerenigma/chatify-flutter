import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CenteredStarIcon extends StatelessWidget {
  const CenteredStarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SvgPicture.asset(ChatifyVectors.star, width: 30, height: 30, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
              ),
            ),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.black, width: 2)),
            ),
          ],
        ),
      ),
    );
  }
}
