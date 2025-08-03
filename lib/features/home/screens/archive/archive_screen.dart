import 'dart:developer';
import 'package:chatify/features/home/screens/archive/settings_archive_screen.dart';
import 'package:chatify/features/home/widgets/lists/archive_list.dart';
import 'package:chatify/features/personalization/screens/chats/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/infos/private_messages_protected_notice.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  late UserModel user;
  List<UserModel> archivedUsers = [];
  List<UserModel> searchList = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    user = APIs.me;
    loadArchivedUsers();
  }

  Future<void> loadArchivedUsers() async {
    archivedUsers = await APIs.getArchivedUsers(user.id);
    setState(() {});
  }

  void onUserSelected(UserModel selectedUser) {
    log('Selected user: ${selectedUser.name}');
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text(S.of(context).inArchive, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              PopupMenuButton<int>(
                color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey,
                position: PopupMenuPosition.under,
                offset: const Offset(0, 10),
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(context, createPageRoute(SettingsArchiveScreen()));
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.all(16),
                    child: Text(S.of(context).settingsArchive, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ),
                ],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ],
          ),
        ),
      ),
      body: ScrollConfiguration(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, createPageRoute(ChatsScreen()));
                        },
                        child: Text(S.of(context).chatsUnarchivedNewMessagesReceived, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm), textAlign: TextAlign.center)),
                      Divider(height: 16, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                      ArchiveList(isSearching: isSearching, searchList: searchList, archivedUsers: archivedUsers, onUserSelected: onUserSelected, user: user),
                      Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                      PrivateMessagesProtectedNotice(),
                    ],
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
