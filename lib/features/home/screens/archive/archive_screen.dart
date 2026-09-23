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
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/app_bars/selection_app_bar.dart';
import '../../widgets/dialogs/no_sound_dialog.dart';
import '../../widgets/infos/private_messages_protected_notice.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final Set<String> selectedChats = <String>{};
  final Set<String> mutedChats = <String>{};
  late UserModel user;
  List<UserModel> archivedUsers = [];
  List<UserModel> searchList = [];
  bool isSearching = false;

  bool get isSelecting => selectedChats.isNotEmpty;

  @override
  void initState() {
    super.initState();
    user = APIs.me;
  }

  void onUserSelected(UserModel selectedUser) {
    setState(() {
      if (selectedChats.contains(selectedUser.id)) {
        selectedChats.remove(selectedUser.id);
      } else {
        selectedChats.add(selectedUser.id);
      }
    });
  }

  void clearSelection() {
    setState(() {
      selectedChats.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMuted = selectedChats.isNotEmpty && selectedChats.every((id) => mutedChats.contains(id));

    return Scaffold(
      appBar: isSelecting
        ? SelectionAppBar(
            selectedChatsCount: selectedChats.length,
            onClearSelection: clearSelection,
            onDelete: () {},
            onMute: () async {
              if (selectedChats.isEmpty) return;

              if (isMuted) {
                try {
                  for (final userId in selectedChats) {
                    await APIs.setChatMuted(userId: userId, muted: false);
                  }

                  clearSelection();
                } catch (e) {
                  log('Error unmuting chats: $e');
                }

                return;
              }

              final initialDuration = await APIs.getChatMutedDuration(selectedChats.first);

              if (!context.mounted) return;

              showNoSoundDialog(
                context,
                initialDuration,
                (duration) async {
                  try {
                    for (final userId in selectedChats) {
                      await APIs.setChatMuted(userId: userId, muted: true, duration: duration);
                    }

                    clearSelection();
                  } catch (e) {
                    log('Error muting chats: $e');
                  }
                },
              );
            },
            onArchive: () async {
              try {
                for (final userId in selectedChats) {
                  await APIs.setChatArchived(userId: userId, archived: false);
                }

                clearSelection();

                if (mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                log('Error unarchiving chats: $e');
              }
            },
            isArchiveMode: true,
          )
        : PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                color: ChatifyColors.white,
                boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
              ),
              child: AppBar(
                title: Text(S.of(context).inArchive, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                titleSpacing: 10,
                backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, size: 25),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  TooltipTheme(
                    data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                      child: PopupMenuButton<int>(
                        tooltip: S.of(context).more,
                        position: PopupMenuPosition.under,
                        offset: const Offset(-8, 0),
                        menuPadding: EdgeInsets.symmetric(vertical: 4),
                        constraints: const BoxConstraints(minWidth: 0, maxWidth: 215),
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
                          PopupMenuItem(
                            value: 1,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AppPopupMenuItem(
                              text: 'Настройки архивации',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, createPageRoute(SettingsArchiveScreen()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, createPageRoute(ChatsScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Text(S.of(context).chatsUnarchivedNewMessagesReceived, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: 13, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                        )),
                      Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                      ArchiveList(isSearching: isSearching, searchList: searchList, archivedUsers: archivedUsers, selectedUserIds: selectedChats, onUserSelected: onUserSelected, user: user),
                      Divider(height: 16, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
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
