import 'package:android_intent_plus/android_intent.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/snack_bar_position_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import 'items/event_info_item.dart';
import 'items/event_participant_item.dart';

void showEventInfoBottomSheetDialog(BuildContext context, UserModel user, MessageModel message, {int participantsCount = 1}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ChatifyColors.transparent,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: false,
    builder: (sheetContext) {
      return SizedBox(
        height: MediaQuery.of(sheetContext).size.height - 30,
        child: EventInfoBottomSheetDialog(user: user, message: message, participantsCount: participantsCount),
      );
    },
  );
}

class EventInfoBottomSheetDialog extends StatefulWidget {
  final UserModel user;
  final MessageModel message;
  final int participantsCount;

  const EventInfoBottomSheetDialog({
    super.key,
    required this.user,
    required this.message,
    required this.participantsCount,
  });

  @override
  State<EventInfoBottomSheetDialog> createState() => EventInfoBottomSheetDialogState();
}

class EventInfoBottomSheetDialogState extends State<EventInfoBottomSheetDialog> {
  IconData _getCallTypeIcon(String callType) {
    switch (callType) {
      case 'audio':
        return Icons.call_outlined;
      case 'video':
        return Icons.videocam_outlined;
      default:
        return Icons.call_outlined;
    }
  }

  String _getParticipantsText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return '$count человек';
    }

    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return '$count человека';
    }

    return '$count человек';
  }

  Future<void> _copyLocation() async {
    final location = widget.message.event?.location ?? '';

    if (location.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: location));

    if (!mounted) return;

    CustomIconSnackBar.showAnimatedSnackBar(
      context,
      'Местоположение скопировано',
      icon: const Icon(BootstrapIcons.check_circle),
      iconColor: ChatifyColors.success,
      position: SnackBarPositionType.bottom,
      offset: 70,
    );
  }

  Future<void> _openCalendar() async {
    final event = widget.message.event;

    if (event == null) return;

    final DateTime start = event.startEvent.toDate();
    final intent = AndroidIntent(
      action: 'android.intent.action.INSERT',
      data: 'content://com.android.calendar/events',
      arguments: {
        'beginTime': start.millisecondsSinceEpoch,
        'endTime': start.add(const Duration(hours: 1)).millisecondsSinceEpoch,
        'title': event.name,
        'description': event.location,
        'eventLocation': event.location,
      },
    );

    await intent.launch();
  }

  Future<void> _copyLinkCallType() async {
    final link = widget.message.event?.callType ?? '';

    if (link.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: link));

    if (!mounted) return;

    CustomIconSnackBar.showAnimatedSnackBar(
      context,
      'Ссылка скопирована',
      icon: const Icon(BootstrapIcons.check_circle),
      iconColor: ChatifyColors.success,
      position: SnackBarPositionType.bottom,
      offset: 70,
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.message.event;

    if (event == null) {
      return const SizedBox.shrink();
    }

    final eventName = event.name;
    final location = event.location;
    final callTypeText = event.callType == 'video' ? 'Видеозвонок' : 'Аудиозвонок';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const SizedBox(width: 26),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Мероприятие',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 40,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close_rounded, size: 23, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Text(
              eventName,
              textAlign: TextAlign.left,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
            ),
          ),
          EventInfoItem(
            icon: Icons.calendar_month_outlined,
            title: Text(
              DateUtil.getEventDateTime(context: context, timestamp: widget.message.event!.startEvent),
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
            subtitle: Text('Добавить в календарь', style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
            onTap: _openCalendar,
          ),
          EventInfoItem(
            icon: Icons.location_on_outlined,
            title: Text(
              location.isEmpty ? 'Место не указано' : location,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
            subtitle: location.isEmpty ? null : Text('Копировать', style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
            subtitleColor: ChatifyColors.lightBlueLink,
            onSubtitleTap: location.isEmpty ? null : _copyLocation,
          ),
          EventInfoItem(
            icon: _getCallTypeIcon(event.callType),
            title: Text('$callTypeText Chatify', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            subtitle: location.isEmpty ? null : Text(
              'Копировать',
              style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
            subtitleColor: ChatifyColors.lightBlueLink,
            onSubtitleTap: _copyLinkCallType,
          ),
          EventInfoItem(
            icon: Icons.notifications_none_outlined,
            title: Text('Напоминание', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            subtitle: Text('За 1 час', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 8),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Пойдут', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                Text(
                  _getParticipantsText(widget.participantsCount),
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: EventParticipantItem(user: widget.user, event: widget.message.event!),
          ),
          const Spacer(),
          CustomBottomButton(text: 'Редактировать', onTap: () {}),
        ],
      ),
    );
  }
}
