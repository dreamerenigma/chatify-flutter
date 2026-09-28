import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';
import '../../../api/chat_api.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/popups/dialogs.dart';
import '../../calls/widgets/dialog/reminder_call_bottom_dialog.dart';
import '../../calls/widgets/dialog/type_call_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/buttons/custom_floating_button.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../models/user_model.dart';

class CreateEventScreen extends StatefulWidget {
  final UserModel user;

  const CreateEventScreen({
    super.key,
    required this.user,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final storage = GetStorage();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController locationController;
  late final FocusNode nameFocusNode;
  late final FocusNode descriptionFocusNode;
  late final FocusNode locationFocusNode;
  late DateTime roundedStartTime;
  late DateTime nextStartTime;
  late String dateFormatted;
  late String timeFormattedStart;
  late String timeFormattedEnd;
  bool isEndTimeVisible = true;
  bool isLinkCallApp = true;
  bool isApprovalRequired = true;
  bool isBringGuestEnabled = false;
  int? pressedSwitch;
  String callType = 'Видео';

  static const int linkCallSwitch = 0;
  static const int approvalSwitch = 1;
  static const int guestSwitch = 2;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    descriptionFocusNode = FocusNode();
    locationController = TextEditingController();
    locationFocusNode = FocusNode();

    final now = DateTime.now();

    roundedStartTime = DateTime(now.year, now.month, now.day, now.hour + 1);
    nextStartTime = roundedStartTime.add(const Duration(hours: 1));
    dateFormatted = DateFormat("d MMM y 'г.'", 'ru').format(roundedStartTime);
    timeFormattedStart = DateFormat('HH:mm').format(roundedStartTime);
    timeFormattedEnd = DateFormat('HH:mm').format(nextStartTime);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!mounted) return;
    //
    //   nameFocusNode.requestFocus();
    // });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    locationFocusNode.dispose();
    super.dispose();
  }

  void toggleBringGuest(bool value) async {
    if (!mounted) return;

    setState(() {
      isBringGuestEnabled = value;
    });

    await storage.write('isBringGuestEnabled', value);
  }

  void toggleLinkCall() {
    setState(() {
      isLinkCallApp = !isLinkCallApp;
    });
  }

