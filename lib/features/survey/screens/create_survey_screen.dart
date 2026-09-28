import 'dart:developer';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/chat_api.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/popups/app_loaders.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class CreateSurveyScreen extends StatefulWidget {
  final UserModel user;

  const CreateSurveyScreen({
    super.key,
    required this.user,
  });

  @override
  State<CreateSurveyScreen> createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  final TextEditingController askQuestionController = TextEditingController();
  final FocusNode askQuestionFocusNode = FocusNode();
  final List<TextEditingController> optionControllers = [TextEditingController(), TextEditingController()];
  final List<FocusNode> optionFocusNodes = [FocusNode(), FocusNode()];
  final isFocusedNotifier = ValueNotifier<bool>(false);
  bool allowMultipleAnswers = false;

  void addOption() {
    setState(() {
      optionControllers.add(TextEditingController());
      optionFocusNodes.add(FocusNode());
    });
  }

  void removeOption(int index) {
    if (optionControllers.length <= 2) {
      return;
    }

    final controller = optionControllers.removeAt(index);
    final focusNode = optionFocusNodes.removeAt(index);

    controller.dispose();
    focusNode.dispose();

    setState(() {});
  }

  void onOptionChanged(int index, String value) {
    if (!allowMultipleAnswers) {
      return;
    }

    final hasText = value.trim().isNotEmpty;
    final isLastField = index == optionControllers.length - 1;

    if (isLastField && hasText) {
      addOption();
      return;
    }

    if (!hasText && index < optionControllers.length - 1) {
      setState(() {
        while (
        optionControllers.length > index + 1 &&
            optionControllers.length > 2) {
          final controller = optionControllers.removeLast();
          final focusNode = optionFocusNodes.removeLast();

          controller.dispose();
          focusNode.dispose();
        }
      });
    }
  }

  Future<void> createSurvey() async {
    final question = askQuestionController.text.trim();
    final options = optionControllers.map((controller) => controller.text.trim()).where((option) => option.isNotEmpty).toList();

    if (question.isEmpty || options.length < 2) {
      Get.snackbar(
        S.of(context).warning,
        S.of(context).addQuestionTwoAnswerOptions,
        backgroundColor: ChatifyColors.white.withAlpha((0.5 * 255).toInt()),
        colorText: ChatifyColors.black,
        titleText: const SizedBox.shrink(),
      );

      return;
    }

    try {
      await ChatApi.createSurvey(chatUser: widget.user, question: question, options: options, allowMultipleAnswers: allowMultipleAnswers);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e, stackTrace) {
      log('CREATE SURVEY ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        'Ошибка создания опроса',
        icon: SvgPicture.asset(ChatifyVectors.closeCircle, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.danger, BlendMode.srcIn)),
        iconColor: ChatifyColors.danger,
        position: SnackBarPositionType.bottom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(S.of(context).createPoll, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isFocusedNotifier,
                  builder: (context, isFocused, child) {
                    return Text(S.of(context).question, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey));
                  },
                ),
                const SizedBox(height: 12),
                TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  ),
                  child: TextFormField(
                    controller: askQuestionController,
                    focusNode: askQuestionFocusNode,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: S.of(context).askQuestion,
                      hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Text(S.of(context).options, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 375),
                  child: SizedBox(
                    height: optionControllers.length * 75.0,
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: optionControllers.length,
                      proxyDecorator: (child, index, animation) {
                        return Material(color: ChatifyColors.transparent, elevation: 0, child: child);
                      },
                      onReorderItem: (oldIndex, newIndex) {
                        setState(() {
                          final controller = optionControllers.removeAt(oldIndex);
                          optionControllers.insert(newIndex, controller);

                          final focusNode = optionFocusNodes.removeAt(oldIndex);
                          optionFocusNodes.insert(newIndex, focusNode);
                        });
                      },
                      itemBuilder: (context, index) {
                        final controller = optionControllers[index];
                        final focusNode = optionFocusNodes[index];

                        return Container(
                          key: ValueKey(controller),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: TextSelectionTheme(
                            data: TextSelectionThemeData(
                              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            ),
                            child: TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: S.of(context).addPlus,
                                hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                suffixIcon: controller.text.trim().isNotEmpty
                                  ? ReorderableDragStartListener(
                                      index: index,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: SvgPicture.asset(ChatifyVectors.twoLineHorizontal, width: 17, height: 17, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                                      ),
                                    )
                                  : null,
                              ),
                              onChanged: (value) {
                                setState(() {});

                                onOptionChanged(index, value);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).allowMultipleAnswers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    CustomSwitch(
                      value: allowMultipleAnswers,
                      onChanged: (bool value) {
                        setState(() {
                          allowMultipleAnswers = value;
                          if (!value) {
                            while (optionControllers.length > 2) {
                              optionControllers.removeLast().dispose();
                              optionFocusNodes.removeLast().dispose();
                            }
                          }
                        });
                      },
                      switchWidth: 55,
                      switchHeight: 33,
                      thumbSize: 25,
                      thumbPadding: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'survey',
          onPressed: createSurvey,
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: Icon(Icons.send, size: 25, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white),
        ),
      ),
    );
  }
}
