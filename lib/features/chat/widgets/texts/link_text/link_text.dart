import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkText extends StatelessWidget {
  final String text;

  const LinkText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final RegExp urlRegExp = RegExp(
      r'(http|https):\/\/([\w.]+\/?)\S*',
      caseSensitive: false,
    );

    final List<TextSpan> spans = [];
    final List<RegExpMatch> matches = urlRegExp.allMatches(text).toList();
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.end)));
      }
      final String url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () {
          launchUrl(Uri.parse(url));
        },
      ));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black87, fontSize: ChatifySizes.fontSizeMd),
        children: spans,
      ),
    );
  }
}
