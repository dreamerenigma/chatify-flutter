import 'package:chatify/features/calls/widgets/dialog/type_call_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void showSheduleCallBottomDialog(BuildContext context, {required String username}) {
  final nameController = TextEditingController(text: '${S.of(context).callFromUser} $username');
  final nameFocusNode = FocusNode();
  final descriptionController = TextEditingController();
  final descriptionFocusNode = FocusNode();

  final now = DateTime.now();
  final int roundedMinute = (now.minute >= 30) ? 30 : 0;
  final roundedStartTime = DateTime(now.year, now.month, now.day, now.hour, roundedMinute);
  final nextStartTime = roundedStartTime.add(const Duration(minutes: 30));

  final dateFormatted = DateFormat("d MMM y 'г.'", 'ru').format(roundedStartTime);
  final timeFormattedStart = DateFormat('HH:mm').format(roundedStartTime);
  final timeFormattedEnd = DateFormat('HH:mm').format(nextStartTime);

  final mediaQuery = MediaQuery.of(context);
  final screenHeight = mediaQuery.size.height;
  final statusBarHeight = mediaQuery.padding.top;
  final double sheetHeight = screenHeight - statusBarHeight;

  String callType = 'Видео';
  IconData callIcon = Icons.videocam_outlined;
  bool isEndTimeVisible = true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    enableDrag: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              SizedBox(
                height: sheetHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, size: 22),
                            color: ChatifyColors.darkGrey,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Center(child: Text(S.of(context).callPlanning, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500))),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                    _buildTextField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      hintText: S.of(context).callName,
                      hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.bold),
                      initialValue: '${S.of(context).callFromUser} $username',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.bold),
                      showClearButton: true,
                      minLines: 1,
                      maxLines: 1,
                      padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
                    ),
                    _buildTextField(
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                      hintText: S.of(context).descriptionOptional,
                      hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      minLines: 1,
                      maxLines: null,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400),
                      padding: const EdgeInsets.only(left: 16, right: 8),
                    ),
                    Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(UniconsLine.calendar_alt, color: ChatifyColors.darkGrey),
                          const SizedBox(width: 14),
                          InkWell(
                            onTap: () {},
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            child: Text(dateFormatted, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {},
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            child: Text(timeFormattedStart, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isEndTimeVisible
                          ? Column(
                        key: const ValueKey('visible_end_time'),
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 27, top: 2, bottom: 2),
                              child: Column(
                                children: List.generate(8, (index) {
                                  return Container(
                                    width: 2,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(vertical: 1),
                                    color: ChatifyColors.darkGrey,
                                  );
                                }),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(UniconsLine.calendar_alt, color: ChatifyColors.darkGrey),
                                const SizedBox(width: 14),
                                InkWell(
                                  onTap: () {},
                                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  child: Text(dateFormatted, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {},
                                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  child: Text(timeFormattedEnd, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          : const SizedBox(key: ValueKey('hidden_end_time')),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 30),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isEndTimeVisible = !isEndTimeVisible;
                          });
                        },
                        child: Text(
                          isEndTimeVisible ? S.of(context).removeEventEndTime : S.of(context).addEventEndTime,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        showTypeCallDialog(
                          context,
                              (selectedType) {
                            setState(() {
                              callType = selectedType;
                              callIcon = selectedType == 'Аудио' ? Icons.call_outlined : Icons.videocam_outlined;
                            });
                          },
                          callType,
                        );
                      },
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Icon(callIcon, size: 28, color: ChatifyColors.darkGrey),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context).callType, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                                Text(callType, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorsController.getColor(colorsController.selectedColorScheme.value),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: FloatingActionButton(
                    heroTag: 'sendMessageCall',
                    onPressed: () {},
                    backgroundColor: ChatifyColors.transparent,
                    foregroundColor: ChatifyColors.white,
                    elevation: 0,
                    child: Icon(Icons.send, size: 22, color: ChatifyColors.black),
                  ),
                ),
              ),
            ],
          );
        }
      );
    },
  );
}

Widget _buildTextField({
  required String hintText,
  required TextEditingController controller,
  required FocusNode focusNode,
  String? initialValue,
  TextStyle? style,
  int? minLines,
  int? maxLines,
  bool showClearButton = false,
  TextStyle? hintStyle,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
}) {
  final color = colorsController.getColor(colorsController.selectedColorScheme.value);

  return Padding(
    padding: padding,
    child: StatefulBuilder(
      builder: (context, setState) {
        controller.addListener(() {
          setState(() {});
        });

        return TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: color,
            selectionColor: color.withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: color,
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: style,
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: (maxLines == null || (maxLines) > 1) ? TextInputType.multiline : TextInputType.text,
            textInputAction: (maxLines == null || (maxLines) > 1) ? TextInputAction.newline : TextInputAction.done,
            scrollPadding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle ?? TextStyle(fontSize: ChatifySizes.fontSizeMd),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: showClearButton && controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.clear();
                      focusNode.requestFocus();
                      setState(() {});
                    },
                  )
                : null,
            ),
            enableInteractiveSelection: true,
            expands: false,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
          ),
        );
      },
    ),
  );
}
