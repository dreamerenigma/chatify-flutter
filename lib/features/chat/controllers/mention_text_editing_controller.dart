import '../../../utils/constants/app_colors.dart';
import '../models/mention_data_model.dart';
import 'package:flutter/material.dart';

class MentionTextEditingController extends TextEditingController {
  List<MentionDataModel> mentions = [];

  MentionTextEditingController({
    super.text,
  });

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    if (text.isEmpty || mentions.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final spans = <TextSpan>[];
    int currentPosition = 0;

    final sortedMentions = [...mentions]..sort((a, b) => a.start.compareTo(b.start));

    for (final mention in sortedMentions) {
      if (mention.start < 0 || mention.end > text.length || mention.start >= mention.end) {
        continue;
      }

      if (mention.start > currentPosition) {
        spans.add(TextSpan(text: text.substring(currentPosition, mention.start), style: style));
      }

      spans.add(
        TextSpan(
          text: text.substring(mention.start, mention.end),
          style: style?.copyWith(color: ChatifyColors.lightBlueLink, decoration: TextDecoration.underline, decorationColor: ChatifyColors.lightBlueLink, decorationThickness: 1.5),
        ),
      );

      currentPosition = mention.end;
    }

    if (currentPosition < text.length) {
      spans.add(TextSpan(text: text.substring(currentPosition), style: style));
    }

    return TextSpan(style: style, children: spans);
  }
}
