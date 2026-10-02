import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../models/newsletter_model.dart';
import '../../../screens/newsletter_settings_screen.dart';

class NewsletterChatAppbar extends StatefulWidget {
  final NewsletterModel newsletter;
  final List<String> newsletters;

  const NewsletterChatAppbar({
    super.key,
    required this.newsletter,
    required this.newsletters,
  });

  @override
  State<NewsletterChatAppbar> createState() => _NewsletterChatAppbarState();
}

class _NewsletterChatAppbarState extends State<NewsletterChatAppbar> {
  late Future<Map<String, String>> userNamesFuture;

  @override
  void initState() {
    super.initState();
    userNamesFuture = APIs.fetchUserNames(widget.newsletters);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -5,
      elevation: 0,
      backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, size: 25),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: _buildNewsletterInfo(context),
      actions: [
        PopupMenuButton<int>(
          tooltip: S.of(context).more,
          position: PopupMenuPosition.under,
          offset: const Offset(-8, 0),
          menuPadding: const EdgeInsets.symmetric(vertical: 4),
          constraints: const BoxConstraints(minWidth: 0, maxWidth: 185),
          icon: const Icon(Icons.more_vert),
          color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
              }

              return ChatifyColors.transparent;
            }),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 1,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).mailingListData,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 2,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).mediaMailings,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 3,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).search,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 4,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).wallpaper,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 5,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).more,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewsletterInfo(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          Navigator.push(context, createPageRoute(NewsletterSettingsScreen(newsletter: widget.newsletter, newsletters: widget.newsletters)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ChatifyColors.grey,
                child: SvgPicture.asset(
                  ChatifyVectors.newsletter,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.newsletters.length} ${S.of(context).recipient}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    ),
                    FutureBuilder<Map<String, String>>(
                      future: userNamesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(S.of(context).loading, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400));
                        }

                        if (snapshot.hasError) {
                          return Text(S.of(context).errorLoadingNames, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400));
                        }

                        if (snapshot.hasData) {
                          final userNames = snapshot.data!;
                          final newsletterNames = widget.newsletters.map((id) {
                            final fullName = userNames[id] ?? S.of(context).unknownUser;

                            return fullName.trim().split(RegExp(r'\s+')).first;
                          }).join(', ');

                          return Text(newsletterNames, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400));
                        }

                        return Text(S.of(context).noMembers, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
