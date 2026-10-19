import 'dart:developer';
import 'package:chatify/features/personalization/screens/media/media_links_documents_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../api/apis.dart';
import '../../../../../api/chat_api.dart';
import '../../../../../core/enums/chat_target_type.dart';
import '../../../../../core/enums/snack_bar_position_type.dart';
import '../../../../../core/services/chats/chat_export_service.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../../chat/models/chat_theme_target.dart';
import '../../../../personalization/screens/chats/theme_chat_screen.dart';
import '../../../../personalization/widgets/dialogs/add_list_bottom_sheet_dialog.dart';
import '../../../../personalization/widgets/dialogs/chat_export_dialog.dart';
import '../../../../personalization/widgets/dialogs/clear_chat_bottom_sheet_dialog.dart';
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
  String? imagePath;

  @override
  void initState() {
    super.initState();
    userNamesFuture = APIs.fetchUserNames(widget.newsletters);
  }

  Future<void> _exportChat({required bool exportMedia}) async {
    try {
      final conversationId = ChatApi.getConversationId(widget.newsletter.id);
      final file = await ChatExportService.exportChat(conversationId: conversationId, username: widget.newsletter.newsletterName, exportMedia: exportMedia);

      if (!mounted) return;

      final contactName = widget.newsletter.newsletterName.trim();
      final archiveName = 'Чат Chatify с контактом $contactName';

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)],
        subject: archiveName,
        text: 'История чатов прикреплена к данному письму ''в виде файла "$archiveName.zip".'),
      );
    } catch (e, stackTrace) {
      log('[ChatExport] Ошибка: $e');
      log('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не удалось экспортировать чат: $e')));
    }
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
          constraints: const BoxConstraints(minWidth: 0, maxWidth: 190),
          icon: const Icon(Icons.more_vert_rounded, size: 25),
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
          onSelected: (value) {
            if (value == 6) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  _showMorePopupMenu(context);
                }
              });
              return;
            }

            _handleNewsletterMenuAction(value);
          },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 1,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).mailingListData,
                onTap: () {
                  Navigator.pop(context, 1);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 2,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).mediaMailings,
                onTap: () {
                  Navigator.pop(context, 2);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 3,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: S.of(context).search,
                onTap: () {
                  Navigator.pop(context, 3);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 4,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: 'Тема чата',
                onTap: () {
                  Navigator.pop(context, 4);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 5,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AppPopupMenuItem(
                text: 'Добавить в список',
                onTap: () {
                  Navigator.pop(context, 5);
                },
              ),
            ),
            PopupMenuItem<int>(
              value: 6,
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    borderRadius: BorderRadius.circular(8),
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    onTap: () {
                      Navigator.pop(context, 6);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 6, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(child: Text(S.of(context).more, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                          Icon(Icons.arrow_right, size: 28, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMorePopupMenu(BuildContext context) {
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 255, kToolbarHeight + 25, 8, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      constraints: const BoxConstraints(minWidth: 255, maxWidth: 255),
      menuPadding: const EdgeInsets.symmetric(vertical: 4),
      color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
      items: [
        PopupMenuItem<int>(
          value: 7,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Очистить чат',
            onTap: () {
              Navigator.pop(context, 7);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 8,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Экспорт чата',
            onTap: () {
              Navigator.pop(context, 8);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 9,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            text: 'Добавить иконку на экран',
            onTap: () {
              Navigator.pop(context, 9);
            },
          ),
        ),
      ],
    ).then((value) {
      if (value == null || !mounted) return;

      _handleNewsletterMenuAction(value);
    });
  }

  void _handleNewsletterMenuAction(int value) async {
    final wallpaperKey = ChatApi.getConversationId(widget.newsletter.id);

    switch (value) {
      case 1:
        Navigator.push(context, createPageRoute(NewsletterSettingsScreen(newsletter: widget.newsletter, newsletters: widget.newsletters)));
        break;
      case 2:
        Navigator.push(context, createPageRoute(MediaLinksDocumentsScreen(userId: widget.newsletter.id)));
        break;
      case 3:
        break;
      case 4:
        Navigator.of(context).push(createPageRoute(ThemeChatScreen(imagePath: imagePath, target: ChatThemeTarget(id: widget.newsletter.id, type: ChatTargetType.newsletter), wallpaperKey: wallpaperKey)));
        break;
      case 5:
        showAddListBottomSheetDialog(context);
        break;
      case 6:
        break;
      case 7:
        final conversationId =
        ChatApi.getConversationId(widget.newsletter.id);

        final messagesSnapshot = await FirebaseFirestore.instance
            .collection('Newsletters')
            .doc(conversationId)
            .collection('messages')
            .limit(1)
            .get();

        if (!context.mounted) return;

        if (messagesSnapshot.docs.isEmpty) {
          CustomIconSnackBar.showAnimatedSnackBar(
            context,
            'Нет сообщений',
            icon: const Icon(
              Icons.warning_amber_rounded,
              size: 26,
            ),
            iconColor: ChatifyColors.yellow,
            position: SnackBarPositionType.bottom,
            offset: 20,
          );
          break;
        }

        showClearChatBottomSheetDialog(context);
        break;
      case 8:
        final exportMedia = await showChatExportDialog(context);

        if (exportMedia == null || !mounted) break;

        await _exportChat(exportMedia: exportMedia);
        break;
      case 9:
        break;
    }
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
