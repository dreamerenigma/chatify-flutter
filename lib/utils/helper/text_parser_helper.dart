import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../platforms/platform_utils.dart';

final ValueNotifier<String> linkHoverNotifier = ValueNotifier('');

List<InlineSpan> parseMessageText(String text, BuildContext context) {
  final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');
  final matches = urlRegex.allMatches(text);
  List<InlineSpan> spans = [];
  int lastEnd = 0;

  for (final match in matches) {
    if (match.start > lastEnd) {
      spans.add(TextSpan(
        text: text.substring(lastEnd, match.start),
        style: TextStyle(fontSize: isWebOrWindows ? 15 : ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
      ));
    }

    final url = match.group(0)!;

    spans.add(
      WidgetSpan(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => linkHoverNotifier.value = url,
          onExit: (_) => linkHoverNotifier.value = '',
          child: ValueListenableBuilder(
            valueListenable: linkHoverNotifier,
            builder: (context, hoveredUrl, _) {
              final isHovered = hoveredUrl == url;
              final isMobile = !isWebOrWindows;
              final linkColor = isMobile ? ChatifyColors.lightBlueLink : (isHovered ? ChatifyColors.primaryDark : (context.isDarkMode ? ChatifyColors.primaryCyan : ChatifyColors.black));
              final underline = isMobile || isHovered;

              return GestureDetector(
                onTap: () => launchUrl(Uri.parse(url)),
                child: Text(
                  url,
                  style: TextStyle(
                    fontSize: isWebOrWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto',
                    color: linkColor,
                    decoration: underline ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: linkColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    lastEnd = match.end;
  }

  if (lastEnd < text.length) {
    spans.add(TextSpan(
      text: text.substring(lastEnd),
      style: TextStyle(fontSize: isWebOrWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, fontWeight: isWebOrWindows ? FontWeight.w300 : FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
    ));
  }

  return spans;
}
