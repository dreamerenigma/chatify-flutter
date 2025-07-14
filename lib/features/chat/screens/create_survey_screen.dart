import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class CreateSurveyScreen extends StatefulWidget {
  const CreateSurveyScreen({super.key});

  @override
  State<CreateSurveyScreen> createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final TextEditingController askQuestionController = TextEditingController();
  final FocusNode askQuestionFocusNode = FocusNode();
  final TextEditingController addQuestionOneController = TextEditingController();
  final FocusNode addQuestionOneFocusNode = FocusNode();
  final TextEditingController addQuestionTwoController = TextEditingController();
  final FocusNode addQuestionTwoFocusNode = FocusNode();
  final isFocusedNotifier = ValueNotifier<bool>(false);
  bool allowMultipleAnswers = false;

  @override
  Widget build(BuildContext context) {
    askQuestionFocusNode.addListener(() {
      isFocusedNotifier.value = askQuestionFocusNode.hasFocus;
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).createPoll, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: isFocusedNotifier,
              builder: (context, isFocused, child) {
                return Text(S.of(context).question,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.bold,
                    color: isFocused ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.darkGrey,
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              ),
              child: SizedBox(
                child: TextFormField(
                  controller: askQuestionController,
                  focusNode: askQuestionFocusNode,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeMd,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: S.of(context).askQuestion,
                    hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                    border: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.white)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(S.of(context).options, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.bold,)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                ),
                child: TextFormField(
                  controller: addQuestionOneController,
                  focusNode: addQuestionOneFocusNode,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeMd,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: S.of(context).addPlus,
                    hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                    border: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.white)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                ),
                child: TextFormField(
                  controller: addQuestionTwoController,
                  focusNode: addQuestionTwoFocusNode,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeMd,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: S.of(context).addPlus,
                    hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                    border: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.white)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  allowMultipleAnswers = !allowMultipleAnswers;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).allowMultipleAnswers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  Switch(
                    value: allowMultipleAnswers,
                    onChanged: (bool value) {
                      setState(() {
                        allowMultipleAnswers = value;
                      });
                    },
                    activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          heroTag: 'survey',
          onPressed: () {
            if (questionController.text.isEmpty ||
                option1Controller.text.isEmpty ||
                option2Controller.text.isEmpty) {
              Get.snackbar(
                S.of(context).warning,
                S.of(context).addQuestionTwoAnswerOptions,
                backgroundColor: ChatifyColors.white.withAlpha((0.5 * 255).toInt()),
                colorText: ChatifyColors.black,
                titleText: const SizedBox.shrink(),
              );
            } else {
              log("Survey Created");
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
