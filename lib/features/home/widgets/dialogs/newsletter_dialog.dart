import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/newsletter_chat_screen.dart';
import '../../screens/photo_newsletter_screen.dart';

class NewsletterDialog extends StatefulWidget {
  final String newsletterName;
  final String newsletterImage;
  final List<String> newsletters;
  final String createdAt;

  const NewsletterDialog({
    super.key,
    required this.newsletterName,
    required this.newsletterImage,
    required this.createdAt,
    required this.newsletters,
  });

  @override
  State<NewsletterDialog> createState() => _NewsletterDialogState();
}

class _NewsletterDialogState extends State<NewsletterDialog> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.size.width * .6,
        height: mq.size.height * .35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(PhotoNewsletterScreen(imageNewsletter: widget.newsletterImage, id: '', newsletters: widget.newsletters)));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.newsletterImage,
                        errorWidget: (context, url, error) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            child: const Icon(Ionicons.megaphone, color: ChatifyColors.white, size: 80),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ChatifyColors.black.withAlpha((0.7 * 255).toInt()),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: mq.size.width * .01, horizontal: mq.size.width * .05),
                      child: Text(
                        '${widget.newsletters.length} ${S.of(context).recipient}',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w500, color: ChatifyColors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
            const Divider(height: 1, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 35),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context, createPageRoute(NewsletterChatScreen(newsletters: widget.newsletters, createdAt: widget.createdAt)));
                      },
                      icon: Icon(Icons.message, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.info_outline, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 35),
              ],
            )
          ],
        ),
      ),
    );
  }
}

