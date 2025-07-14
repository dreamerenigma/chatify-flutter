import 'package:flutter/material.dart';

import '../../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class CenteredStarIcon extends StatelessWidget {
  const CenteredStarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatifyColors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              child: const Icon(Icons.star_border_rounded, color: ChatifyColors.white, size: 50),
            ),
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.white, width: 2)),
            ),
          ],
        ),
      ),
    );
  }
}
