import 'package:chatify/features/home/widgets/checkboxes/custom_checkbox.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';

void showClearChatBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (context) {
      final RxList<bool> selectedOptions = <bool>[false, false, false].obs;
      bool isUserAddList = false;
      bool isButtonPressed = false;

      return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Center(
                    child: Container(width: 36, height: 4, decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, borderRadius: BorderRadius.circular(2))),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('Очистка чатов (1)', textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                      Positioned(
                        right: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close_rounded, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Text('Все сообщения в этих чатах будут удалены. Это действие невозможно отменить.', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
                CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 5),
                Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () {
                      setState(() {
                        isUserAddList = !isUserAddList;
                        selectedOptions[0] = isUserAddList;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          IgnorePointer(
                            child: CustomCheckbox(
                              selectedOptions: selectedOptions,
                              onChanged: (_) {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(child: Text('Очистить избранные сообщения', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Listener(
                    onPointerDown: (_) {
                      setState(() => isButtonPressed = true);
                    },
                    onPointerUp: (_) {
                      setState(() => isButtonPressed = false);
                    },
                    onPointerCancel: (_) {
                      setState(() => isButtonPressed = false);
                    },
                    child: AnimatedScale(
                      scale: isButtonPressed ? 0.96 : 1.0,
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      child: SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ChatifyColors.transparent,
                            foregroundColor: ChatifyColors.danger.withValues(alpha: 0.3),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                            shadowColor: ChatifyColors.transparent,
                            side: const BorderSide(color: ChatifyColors.lightSoftNight),
                          ),
                          child: Text('Очистить чаты (12 MB)', style: TextStyle(color: ChatifyColors.danger, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
      );
    }
  );
}
