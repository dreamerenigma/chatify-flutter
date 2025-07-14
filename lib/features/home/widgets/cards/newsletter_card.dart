import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/newsletter/models/newsletter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/newsletter_chat_screen.dart';
import '../dialogs/edit_settings_chat_dialog.dart';
import '../dialogs/newsletter_dialog.dart';

class NewsletterCard extends StatefulWidget {
  final NewsletterModel newsletter;
  final String newsletterName;
  final List<String> newsletters;
  final String newsletterImage;
  final String createdAt;
  final ValueChanged<NewsletterModel> onNewsletterSelected;
  final bool isSelected;

  const NewsletterCard({
    super.key,
    required this.newsletter,
    required this.newsletterName,
    required this.newsletterImage,
    required this.createdAt,
    required this.newsletters,
    required this.onNewsletterSelected,
    required this.isSelected,
  });

  @override
  State<NewsletterCard> createState() => _NewsletterCardState();
}

class _NewsletterCardState extends State<NewsletterCard> {
  late Future<Map<String, String>> userNamesFuture;
  bool isSelected = false;
  bool isLongPressed = false;

  String get formattedDate {
    if (widget.createdAt.isEmpty) {
      return S.of(context).dateNotSpecified;
    }
    try {
      final timestamp = int.tryParse(widget.createdAt);
      if (timestamp == null) {
        log('Invalid timestamp format');
        return S.of(context).invalidDate;
      }
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formatted = DateFormat('dd.MM.yyyy').format(date);
      return formatted;
    } catch (e) {
      return S.of(context).invalidDate;
    }
  }

  @override
  void initState() {
    super.initState();
    userNamesFuture = APIs.fetchUserNames(widget.newsletters, shortenNames: true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: Platform.isWindows ? 16 : 8, right: Platform.isWindows ? 15 : 8),
      elevation: Platform.isWindows ? widget.isSelected ? 2 : 0.5 : widget.isSelected ? 2 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: GestureDetector(
        onSecondaryTapDown: (details) {
          if (Platform.isWindows) {
            Future.delayed(Duration(milliseconds: 100), () {
              showEditSettingsChatDialog(context, details.globalPosition);
            });
          }
        },
        onLongPress: () {
          if (Platform.isWindows) {
            setState(() {
              isLongPressed = true;
            });
          } else {
            widget.onNewsletterSelected(widget.newsletter);
          }
        },
        onLongPressUp: () {
          if (Platform.isWindows) {
            setState(() {
              isLongPressed = false;
            });
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Platform.isWindows
              ? isLongPressed || widget.isSelected
                ? context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground
              : widget.isSelected
                ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground,
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (Platform.isWindows) {
                widget.onNewsletterSelected(widget.newsletter);
              } else {
                Navigator.push(context, createPageRoute(NewsletterChatScreen(newsletters: widget.newsletters, createdAt: widget.createdAt)));
              }
            },
            splashFactory: NoSplash.splashFactory,
            splashColor: ChatifyColors.transparent,
            highlightColor: ChatifyColors.transparent,
            hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => NewsletterDialog(
                              newsletterName: widget.newsletterName,
                              newsletterImage: widget.newsletterImage,
                              createdAt: widget.createdAt,
                              newsletters: widget.newsletters,
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.newsletterImage,
                          width: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                          height: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                          imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                          placeholder: (context, url) => CircleAvatar(
                            backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            child: Icon(Ionicons.megaphone, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                          ),
                        ),
                      ),
                      if (!Platform.isWindows && isSelected)
                      Positioned(
                        bottom: -3,
                        right: -2,
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.check, color: ChatifyColors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<Map<String, String>>(
                              future: userNamesFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text(
                                    S.of(context).loading,
                                    style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    S.of(context).errorLoadingNames,
                                    style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                                  );
                                }  else if (snapshot.hasData) {
                                  final userNames = snapshot.data!;
                                  final newsletterNames = widget.newsletters.map((id) => userNames[id] ?? S.of(context).unknownUser).join(', ');
                                  
                                  return Expanded(
                                    child: Text(
                                      newsletterNames,
                                      style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, fontFamily: 'Helvetica', fontWeight: Platform.isWindows ? FontWeight.w400 : FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                } else {
                                  return Text(S.of(context).noMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: ChatifyColors.white));
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            Center(
                              child: Text(
                                formattedDate.isNotEmpty ? formattedDate : S.of(context).invalidDate,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: Platform.isWindows ? context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${S.of(context).youCreatedMailingList} ${widget.newsletters.length} ${S.of(context).recipients}',
                          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
