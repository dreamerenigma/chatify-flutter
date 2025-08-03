import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/badges/creation_date_badge.dart';
import '../../../../common/widgets/cards/encryption_notice_card.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../chat/models/message_model.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/dialogs/calendar_dialog.dart';
import '../../../chat/widgets/dialogs/items/menu_item.dart';
import '../../../chat/widgets/dialogs/select_message_dialog.dart';
import '../../../chat/widgets/input/bottom_input.dart';
import '../../../home/controllers/overlay_color_controller.dart';
import '../../../personalization/widgets/dialogs/attach_files_dialog.dart';
import '../../../personalization/widgets/dialogs/emoji_stickers_dialog.dart';
import '../../models/community_model.dart';
import '../bars/community_app_bar.dart';
import '../dialogs/overlays/chats_calls_privacy_overlay.dart';
import '../views/community_message_list_view.dart';

class CommunityWidget extends StatefulWidget {
  final CommunityModel community;
  final double sidePanelWidth;
  final UserModel user;

  const CommunityWidget({
    super.key,
    required this.community,
    required this.sidePanelWidth,
    required this.user,
  });

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  List<MessageModel> list = [];
  List<MessageModel> cachedMessages = [];
  List<bool> isHoveredList = [];
  late final CommunityModel community;
  late FocusNode focusNode;
  final overlayController = Get.put(OverlayColorController());
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Stream<QuerySnapshot<Map<String, dynamic>>>? messageStream;
  bool isHovered = false;
  bool isTyping = false;
  bool isHoveredDate = false;
  final GlobalKey _textFieldKey = GlobalKey();

  bool _isTextFieldHit(TapDownDetails details) {
    final renderBox = _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return false;

    final textFieldOffset = renderBox.localToGlobal(Offset.zero);
    final textFieldSize = renderBox.size;
    final rect = textFieldOffset & textFieldSize;

    return rect.contains(details.globalPosition);
  }

  @override
  void initState() {
    super.initState();
    community = widget.community;
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    await APIs.sendMessageCommunityChat(communityId: community.id, chatId: 'main', text: text);

    setState(() {
      textController.clear();
    });
  }

  void onEmojiSelected(String emoji) {
    setState(() {
      textController.text += emoji;
      textController.selection = TextSelection.collapsed(offset: textController.text.length);
    });
  }

  void onGifSelected(String sticker) {
    setState(() {
      textController.text += '[sticker:$sticker]';
      textController.selection = TextSelection.collapsed(offset: textController.text.length);
    });
  }

  Future<void> onImageSelected(File imageFile) async {
    log('Файл готов к отправке: ${imageFile.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommunityAppBar(community: community, user: widget.user),
      body: _buildBody(),
      bottomNavigationBar: BottomInput(
        textFieldKey: _textFieldKey,
        textController: textController,
        focusNode: focusNode,
        isHovered: isHovered,
        sendMessage: sendMessage,
        showEmojiStickersDialog: () async {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          await showEmojiStickersDialog(context, position, onEmojiSelected, onGifSelected);
        },
        showAttachFileDialog: () async {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          await showAttachFileDialog(context, position, onImageSelected);
        },
        onEmojiSelected: onEmojiSelected,
        onGifSelected: onGifSelected,
      ),
    );
  }

  Widget _buildBody() {
    final backgroundImage = context.isDarkMode ? ChatifyImages.groupBackgroundDark : ChatifyImages.groupBackgroundLight;

    return FocusTraversalGroup(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          final focused = FocusManager.instance.primaryFocus;
          if (focused != null && !_isTextFieldHit(details)) {
            focused.unfocus();
          }
        },
        onSecondaryTapDown: (details) {
          showSelectMessageDialog(
            context: context,
            position: details.globalPosition,
            items: [
              MenuItem(icon: Ionicons.checkbox_outline, text: S.of(context).selectMessages, onTap: () {}),
              MenuItem(icon: FluentIcons.open_16_regular, text: S.of(context).openChatInAnotherWindow, onTap: () {}),
              MenuItem(icon: Ionicons.close_outline, iconSize: 20, text: S.of(context).closeChat, onTap: () {}),
            ],
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, alignment: Alignment.center)),
              ),
            ),
            Positioned.fill(
              child: Obx(
                () {
                  final color = overlayController.overlayColor.value;
                  final gradient = overlayController.overlayGradient.value;

                  if (color == null && gradient == null) {
                    return Container(color: ChatifyColors.transparent);
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(color: gradient == null ? color : null, gradient: gradient),
                    child: Column(
                      children: [
                        CreationDateBadge(
                          createdAt: widget.community.createdAt,
                          includeTime: true,
                          onTap: () {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            final position = renderBox.localToGlobal(Offset.zero);
                            final currentDate = widget.community.createdAt;

                            showCalendarDialog(context, position, currentDate);
                          },
                        ),
                        EncryptionNoticeCard(
                          icon: PhosphorIcons.lock_simple_thin,
                          message: S.of(context).messagesCallsProtectedEndToEndEncryption,
                          onTap: () => showChatsCallsPrivacyOverlay(context),
                        ),
                        _buildMessages(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!isHovered && snapshot.hasData) {
          final data = snapshot.data?.docs;
          list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
          cachedMessages = list;
        }

        final messagesToShow = isHovered ? cachedMessages : list;
        final currentUserId = widget.community.id;
        final filteredMessages = messagesToShow.where((message) {
          return message.fromId == currentUserId || message.toId == currentUserId;
        }).toList();

        if (filteredMessages.isNotEmpty) {
          return CommunityMessageListView(messages: filteredMessages, scrollController: scrollController);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
