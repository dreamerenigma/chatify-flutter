import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/controllers/dialog_controller.dart';

void showDeleteMessageDialog(BuildContext context, {String? title, String? description}) {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  ValueNotifier<int?> selectedOptionIndex = ValueNotifier<int?>(null);

  overlayEntry = OverlayEntry(
    builder: (context) {
      dialogController.openWindowsDialog();

      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                overlayEntry.remove();
                dialogController.closeWindowsDialog();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: ChatifyColors.black.withAlpha((0.5 * 255).toInt())),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Material(
              color: ChatifyColors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: 430,
                  decoration: BoxDecoration(
                    border: Border.all(color: ChatifyColors.buttonDarkGrey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.grey,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15), bottom: Radius.circular(15)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 24, right: 24, top: 22, bottom: description != null ? 28 : 22),
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (title != null) Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                                  SizedBox(height: description != null ? 10 : 0),
                                  if (description != null) Text(description, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                                  SizedBox(height: 12),
                                  _buildDeleteOptions(context, selectedOptionIndex),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.buttonGrey, width: 0.5)),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ValueListenableBuilder<int?>(
                                        valueListenable: selectedOptionIndex,
                                        builder: (context, selectedIndex, child) {

                                          return TextButton(
                                            onPressed: () async {
                                              overlayEntry.remove();
                                              dialogController.closeWindowsDialog();
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: selectedIndex != null && selectedIndex >= 0 ? ChatifyColors.ascentRed : (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.buttonGrey),
                                              foregroundColor: ChatifyColors.black,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              elevation: 1,
                                              shadowColor: ChatifyColors.black,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 6),
                                              child: Text(S.of(context).delete, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white)),
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Future.delayed(Duration(milliseconds: 100), () {
                                            overlayEntry.remove();
                                            dialogController.closeWindowsDialog();
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                                          foregroundColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          side: BorderSide(color: ChatifyColors.grey, width: 1),
                                          elevation: 1,
                                          shadowColor: ChatifyColors.black,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 6),
                                          child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  );

  overlay.insert(overlayEntry);
}

Widget _buildDeleteOptions(BuildContext context, ValueNotifier<int?> selectedOptionIndex) {
  List<String> options = ['Удалить у меня', 'Удалить у всех'];
  List<ValueNotifier<bool>> hoverStateList = List.generate(options.length, (index) => ValueNotifier<bool>(false));

  return Column(
    children: List.generate(options.length, (index) {
      return ValueListenableBuilder<int?>(
        valueListenable: selectedOptionIndex,
        builder: (context, selectedIndex, child) {
          bool isSelected = selectedIndex == index;

          return ValueListenableBuilder<bool>(
            valueListenable: hoverStateList[index],
            builder: (context, isHovered, child) {
              return GestureDetector(
                onTap: () {
                  selectedOptionIndex.value = index;
                },
                child: MouseRegion(
                  onEnter: (_) {
                    hoverStateList[index].value = true;
                  },
                  onExit: (_) {
                    hoverStateList[index].value = false;
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? ChatifyColors.transparent : (isHovered ? ChatifyColors.grey : ChatifyColors.transparent),
                            border: Border.all(
                              color: isSelected ? ChatifyColors.ascentRed : ChatifyColors.darkGrey,
                              width: isSelected ? (isHovered ? 3 : 5) : 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          options[index],
                          style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        },
      );
    }),
  );
}
