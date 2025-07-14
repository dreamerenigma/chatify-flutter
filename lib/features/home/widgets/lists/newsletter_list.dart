import 'package:chatify/features/newsletter/models/newsletter.dart';
import 'package:flutter/material.dart';
import '../cards/newsletter_card.dart';

class NewsletterList extends StatefulWidget {
  final List<NewsletterModel> newsletters;
  final Function(NewsletterModel) onNewsletterSelected;
  final NewsletterModel? selectedNewsletter;

  const NewsletterList({
    super.key,
    required this.newsletters,
    required this.onNewsletterSelected,
    this.selectedNewsletter,
  });

  @override
  State<NewsletterList> createState() => _NewsletterListState();
}

class _NewsletterListState extends State<NewsletterList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return widget.newsletters.isEmpty
      ? const SizedBox.shrink()
      : Column(
          children: widget.newsletters.map((newsletter) {
            final isSelected = widget.selectedNewsletter?.id == newsletter.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: NewsletterCard(
                newsletter: newsletter,
                newsletterName: newsletter.newsletterName,
                newsletterImage: newsletter.newsletterImage,
                createdAt: newsletter.createdAt,
                newsletters: newsletter.newsletters.map((id) => id).toList(),
                onNewsletterSelected: (_) {
                  widget.onNewsletterSelected(newsletter);
                },
                isSelected: isSelected,
              ),
            );
          }).toList(),
        );
  }
}
