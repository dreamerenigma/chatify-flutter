import 'package:chatify/features/newsletter/models/newsletter_model.dart';
import 'package:flutter/material.dart';
import '../cards/newsletter_card.dart';

class NewsletterList extends StatelessWidget {
  final List<NewsletterModel> newsletters;
  final ValueChanged<NewsletterModel>? onNewsletterSelected;
  final bool isSelectionMode;
  final Set<String> selectedNewsletterIds;

  const NewsletterList({
    super.key,
    required this.newsletters,
    this.onNewsletterSelected,
    this.isSelectionMode = false,
    this.selectedNewsletterIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (newsletters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: newsletters.map((newsletter) {
        final isSelected = selectedNewsletterIds.contains(newsletter.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: NewsletterCard(
            newsletter: newsletter,
            isSelectionMode: isSelectionMode,
            isSelected: isSelected,
            onNewsletterSelected: (_) {
              onNewsletterSelected?.call(newsletter);
            },
          ),
        );
      }).toList(),
    );
  }
}
