import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/chat/models/mention_data_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../platforms/platform_utils.dart';

final ValueNotifier<String> linkHoverNotifier = ValueNotifier('');

List<InlineSpan> parseMessageText(String text, BuildContext context, {List<MentionDataModel> mentions = const [], void Function(String userId)? onMentionTap}) {
  final mentionColor = ChatifyColors.lightBlueLink;

  final validMentions = mentions.where((mention) {
    return mention.userId.isNotEmpty && mention.start >= 0 && mention.end > mention.start && mention.end <= text.length && text.substring(mention.start, mention.end) == mention.text;
  }).toList()..sort((a, b) => a.start.compareTo(b.start));

  final spans = <InlineSpan>[];
  var position = 0;

  for (final mention in validMentions) {
    if (mention.start < position) continue;

    if (mention.start > position) {
      spans.addAll(_parseLinks(text.substring(position, mention.start), context));
    }

    spans.add(
      TextSpan(
        text: mention.text,
        style: TextStyle(color: mentionColor, decoration: TextDecoration.underline, decorationColor: mentionColor, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
        recognizer: TapGestureRecognizer()..onTap = () => onMentionTap?.call(mention.userId),
      ),
    );

    position = mention.end;
  }

  if (position < text.length) {
    spans.addAll(_parseLinks(text.substring(position), context));
  }

  if (validMentions.isEmpty && text.isEmpty) {
    return const [];
  }

  return spans;
}

List<InlineSpan> _parseLinks(String text, BuildContext context) {
  final urlRegex = RegExp(r'(https?://\S+)');
  final matches = urlRegex.allMatches(text);
  final spans = <InlineSpan>[];
  var lastEnd = 0;

  for (final match in matches) {
    if (match.start > lastEnd) {
      spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
    }

    final url = match.group(0)!;

    spans.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => linkHoverNotifier.value = url,
          onExit: (_) => linkHoverNotifier.value = '',
          child: ValueListenableBuilder<String>(
            valueListenable: linkHoverNotifier,
            builder: (context, hoveredUrl, _) {
              final isHovered = hoveredUrl == url;
              final isMobile = !isWebOrWindows;
              final linkColor = isMobile ? ChatifyColors.lightBlueLink : isHovered ? ChatifyColors.primaryDark : context.isDarkMode ? ChatifyColors.primaryCyan : ChatifyColors.black;

              return GestureDetector(
                onTap: () => launchUrl(Uri.parse(url)),
                child: Text(
                  url,
                  style: TextStyle(
                    fontSize: isWebOrWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd,
                    color: linkColor,
                    decoration: isMobile || isHovered ? TextDecoration.underline : TextDecoration.none,
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
    spans.add(TextSpan(text: text.substring(lastEnd), style: TextStyle(fontSize: isWebOrWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd)));
  }

  return spans;
}
