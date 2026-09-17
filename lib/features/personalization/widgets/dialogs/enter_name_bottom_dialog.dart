import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'light_dialog.dart';

void showEnterNameBottomDialog(BuildContext context, String initialName, Function(String) onSave) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) {
      return EnterNameBottomSheet(initialName: initialName, onSave: onSave);
    },
  );
}

class EnterNameBottomSheet extends StatefulWidget {
  final String initialName;
  final Function(String) onSave;

  const EnterNameBottomSheet({
    super.key,
    required this.initialName,
    required this.onSave,
  });

  @override
  State<EnterNameBottomSheet> createState() => _EnterNameBottomSheetState();
}

class _EnterNameBottomSheetState extends State<EnterNameBottomSheet> {
  static const int maxLength = 25;
  late final TextEditingController controller;
  late final FocusNode focusNode;

  final ValueNotifier<int> charCountNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialName);
    focusNode = FocusNode();
    charCountNotifier.value = controller.text.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      focusNode.requestFocus();
      controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    charCountNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = colorsController.getColor(colorsController.selectedColorScheme.value);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).enterYourName, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
            const SizedBox(height: 20),
            TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: color,
                selectionColor: color.withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: color,
              ),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                textCapitalization: TextCapitalization.sentences,
                onTapOutside: (_) {
                  focusNode.unfocus();
                },
                maxLength: maxLength,
                buildCounter: (context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) {
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('Ваше имя', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: color, width: 2)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ChatifyColors.grey, width: 1)),
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined, color: ChatifyColors.grey),
                    onPressed: () {},
                  ),
                ),
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                onChanged: (value) {
                  charCountNotifier.value = value.length;
                },
              ),
            ),
            const SizedBox(height: 6),
            ValueListenableBuilder<int>(
              valueListenable: charCountNotifier,
              builder: (context, count, _) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('$count/$maxLength', style: const TextStyle(color: ChatifyColors.grey, fontSize: 13, fontWeight: FontWeight.w400)),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Ваше имя будут видеть все пользователи Chatify и люди, которых вы пригласите присоединиться.',
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
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
                    foregroundColor: color,
                    backgroundColor: color.withAlpha((0.1 * 255).toInt()),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {
                    widget.onSave(controller.text.trim());
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                    backgroundColor: color.withAlpha((0.1 * 255).toInt()),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(S.of(context).save, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
