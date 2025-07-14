import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/buttons/custom_search_button.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/dialogs/chat_settings_dialog.dart';
import '../../models/newsletter.dart';

class NewsletterAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserModel user;
  final NewsletterModel newsletter;
  final List<String> newsletters;

  const NewsletterAppBar({
    super.key,
    required this.newsletter,
    required this.newsletters,
    required this.user,
  });

  @override
  State<NewsletterAppBar> createState() => NewsletterAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight);
}

class NewsletterAppBarState extends State<NewsletterAppBar> with SingleTickerProviderStateMixin {
  List<NewsletterModel> _newsletters = [];
  bool _isLoading = true;
  late Future<Map<String, String>> userNamesFuture;
  late AnimationController _searchController;
  late Animation<double> _searchScaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadNewsletters();
    userNamesFuture = APIs.fetchUserNames(widget.newsletters, shortenNames: true);
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(parent: _searchController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadNewsletters() async {
    try {
      final data = await APIs.getNewsletter();
      setState(() {
        _newsletters = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('Error loading newsletters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppBar(backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey);
    }

    NewsletterModel community = _newsletters.isNotEmpty
      ? _newsletters[0]
      : NewsletterModel(id: '', newsletterName: 'No Newsletter', newsletterImage: '', createdAt: '', creatorName: '', newsletters: []);

    return _buildAppBar(context, community);
  }

  Widget _buildAppBar(BuildContext context, NewsletterModel newsletter) {
    return Stack(
      children: [
        _buildNewsletterAppBar(context, newsletter),
      ],
    );
  }

  Widget _buildNewsletterAppBar(BuildContext context, NewsletterModel newsletter) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey))),
      child: AppBar(
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: 0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Row(
            children: [
              _buildNewsletterInfo(context, newsletter),
            ],
          ),
        ),
        actions: [
          CustomSearchButton(
            searchController: _searchController,
            searchScaleAnimation: _searchScaleAnimation,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNewsletterInfo(BuildContext context, NewsletterModel newsletter) {
    double imageSize = Platform.isWindows ? 40.0 : 35.0;

    return InkWell(
      onTap: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        showChatSettingsDialog(context, widget.user, position, initialIndex: 0);
      },
      mouseCursor: SystemMouseCursors.basic,
      borderRadius: BorderRadius.circular(8),
      splashColor: ChatifyColors.transparent,
      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .04),
              child: CachedNetworkImage(
                width: imageSize,
                height: imageSize,
                imageUrl: newsletter.newsletterImage,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey);
                },
                errorWidget: (context, url, error) {
                  return CircleAvatar(
                    backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    foregroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    child: Icon(Ionicons.megaphone, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                  );
                },
              ),
            ),
            SizedBox(width: Platform.isWindows ? 14 : 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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

                      return Text(
                        newsletterNames,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd,
                          fontFamily: 'Roboto',
                          fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400,
                        ),
                      );
                    } else {
                      return Text(S.of(context).noMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: ChatifyColors.white));
                    }
                  },
                ),
                SizedBox(height: 4),
                Text(
                  'Рассылки',
                  style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, color: ChatifyColors.grey, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
