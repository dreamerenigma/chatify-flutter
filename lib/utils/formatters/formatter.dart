import 'dart:math';
import 'package:intl/intl.dart';

class Formatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secondsRemaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondsRemaining.toString().padLeft(2, '0')}';
  }

  static String formatFileSize(double size) {
    if (size <= 0) return "0 B";

    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (log(size) / log(1024)).floor();
    double adjustedSize = size / pow(1024, i);
    String formattedSize = adjustedSize.round().toString();

    return '$formattedSize ${suffixes[i]}';
  }

  static String cleanFileSizeString(String fileSizeString) {
    return fileSizeString.replaceAll(RegExp(r'[^\d.]'), '');
  }

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String formatFullDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}:${formatDuration(duration)}';
    } else {
      return formatDuration(duration);
    }
  }

  static String formatDurationVideo(Duration? duration) {
    if (duration == null) return '0:00';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
