import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showEnterNameBottomDialog(BuildContext context, String initialName, Function(String) onSave) {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController(text: initialName);
  final ValueNotifier<int> charCountNotifier = ValueNotifier(initialName.length);
  const int maxLength = 25;

  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      });

      return Wrap(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Введите своё имя', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.start),
                const SizedBox(height: 16),
                TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: charCountNotifier,
                    builder: (context, count, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ChatifyColors.grey, width: 1.0)),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                              onChanged: (val) {
                                if (val.length <= maxLength) {
                                  charCountNotifier.value = val.length;
                                } else {
                                  controller.text = val.substring(0, maxLength);
                                  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                }
                              },
                            ),
                          ),
                          if (count > 0) ...[
                            const SizedBox(width: 14),
                            Text('${maxLength - count}'),
                            const SizedBox(width: 25),
                            const Icon(Icons.emoji_emotions_outlined, color: ChatifyColors.grey),
                          ]
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text('Отмена', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        onSave(controller.text.trim());
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text('Сохранить', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
