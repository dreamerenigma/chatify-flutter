import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../models/message_model.dart';
import '../cards/message_card.dart';
import '../dialogs/calendar_dialog.dart';

class MessageListView extends StatefulWidget {
  final List<MessageModel> messages;
  final bool isHovered;
  final bool isInside;
  final ScrollController scrollController;
  final Set<int> selectedMessages;
  final VoidCallback startSelection;
  final void Function(int) toggleMessageSelection;

  const MessageListView({
    super.key,
    required this.messages,
    required this.isHovered,
    required this.isInside,
    required this.scrollController,
    required this.selectedMessages,
    required this.startSelection,
    required this.toggleMessageSelection,
  });

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  bool isInside = false;
  bool isHovered = false;
  List<bool> isHoveredList = [];
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    String lastDisplayedDay = '';
    final baseColor = context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey;
    final hoverColor = context.isDarkMode ? ChatifyColors.softNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.9 * 255).toInt());

    return CustomScrollbar(
      scrollController: widget.scrollController,
      isInsidePersonalizedOption: widget.isInside,
      onHoverChange: (bool isHovered) {
        setState(() {
          isInside = isHovered;
        });
      },
      child: ListView.builder(
        reverse: true,
        itemCount: widget.messages.length,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final currentMessage = widget.messages[index];
          final prevMessage = index > 0 ? widget.messages[index - 1] : null;
          final currentDate = DateTime.fromMillisecondsSinceEpoch(int.parse(currentMessage.sent));
          final prevDate = prevMessage != null ? DateTime.fromMillisecondsSinceEpoch(int.parse(prevMessage.sent)) : null;
          final isNewDay = prevMessage == null || !isSameDay(currentDate, prevDate!);
          final showDay = isNewDay && lastDisplayedDay != currentDate.toIso8601String();

          if (showDay) lastDisplayedDay = currentDate.toIso8601String();

          bool isDifferentMessageType = prevMessage != null && currentMessage.fromId != prevMessage.fromId;

          if (isHoveredList.length <= index) {
            isHoveredList.add(false);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showDay)
              CustomTooltip(
                message: DateUtil.getFullFormattedDate(context: context, timestamp: currentDate.millisecondsSinceEpoch.toString()),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHoveredList[index] = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHoveredList[index] = false;
                    });
                  },
                  child: Builder(
                    builder: (innerContext) {
                      return InkWell(
                        onTap: () {
                          final RenderBox renderBox = innerContext.findRenderObject() as RenderBox;
                          final position = renderBox.localToGlobal(Offset.zero);
                          showCalendarDialog(context, position, currentDate, hoveredDate: currentDate);
                        },
                        mouseCursor: SystemMouseCursors.basic,
                        borderRadius: BorderRadius.circular(20),
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(color: isHoveredList[index] ? hoverColor : baseColor.withAlpha((0.7 * 255).toInt()), borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            DateUtil.getDayLabel(context: context, timestamp: currentDate.millisecondsSinceEpoch.toString()),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: isDifferentMessageType ? 8 : 0),
                child: MessageCard(
                  message: currentMessage,
                  isSelected: widget.selectedMessages.contains(index),
                  onLongPress: () {
                    if (!Platform.isWindows) {
                      widget.startSelection();
                      widget.toggleMessageSelection(index);
                    }
                  },
                  onTap: () => widget.toggleMessageSelection(index), messages: widget.messages,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
