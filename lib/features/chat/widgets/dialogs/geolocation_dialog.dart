import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showGeolocationDialog(BuildContext context, {required VoidCallback onNext}) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        actionsPadding: const EdgeInsets.only(left: 20, right: 24, top: 20, bottom: 20),
        contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(ChatifyVectors.geolocation, width: 45, height: 45),
            const SizedBox(height: 50),
            Text.rich(
              TextSpan(
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5),
                children: [
                  TextSpan(
                    text: 'Участники данного чата будут видеть ваше местоположение в режиме реального времени. Данная опция позволяет делиться вашим местоположением на протяжении выбранного вами времени, даже если вы не используйте приложение. Вы можете перестать делиться геоданными в любое время.',
                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: 'Подробнее',
                    style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onNext();
            },
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(S.of(context).next, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
        ],
      );
    }
  );
}
