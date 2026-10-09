import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showClosingChatBottomSheetDialog(BuildContext context, {VoidCallback? onConfirmed}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    showDragHandle: false,
    barrierColor: ChatifyColors.transparent,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) {
      return ClosingChatBottomSheetDialog(
        onConfirm: () {
          Navigator.of(context).pop();
          onConfirmed?.call();
        },
      );
    },
  );
}

class ClosingChatBottomSheetDialog extends StatefulWidget {
  final VoidCallback? onConfirm;

  const ClosingChatBottomSheetDialog({
    super.key,
    this.onConfirm,
  });

  @override
  State<ClosingChatBottomSheetDialog> createState() => _ClosingChatBottomSheetDialogState();
}

class _ClosingChatBottomSheetDialogState extends State<ClosingChatBottomSheetDialog> {
  final GetStorage storage = GetStorage();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.iconGrey, borderRadius: BorderRadius.circular(4)),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 25),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 40),
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(ChatifyVectors.closingChat, width: 110, height: 110),
                Positioned(
                  right: -7,
                  bottom: -5,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value), border: Border.all(color: ChatifyColors.nightGrey, width: 1.5)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SvgPicture.asset(ChatifyVectors.messageLock, width: 25, height: 25),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(child: Text('Закройте и скройте этот чат', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400, height: 1.3),
                    children: [
                      const TextSpan(
                        text: 'Чтобы перейти в чат и просматривать уведомления на этом устройстве, ''используйте систему распознавания лица или отпечатка пальца. ''Для дополнительной конфиденциальности закрытые чаты хранятся отдельно. ',
                      ),
                      TextSpan(
                        text: 'Подробнее',
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.w500),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildBottomSheetButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            side: BorderSide.none,
          ),
          child: Text('Продолжить', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }
}
