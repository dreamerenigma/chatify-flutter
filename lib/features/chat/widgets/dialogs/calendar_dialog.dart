import 'dart:ui';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../home/controllers/dialog_controller.dart';
import 'package:intl/intl.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

enum CalendarView { day, month, year }

void showCalendarDialog(BuildContext context, Offset position, DateTime currentDate, {DateTime? hoveredDate}) {
  final dialogController = Get.find<DialogController>();
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  late Animation<double> animation;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.05), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  animation = Tween<double>(begin: position.dy - 50, end: position.dy).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutQuad));
  String capitalize(String text) => text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  bool isWindowsDialogOpen = dialogController.isWindowsDialogOpen.value;
  CalendarView currentView = CalendarView.day;
  DateTime displayedDate = currentDate;

  overlayEntry = OverlayEntry(builder: (context) {
    return StatefulBuilder(builder: (context, setState) {
      final DateTime now = DateTime.now();
      final rawMonth = DateFormat('LLLL yyyy', 'ru').format(displayedDate);
      final capitalizedMonth = capitalize(rawMonth);
      bool isUpHovered = false;
      bool isDownHovered = false;
      bool canGoBack = displayedDate.year > now.year - 1 || (displayedDate.year == now.year - 1 && displayedDate.month >= now.month);
      bool canGoForward = displayedDate.year < now.year || (displayedDate.year == now.year && displayedDate.month < now.month);
      Widget calendarContent;

      switch (currentView) {
        case CalendarView.day:
          calendarContent = _buildDayView(context, displayedDate, hoveredDate, overlayEntry);
          break;
        case CalendarView.month:
          calendarContent = _buildMonthView((month) {
            setState(() {
              displayedDate = DateTime(displayedDate.year, month);
              currentView = CalendarView.day;
            });
          }, displayedDate.month, context);
          break;
        case CalendarView.year:
          calendarContent = _buildYearView(displayedDate, (newDate) {
            setState(() {
              displayedDate = newDate;
              currentView = CalendarView.month;
            });
          });
          break;
      }

      return Stack(
        children: [
          if (!isWindowsDialogOpen)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                animationController.reverse().then((_) => overlayEntry.remove());
              },
            ),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                top: position.dy,
                left: position.dx - 110,
                child: SlideTransition(
                  position: slideAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.lightGrey.withAlpha((0.7 * 255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: ChatifyColors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (currentView == CalendarView.day) {
                                              currentView = CalendarView.month;
                                            } else if (currentView == CalendarView.month) {
                                              currentView = CalendarView.year;
                                            } else {
                                              currentView = CalendarView.day;
                                            }
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(4),
                                        splashColor: ChatifyColors.transparent,
                                        highlightColor: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
                                        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                            child: Text(capitalizedMonth, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, fontFamily: 'Roboto')),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      buildArrowButton(
                                        onTap: () {
                                          setState(() {
                                            displayedDate = DateTime(displayedDate.year, displayedDate.month - 1);
                                          });
                                        },
                                        context: context,
                                        isHovered: isUpHovered,
                                        onHoverChanged: (value) => setState(() => isUpHovered = value),
                                        iconAsset: ChatifyVectors.arrowDropUp,
                                        isEnabled: canGoBack,
                                      ),
                                      const SizedBox(width: 8),
                                      buildArrowButton(
                                        onTap: () {
                                          setState(() {
                                            displayedDate = DateTime(displayedDate.year, displayedDate.month + 1);
                                          });
                                        },
                                        context: context,
                                        isHovered: isDownHovered,
                                        onHoverChanged: (value) => setState(() => isDownHovered = value),
                                        iconAsset: ChatifyVectors.arrowDropDown,
                                        isEnabled: canGoForward,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, thickness: 0, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                            SizedBox(height: 16),
                            calendarContent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  });

  overlay.insert(overlayEntry);
  animationController.forward();
}

Widget _buildDayView(BuildContext context, DateTime displayedDate, DateTime? hoveredDate, OverlayEntry overlayEntry) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((day) => Expanded(child: Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12))))).toList(),
        ),
      ),
      const SizedBox(height: 16),
      Column(
        children: List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: List.generate(7, (dayIndex) {
                int dayNumber = weekIndex * 7 + dayIndex + 1;
                bool isHoveredDay = hoveredDate != null && hoveredDate.year == displayedDate.year && hoveredDate.month == displayedDate.month && hoveredDate.day == dayNumber;
                
                return Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          onTap: () {
                            final selectedDate = DateTime(displayedDate.year, displayedDate.month, dayNumber);
                            overlayEntry.remove();
                          },
                          borderRadius: BorderRadius.circular(30),
                          splashColor: ChatifyColors.transparent,
                          highlightColor: context.isDarkMode ? ChatifyColors.popupColorDark.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
                          child: dayNumber <= 31
                            ? Container(
                            decoration: isHoveredDay ? BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1)) : null,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: dayNumber < 10 ? 15 : 12, vertical: 9),
                                    child: Text('$dayNumber', style: TextStyle(color: isHoveredDay ? colorsController.getColor(colorsController.selectedColorScheme.value) : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
                                  ),
                                  if (dayNumber == 1)
                                    Positioned(
                                      top: -1,
                                      child: Text(
                                        DateFormat.MMM('ru').format(DateTime(0, DateTime.now().month)).replaceAll('.', '').substring(0, 3),
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                            )
                            : SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    ],
  );
}

Widget _buildMonthView(void Function(int) onMonthSelected, int selectedMonth, BuildContext context) {
  final months = List.generate(12, (index) => DateFormat.MMM('ru').format(DateTime(0, index + 1)).replaceAll('.', '').substring(0, 3).toLowerCase());

  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: months.asMap().entries.map((entry) {
      final index = entry.key;
      final name = entry.value;
      return Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () => onMonthSelected(index + 1),
          borderRadius: BorderRadius.circular(30),
          splashColor: ChatifyColors.transparent,
          highlightColor: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
          child: Container(
            width: 64,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: index + 1 == selectedMonth ? ChatifyColors.grey : ChatifyColors.transparent),
            child: Text(name, style: TextStyle(fontSize: 14)),
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildYearView(DateTime selectedDate, void Function(DateTime) onYearSelected) {
  final currentYear = DateTime.now().year;
  final years = List.generate(12, (index) => currentYear - index);

  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: years.map((year) => GestureDetector(
      onTap: () => onYearSelected(DateTime(year, selectedDate.month)),
      child: Container(
        width: 64,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: year == selectedDate.year ? ChatifyColors.grey : ChatifyColors.transparent),
        child: Text('$year', style: TextStyle(fontSize: 14)),
      ),
    ))
    .toList(),
  );
}

Widget buildArrowButton({
  required BuildContext context,
  required VoidCallback onTap,
  required bool isHovered,
  required void Function(bool) onHoverChanged,
  required String iconAsset,
  required bool isEnabled,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 2),
    child: Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(6),
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isEnabled && isHovered ? (context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.2 * 255).toInt())) : ChatifyColors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SvgPicture.asset(iconAsset, width: 14, height: 14, color: isEnabled ? (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey) : ChatifyColors.grey.withAlpha(100)),
        ),
      ),
    ),
  );
}
