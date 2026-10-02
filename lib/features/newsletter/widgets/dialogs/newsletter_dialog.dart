import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../newsletter/models/newsletter_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../newsletter/screens/newsletter_chat_screen.dart';
import '../../../newsletter/screens/photo_newsletter_screen.dart';
import '../../screens/newsletter_settings_screen.dart';

class NewsletterInfoDialog extends StatefulWidget {
  final NewsletterModel newsletter;
  final List<String> newsletters;

  const NewsletterInfoDialog({
    super.key,
    required this.newsletter,
    required this.newsletters,
  });

  @override
  State<NewsletterInfoDialog> createState() => _NewsletterInfoDialogState();
}

class _NewsletterInfoDialogState extends State<NewsletterInfoDialog> {
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
                      Navigator.push(context, createPageRoute(PhotoNewsletterScreen(imageNewsletter: widget.newsletter.newsletterImage, id: widget.newsletter.id, newsletters: widget.newsletters)));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.newsletter.newsletterImage,
                        errorWidget: (context, url, error) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                            child: Padding(
                              padding: const EdgeInsets.all(50),
                              child: SvgPicture.asset(ChatifyVectors.newsletter, width: double.infinity, height: double.infinity, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, BlendMode.srcIn)),
                            ),
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
                        color: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 35),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(NewsletterChatScreen(newsletters: widget.newsletters, createdAt: widget.newsletter.createdAt, newsletter: widget.newsletter)));
                      },
                      icon: SvgPicture.asset(ChatifyVectors.messageOutline, width: 30, height: 30, colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn)),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(NewsletterSettingsScreen(newsletter: widget.newsletter, newsletters: widget.newsletters)));
                      },
                      icon: Icon(Icons.info_outline_rounded, size: 27, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
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
