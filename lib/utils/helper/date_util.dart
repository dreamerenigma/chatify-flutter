import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/enums/date_format_type.dart';
import '../../generated/l10n/l10n.dart';

class DateUtil {
  /// -- Getting formatted time from milliSecondsSinceEpochs string.
  static String getFormattedTime({required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getFormattedTimeFromDateTime({required BuildContext context, required DateTime time}) {
    return TimeOfDay.fromDateTime(time).format(context);
  }

  /// -- Getting formatted time for sent & read.
  static String getMessageTime({required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
      ? '$formattedTime - ${sent.day} ${getMonth(sent, context)}'
      : '$formattedTime - ${sent.day} ${getMonth(sent, context)} ${sent.year}';
  }

  /// -- Get last message time (used in chat user card).
  static String getLastMessageTime({required BuildContext context, required DateTime time, bool showYear = false, DateFormatType formatType = DateFormatType.auto}) {
    final DateTime sent = time;
    final DateTime now = DateTime.now();

    final bool isToday = now.day == sent.day && now.month == sent.month && now.year == sent.year;

    if (formatType == DateFormatType.auto && isToday) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    switch (formatType) {
      case DateFormatType.numeric:
        return '${_twoDigits(sent.day)}.${_twoDigits(sent.month)}.${sent.year}';
      case DateFormatType.textual:
        return showYear ? '${sent.day} ${getMonth(sent, context)} ${sent.year}' : '${sent.day} ${getMonth(sent, context)}';
      case DateFormatType.auto:
      return showYear ? '${sent.day} ${getMonth(sent, context)} ${sent.year}' : '${sent.day} ${getMonth(sent, context)}';
    }
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// -- Get formatted creation date of the community.
  static String getCommunityCreationDate({required BuildContext context, required DateTime creationDate, bool includeTime = false}) {
    final DateTime now = DateTime.now();

    if (includeTime) {
      return DateFormat('dd.MM.yyyy').format(creationDate);
    }

    if (now.day == creationDate.day &&
        now.month == creationDate.month &&
        now.year == creationDate.year) {
      return TimeOfDay.fromDateTime(creationDate).format(context);
    }

    return now.year == creationDate.year ? '${creationDate.day} ${getMonth(creationDate, context)}' : '${creationDate.day} ${getMonth(creationDate, context)} ${creationDate.year} г.';
  }

  /// -- Converts a DateTime to a timestamp string.
  static String formatDateToTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch.toString();
  }

  /// -- Formats a timestamp string into a readable date format.
  static String formatTimestampToDate({required BuildContext context, required String timestamp}) {
    if (timestamp.isEmpty) {
      log('Timestamp string: $timestamp');
      return 'Invalid date';
    }

    try {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      final DateTime now = DateTime.now();

      if (now.day == date.day && now.month == date.month && now.year == date.year) {
        return TimeOfDay.fromDateTime(date).format(context);
      }

      return '${date.day} ${getMonth(date, context)} ${date.year}';
    } catch (e) {
      log('Error formatting timestamp: $e');
      return 'Invalid date';
    }
  }

  /// Parses and formats the group creation date.
  static String formatGroupCreationDate(String dateStr) {
    if (dateStr.isEmpty) {
      log('Empty date string provided');
      return 'No date provided';
    }

    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd.MM.yyyy').format(dateTime);
    } catch (e) {
      List<String> dateFormats = [
        'dd/MM/yyyy',
        'yyyy-MM-dd',
        'MM/dd/yyyy',
        'dd.MM.yyyy',
      ];

      for (var format in dateFormats) {
        try {
          DateTime creationDate = DateFormat(format).parse(dateStr);
          return DateFormat('dd.MM.yyyy').format(creationDate);
        } catch (e) {
          log('Failed to parse date $dateStr using format $format: $e');
        }
      }
    }

    log('Date parsing error: All formats failed for $dateStr');
    return 'Invalid date';
  }

  /// -- Formatted last active time of user in chat screen.
  static String getLastActiveTime({
    required BuildContext context,
    required Timestamp lastActive,
    bool hideLastSeenText = false,
    bool removeWasPrefix = false,
    bool addWasPrefix = false,
  }) {
    DateTime time = lastActive.toDate();
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    String todayPrefix = S.of(context).lastSeenToday;
    String yesterdayPrefix = S.of(context).lastSeenYesterday;
    String weekPrefix = S.of(context).lastSeenWeek;
    String prefixDate = S.of(context).prefixDate;

    if (removeWasPrefix) {
      prefixDate = prefixDate.replaceAll('был(-а)', '').trim();
      todayPrefix = todayPrefix.replaceAll('был(-а)', '').trim();
      yesterdayPrefix = yesterdayPrefix.replaceAll('был(-а)', '').trim();
      weekPrefix = weekPrefix.replaceAll('был(-а)', '').trim();
    }

    if (addWasPrefix && !prefixDate.contains('был(-а)')) {
      prefixDate = 'был(-а) $prefixDate';
      todayPrefix = 'был(-а) $todayPrefix';
      yesterdayPrefix = 'был(-а) $yesterdayPrefix';
      weekPrefix = 'был(-а) $weekPrefix';
    }

    if (time.year == now.year && time.month == now.month && time.day == now.day) {
      return '$todayPrefix $formattedTime';
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (time.year == yesterday.year && time.month == yesterday.month && time.day == yesterday.day) {
      return '$yesterdayPrefix $formattedTime';
    }

    if (time.year == now.year) {
      String dayOfWeek = getDayOfWeekAbbreviation(time.weekday);
      String month = getMonth(time, context);
      return '$weekPrefix $dayOfWeek ${time.day} $month ${S.of(context).lastSeenTime}$formattedTime';
    }

    String fullDate = '${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}.${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    return '$prefixDate $fullDate'.trim();
  }

  /// -- Returns a string with a date, depending on whether it is today.
  static String getDayLabel({required BuildContext context, required String timestamp}) {
    if (timestamp.isEmpty) {
      return 'Invalid date';
    }

    try {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      DateTime now = DateTime.now();

      Duration difference = now.difference(date);

      if (now.year == date.year && now.month == date.month && now.day == date.day) {
        return 'Сегодня';
      }

      DateTime yesterday = now.subtract(Duration(days: 1));
      if (yesterday.year == date.year && yesterday.month == date.month && yesterday.day == date.day) {
        return 'Вчера';
      }

      if (difference.inDays < 7) {
        return getDayOfWeekName(date.weekday);
      }

      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      log('Error formatting day label: $e');
      return 'Invalid date';
    }
  }

  /// -- Formats a date stamp derived from timestamp as capitalized.
  static String getFormattedDateLabel({required BuildContext context, required String timestamp}) {
    String dayLabel = getDayLabel(context: context, timestamp: timestamp);

    return '${dayLabel[0].toUpperCase()}${dayLabel.substring(1)}';
  }

  static String getFullFormattedDate({required BuildContext context, required String timestamp}) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      final locale = Localizations.localeOf(context).toLanguageTag();
      return DateFormat.yMMMMd(locale).format(date);
    } catch (e) {
      log('Error in getFullFormattedDate: $e');
      return 'Invalid date';
    }
  }

  static DateTime parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);

    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        try {
          final millis = int.parse(value);
          return DateTime.fromMillisecondsSinceEpoch(millis);
        } catch (_) {}
      }
    }

    log('Error parsing date: $value');
    return DateTime.now();
  }

  static String formatDateTime(DateTime dateTime) {
    if (dateTime == DateTime(0)) {
      return 'Дата не указана';
    }
    try {
      final formatted = DateFormat('dd.MM.yyyy').format(dateTime);
      return formatted;
    } catch (e) {
      return 'Неверная дата';
    }
  }

  /// -- Get the full name of the day of the week.
  static String getDayOfWeekName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'понедельник';
      case DateTime.tuesday:
        return 'вторник';
      case DateTime.wednesday:
        return 'среда';
      case DateTime.thursday:
        return 'четверг';
      case DateTime.friday:
        return 'пятница';
      case DateTime.saturday:
        return 'суббота';
      case DateTime.sunday:
        return 'воскресенье';
      default:
        return '';
    }
  }

  /// -- Get the abbreviated name of the day of the week.
  static String getDayOfWeekAbbreviation(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'пн.';
      case DateTime.tuesday:
        return 'вт.';
      case DateTime.wednesday:
        return 'ср.';
      case DateTime.thursday:
        return 'чт.';
      case DateTime.friday:
        return 'пт.';
      case DateTime.saturday:
        return 'сб.';
      case DateTime.sunday:
        return 'вс.';
      default:
        return '';
    }
  }

  /// -- Get month name from month no. or index.
  static String getMonth(DateTime date, BuildContext context) {
    switch (date.month) {
      case 1:
        return S.of(context).jan;
      case 2:
        return S.of(context).feb;
      case 3:
        return S.of(context).mar;
      case 4:
        return S.of(context).apr;
      case 5:
        return S.of(context).may;
      case 6:
        return S.of(context).jun;
      case 7:
        return S.of(context).jul;
      case 8:
        return S.of(context).aug;
      case 9:
        return S.of(context).sep;
      case 10:
        return S.of(context).oct;
      case 11:
        return S.of(context).nov;
      case 12:
        return S.of(context).dec;
    }
    return 'NA';
  }
}
