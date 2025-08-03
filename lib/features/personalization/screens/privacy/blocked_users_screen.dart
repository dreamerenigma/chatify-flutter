import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../calls/screens/select_contact_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../models/blocked_user.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/lists/blocked_list.dart';

class BlockedUsersScreen extends StatefulWidget {
  final List<BlockedUser> blockedUser;
  final UserModel user;

  const BlockedUsersScreen({super.key, required this.blockedUser, required this.user});

  @override
  State<BlockedUsersScreen> createState() => BlockedUsersScreenState();
}

class BlockedUsersScreenState extends State<BlockedUsersScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isBlockedListEmpty = widget.blockedUser.isEmpty;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(S.of(context).blocked, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_alt),
                onPressed: () {
                  Navigator.push(context, createPageRoute(SelectContactScreen(user: widget.user)));
                },
              ),
            ],
          ),
        ),
      ),
      body: isBlockedListEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  SizedBox(
                    width: 105,
                    height: 105,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          child: Center(child: SvgPicture.asset(ChatifyVectors.user, width: 65, height: 65)),
                        ),
                        Positioned(
                          left: 5,
                          bottom: 12,
                          child: SvgPicture.asset(ChatifyVectors.blocked, width: 34, height: 34),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(S.of(context).noBlockedContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: S.of(context).clickOnIcon, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                          const WidgetSpan(child: Icon(Icons.person_add_alt, size: 18), alignment: PlaceholderAlignment.middle),
                          TextSpan(text: S.of(context).selectContactYouBlock, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      S.of(context).blockedContactsLongerCallMessage,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                    ),
                  ),
                ],
              ),
            ),
          )
        : ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ScrollbarTheme(
              data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
              child: Scrollbar(
                thickness: 4,
                thumbVisibility: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(S.of(context).contacts, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, color: ChatifyColors.darkGrey)),
                      ),
                      BlockedUserList(blockedUser: widget.blockedUser, user: widget.user),
                      Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Text(S.of(context).blockedContactsLongerCallMessage, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
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
