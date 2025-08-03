import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../screens/newsletter_settings_screen.dart';

class NewsletterAppbar extends StatefulWidget {
  final List<String> newsletters;

  const NewsletterAppbar({super.key, required this.newsletters});

  @override
  State<NewsletterAppbar> createState() => _NewsletterAppbarState();
}

class _NewsletterAppbarState extends State<NewsletterAppbar> {
  late Future<Map<String, String>> userNamesFuture;

  @override
  void initState() {
    super.initState();
    userNamesFuture = APIs.fetchUserNames(widget.newsletters);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: DeviceUtils.getScreenHeight(context) * .04),
      child: _buildUserRow(context),
    );
  }

  Widget _buildUserRow(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              child: Row(
                children: [
                  CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Ionicons.megaphone, color: ChatifyColors.white, size: 20)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(const NewsletterSettingsScreen()));
              },
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.newsletters.length} ${S.of(context).recipient}', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                    FutureBuilder<Map<String, String>>(
                      future: userNamesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(S.of(context).loading, style: TextStyle(fontSize: ChatifySizes.fontSizeLm));
                        } else if (snapshot.hasError) {
                          return Text(S.of(context).errorLoadingNames, style: TextStyle(fontSize: ChatifySizes.fontSizeLm),
                          );
                        }  else if (snapshot.hasData) {
                          final userNames = snapshot.data!;
                          final newsletterNames = widget.newsletters.map((id) => userNames[id] ?? S.of(context).unknownUser).join(', ');
                          return Text(newsletterNames, style: TextStyle(fontSize: ChatifySizes.fontSizeLm));
                        } else {
                          return Text(S.of(context).noMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeLm));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            PopupMenuButton<int>(
              position: PopupMenuPosition.under,
              color: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.white,
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 1) {

                } else if (value == 2) {

                } else if (value == 3) {

                } else if (value == 4) {

                } else if (value == 5) {

                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  padding: const EdgeInsets.all(16),
                  child: Text(S.of(context).mailingListData, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
                PopupMenuItem(
                  value: 2,
                  padding: const EdgeInsets.all(16),
                  child: Text(S.of(context).mediaMailings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
                PopupMenuItem(
                  value: 3,
                  padding: const EdgeInsets.all(16),
                  child: Text(S.of(context).search, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
                PopupMenuItem(
                  value: 4,
                  padding: const EdgeInsets.all(16),
                  child: Text(S.of(context).wallpaper, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
                PopupMenuItem(
                  value: 5,
                  padding: const EdgeInsets.all(16),
                  child: Text(S.of(context).more, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ),
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ],
        ),
      ],
    );
  }
}
