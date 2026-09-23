import 'package:chatify/common/widgets/switches/custom_switch.dart';
import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/dialog/reminder_call_bottom_dialog.dart';
import '../widgets/dialog/type_call_dialog.dart';

class ScheduleCallScreen extends StatefulWidget {
  final UserModel user;

  const ScheduleCallScreen({super.key, required this.user});

  @override
  State<ScheduleCallScreen> createState() => _ScheduleCallScreenState();
}

class _ScheduleCallScreenState extends State<ScheduleCallScreen> {
  late final TextEditingController nameController;
  late final FocusNode nameFocusNode;
  late final TextEditingController descriptionController;
  late final FocusNode descriptionFocusNode;
  late DateTime roundedStartTime;
  late DateTime nextStartTime;
  late String dateFormatted;
  late String timeFormattedStart;
  late String timeFormattedEnd;
  String callType = 'Видео';
  IconData callIcon = Icons.videocam_outlined;
  bool isEndTimeVisible = true;
  bool isApprovalRequired = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final int roundedMinute = now.minute >= 30 ? 30 : 0;

    nameFocusNode = FocusNode();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    descriptionFocusNode = FocusNode();
    roundedStartTime = DateTime(now.year, now.month, now.day, now.hour, roundedMinute);
    nextStartTime = roundedStartTime.add(const Duration(minutes: 30));
    dateFormatted = DateFormat("d MMM y 'г.'", 'ru').format(roundedStartTime);
    timeFormattedStart = DateFormat('HH:mm').format(roundedStartTime);
    timeFormattedEnd = DateFormat('HH:mm').format(nextStartTime);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (nameController.text.isEmpty) {
      nameController.text = '${S.of(context).callFrom} ${widget.user.name}';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text('Запланировать звонок', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
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
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      hintText: S.of(context).callFrom,
                      hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.bold),
                      initialValue: '${S.of(context).callFrom} ${widget.user.name}',
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
                      hintStyle: TextStyle(color: ChatifyColors.steelGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
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
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            child: Text(dateFormatted, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                            onTap: () {},
                          ),
                          const Spacer(),
                          InkWell(
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            child: Text(timeFormattedStart, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                            onTap: () {},
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
                                      return Container(width: 2, height: 4, margin: const EdgeInsets.symmetric(vertical: 1), color: ChatifyColors.darkGrey);
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
                                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                      child: Text(dateFormatted, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                      onTap: () {},
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                      child: Text(timeFormattedEnd, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                      onTap: () {},
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
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Icon(callIcon, size: 28, color: ChatifyColors.darkGrey),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).callType, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                  Text(callType, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              SvgPicture.asset(ChatifyVectors.personTime, width: 28, height: 28, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                              const SizedBox(width: 14),
                              Expanded(child: Text('Для присоединения требуется одобрение', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                              const SizedBox(width: 12),
                              CustomSwitch(
                                value: isApprovalRequired,
                                onChanged: (newValue) {
                                  setState(() {
                                    isApprovalRequired = newValue;
                                  });
                                },
                                switchWidth: 58,
                                switchHeight: 35,
                                thumbSize: 27,
                                thumbPadding: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0),
                    SizedBox(height: 5),
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {
                          showReminderCallBottomDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.notifications_none_rounded, size: 28, color: ChatifyColors.darkGrey),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Напоминание', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                  Text('За 15 минут', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Positioned(
        bottom: 16,
        right: 16,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(18)),
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
            data: TextSelectionThemeData(cursorColor: color, selectionColor: color.withAlpha((0.3 * 255).toInt()), selectionHandleColor: color),
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
}