  Future<void> selectEventDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: roundedStartTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('ru'),
    );

    if (selectedDate == null) return;

    setState(() {
      roundedStartTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        roundedStartTime.hour,
        roundedStartTime.minute,
      );

      dateFormatted = DateFormat("d MMM y 'г.'", 'ru').format(roundedStartTime);
    });
  }

  Future<TimeOfDay?> _showEventTimePicker({required DateTime initialDateTime}) async {
    final color = colorsController.getColor(colorsController.selectedColorScheme.value);

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
      helpText: '',
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('ru'),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: color,
                onPrimary: ChatifyColors.white,
                surface: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.white,
                onSurface: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
                hourMinuteColor: color,
                hourMinuteTextColor: ChatifyColors.white,
                dayPeriodColor: color,
                dayPeriodTextColor: ChatifyColors.white,
                dayPeriodTextStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                dialBackgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
                dialHandColor: color,
                dialTextColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                entryModeIconColor: color,
                helpTextStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(color),
                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(color),
                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
  }

  Future<void> selectEventStartTime() async {
    final selectedTime = await _showEventTimePicker(initialDateTime: roundedStartTime);

    if (selectedTime == null) return;

    setState(() {
      roundedStartTime = DateTime(
        roundedStartTime.year,
        roundedStartTime.month,
        roundedStartTime.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      timeFormattedStart = DateFormat('HH:mm').format(roundedStartTime);

      nextStartTime = roundedStartTime.add(const Duration(hours: 1));

      timeFormattedEnd = DateFormat('HH:mm').format(nextStartTime);
    });
  }

  Future<void> selectEventEndTime() async {
    final selectedTime = await _showEventTimePicker(initialDateTime: nextStartTime);

    if (selectedTime == null) return;

    setState(() {
      nextStartTime = DateTime(
        nextStartTime.year,
        nextStartTime.month,
        nextStartTime.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      timeFormattedEnd = DateFormat('HH:mm').format(nextStartTime);
    });
  }

  Future<void> createEvent() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Мероприятие', 'Введите название мероприятия');
      return;
    }

    if (nextStartTime.isBefore(roundedStartTime) || nextStartTime.isAtSameMomentAs(roundedStartTime)) {
      Get.snackbar('Мероприятие', 'Время окончания должно быть позже времени начала');

      return;
    }

    await Dialogs.showProgressBarDialog(context, title: 'Создание мероприятия...');

    try {
      await ChatApi.createEvent(
        chatUser: widget.user,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        startEvent: Timestamp.fromDate(roundedStartTime),
        endEvent: Timestamp.fromDate(nextStartTime),
        location: locationController.text.trim(),
        callType: callType == 'Видео' ? 'video' : 'audio',
      );

      if (!mounted) return;

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e, st) {
      log('CREATE EVENT ERROR: $e', stackTrace: st);

      if (!mounted) return;

      Navigator.pop(context);

      Get.snackbar('Ошибка', 'Не удалось создать мероприятие');
    }
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
            title: Text('Создать мероприятие', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            elevation: 0,
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
      floatingActionButton: CustomFloatingButton(
        heroTag: 'addEvent',
        extended: false,
        icon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: const Icon(Icons.send, color: ChatifyColors.black, size: 24),
        ),
        padding: const EdgeInsets.only(bottom: 5),
        onPressed: createEvent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      hintText: 'Название мероприятия',
                      hintStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400),
                      style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w600),
                      showClearButton: true,
                      minLines: 1,
                      maxLines: 1,
                      padding: const EdgeInsets.only(left: 20, right: 4, top: 4),
                    ),
                    _buildTextField(
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                      hintText: S.of(context).descriptionOptional,
                      hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      minLines: 1,
                      maxLines: null,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400),
                      padding: const EdgeInsets.only(left: 20, right: 8),
                    ),
                    CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(UniconsLine.calendar_alt, size: 23, color: ChatifyColors.darkGrey),
                          const SizedBox(width: 20),
                          Material(
                            color: ChatifyColors.transparent,
                            child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                              onTap: selectEventDate,
                              child: Text(dateFormatted, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                            ),
                          ),
                          const Spacer(),
                          Material(
                            color: ChatifyColors.transparent,
                            child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                              onTap: selectEventStartTime,
                              child: Text(timeFormattedStart, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                            ),
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
                                  padding: const EdgeInsets.only(left: 27, top: 4, bottom: 2),
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
                                    const Icon(UniconsLine.calendar_alt, size: 23, color: ChatifyColors.darkGrey),
                                    const SizedBox(width: 20),
                                    Material(
                                      color: ChatifyColors.transparent,
                                      child: InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        onTap: selectEventDate,
                                        child: Text(dateFormatted, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                    const Spacer(),
                                    Material(
                                      color: ChatifyColors.transparent,
                                      child: InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                        onTap: selectEventEndTime,
                                        child: Text(timeFormattedEnd, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                      ),
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
                      padding: const EdgeInsets.only(left: 60, right: 30, top: 30, bottom: 10),
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
                    Material(
                      color: ChatifyColors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 14),
                        child: Row(
                          children: [
                            SizedBox(width: 26, child: Icon(Icons.location_on_outlined, size: 26, color:ChatifyColors.darkGrey)),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextSelectionTheme(
                                data: TextSelectionThemeData(
                                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                ),
                                child: TextField(
                                  controller: locationController,
                                  focusNode: locationFocusNode,
                                  textCapitalization: TextCapitalization.sentences,
                                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    hintText: 'Добавить местоположение',
                                    hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                                    suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                    suffixIcon: locationController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            locationController.clear();
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.close_rounded, size: 24, color: ChatifyColors.darkGrey),
                                        )
                                      : null,
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        onTapDown: (_) {
                          setState(() {
                            pressedSwitch = linkCallSwitch;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            pressedSwitch = null;
                            isLinkCallApp = !isLinkCallApp;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            pressedSwitch = null;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              SizedBox(width: 26, child: Icon(callType == 'Видео' ? Icons.videocam_outlined : Icons.call_outlined, size: 26, color:ChatifyColors.darkGrey)),
                              const SizedBox(width: 18),
                              Expanded(child: Text('Ссылка на звонок в Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                              const SizedBox(width: 12),
                              CustomSwitch(
                                value: isLinkCallApp,
                                onChanged: (newValue) {
                                  setState(() {
                                    isLinkCallApp = newValue;
                                  });
                                },
                                isPressed: pressedSwitch == linkCallSwitch,
                                switchWidth: 55,
                                switchHeight: 33,
                                thumbSize: 25,
                                thumbPadding: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: isLinkCallApp
                        ? Column(
                            children: [
                              Material(
                                color: ChatifyColors.transparent,
                                child: InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                  onTap: () {
                                    showTypeCallDialog(
                                      context,
                                      (selectedType) {
                                        setState(() {
                                          callType = selectedType;
                                        });
                                      },
                                      callType,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 47, vertical: 14),
                                    child: Row(
                                      children: [
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
                                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                  onTapDown: (_) {
                                    setState(() {
                                      pressedSwitch = approvalSwitch;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      pressedSwitch = null;
                                      isApprovalRequired = !isApprovalRequired;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      pressedSwitch = null;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(ChatifyVectors.personTime, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                                        const SizedBox(width: 20),
                                        Expanded(child: Text('Для присоединения требуется одобрение', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                                        const SizedBox(width: 12),
                                        CustomSwitch(
                                          value: isApprovalRequired,
                                          onChanged: (newValue) {
                                            setState(() {
                                              isApprovalRequired = newValue;
                                            });
                                          },
                                          isPressed: pressedSwitch == approvalSwitch,
                                          switchWidth: 55,
                                          switchHeight: 33,
                                          thumbSize: 25,
                                          thumbPadding: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    ),
                    SizedBox(height: 10),
                    CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
                    SizedBox(height: 5),
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
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
                                  Text('За 1 час', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                        onTapDown: (_) {
                          setState(() {
                            pressedSwitch = guestSwitch;
                          });
                        },
                        onTapUp: (_) {
                          final newValue = !isBringGuestEnabled;

                          setState(() {
                            pressedSwitch = null;
                          });

                          toggleBringGuest(newValue);
                        },
                        onTapCancel: () {
                          setState(() {
                            pressedSwitch = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 25, right: 20, top: 16, bottom: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Разрешить доступ для гостей', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                    Text('Разрешить пользователям приводить с собой одного гостя', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 40),
                              CustomSwitch(
                                value: isBringGuestEnabled,
                                onChanged: toggleBringGuest,
                                isPressed: pressedSwitch == guestSwitch,
                                switchWidth: 55,
                                switchHeight: 33,
                                thumbSize: 25,
                                thumbPadding: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
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
              textCapitalization: TextCapitalization.sentences,
              scrollPadding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintStyle ?? TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: showClearButton && controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 25),
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
