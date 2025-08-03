import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../utils/constants/app_colors.dart';
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
              child: const Icon(HugeIcons.strokeRoundedStar, color: ChatifyColors.black, size: 38),
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
