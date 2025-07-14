import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

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
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
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
              return GestureDetector(
                onTap: () => launchUrl(Uri.parse(url)),
                child: Text(
                  url,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto',
                    color: isHovered ? ChatifyColors.primaryDark : (context.isDarkMode ? ChatifyColors.primaryCyan : ChatifyColors.black),
                    decoration: isHovered ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: isHovered ? ChatifyColors.primary : (context.isDarkMode ? ChatifyColors.blue : ChatifyColors.black),
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
      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
    ));
  }

  return spans;
}
