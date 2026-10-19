import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../widgets/dialogs/light_dialog.dart';

class EnterNameScreen extends StatefulWidget {
  final String initialName;
  final Function(String) onSave;

  const EnterNameScreen({
    super.key,
    required this.initialName,
    required this.onSave,
  });

  @override
  State<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            title: Text(S.of(context).name, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSelectionTheme(
                      data: TextSelectionThemeData(cursorColor: color, selectionColor: color.withAlpha((0.3 * 255).toInt()), selectionHandleColor: color),
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        textCapitalization: TextCapitalization.sentences,
                        onTapOutside: (_) {
                          focusNode.unfocus();
                        },
                        maxLength: maxLength,
                        buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text('Ваше имя', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: color, width: 2)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ChatifyColors.grey, width: 1)),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: IconButton(icon: const Icon(Icons.emoji_emotions_outlined, size: 25, color: ChatifyColors.darkGrey), onPressed: () {}),
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
                      'Ваше имя будут видеть пользователи Chatify и люди, которых вы пригласите присоединиться.',
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(controller.text.trim());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ChatifyColors.white,
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  child: Text(S.of(context).save, style: TextStyle( color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
