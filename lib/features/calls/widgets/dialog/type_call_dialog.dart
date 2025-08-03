import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../authentication/widgets/buttons/custom_radio_button.dart';

void showTypeCallDialog(BuildContext context, ValueChanged<String> onCallTypeSelected, String initialValue) {
  String selectedCallType = initialValue;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "CallTypeDialog",
    barrierColor: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) {
      return Dialog(
        backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(S.of(context).selectCallType, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 16),
                  CustomRadioButton(
                    title: S.of(context).video,
                    imagePath: '',
                    value: 'Видео',
                    groupValue: selectedCallType,
                    onChanged: (value) {
                      setState(() => selectedCallType = value!);
                      onCallTypeSelected(value!);
                      Navigator.pop(context);
                    },
                    fontSize: ChatifySizes.fontSizeSm,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  ),
                  CustomRadioButton(
                    title: S.of(context).audio,
                    imagePath: '',
                    value: 'Аудио',
                    groupValue: selectedCallType,
                    onChanged: (value) {
                      setState(() => selectedCallType = value!);
                      onCallTypeSelected(value!);
                      Navigator.pop(context);
                    },
                    fontSize: ChatifySizes.fontSizeSm,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(opacity: anim1, child: child);
    },
  );
}
