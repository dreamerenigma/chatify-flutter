import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon_forest/iconoir.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../chat/models/message_model.dart';
import '../../../chat/widgets/cards/message_card.dart';
import '../../../personalization/widgets/dialogs/attach_files_dialog.dart';
import '../../../personalization/widgets/dialogs/emoji_stickers_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/group_model.dart';
import '../bars/group_chat_app_bar.dart';

class GroupChatWidget extends StatefulWidget {
  final GroupModel group;
  final double sidePanelWidth;

  const GroupChatWidget({
    super.key,
    required this.sidePanelWidth,
    required this.group,
  });

  @override
  State<GroupChatWidget> createState() => _GroupChatWidgetState();
}

class _GroupChatWidgetState extends State<GroupChatWidget> {
  List<MessageModel> list = [];
  List<MessageModel> messages = [];
  List<MessageModel> cachedMessages = [];
  late Future<Map<String, String>> userNamesFuture;
  late final GroupModel group;
  late TextEditingController textController;
  Stream<QuerySnapshot<Map<String, dynamic>>>? messageStream;
  late FocusNode focusNode;
  bool hasText = false;
  bool isHovered = false;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    group = widget.group;
    _setMessagesStream();
    userNamesFuture = APIs.fetchUserNames(group.members, shortenNames: true);
    textController = TextEditingController();
    textController.addListener(() {
      setState(() {
        hasText = textController.text.trim().isNotEmpty;
      });
    });
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GroupChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldChatWidget = oldWidget;
    final newChatWidget = widget;

    if (oldChatWidget.group != newChatWidget.group) {
      _setMessagesStream();
    }
  }

  void _setMessagesStream() {
    cachedMessages.clear();
    messageStream = APIs.getGroupAllMessages(widget.group);
  }

  void sendMessage(String msg) {
    if (textController.text.isNotEmpty) {
      APIs.sendGroupMessage(widget.group, textController.text, Type.text);

      textController.clear();
      APIs.playSendSound();

      setState(() {
        isTyping = false;
      });

      // APIs.updateTypingStatus(widget.group.groupId, false);
    } else {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterText);
    }
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
      appBar: GroupChatAppBar(groupImage: group.groupImage, groupName: group.groupName, members: group.members, userNamesFuture: userNamesFuture),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomInputBar(context),
    );
  }

  Widget _buildBody() {
    final backgroundImage = context.isDarkMode ? ChatifyImages.groupBackgroundDark : ChatifyImages.groupBackgroundLight;

    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, alignment: Alignment.center)),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildGroupMessages(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const SizedBox();

          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) {
              return ListView.builder(
                reverse: true,
                itemCount: list.length,
                padding: EdgeInsets.only(top: DeviceUtils.getScreenHeight(context) * .01),
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MessageCard(message: list[index], isSelected: false, onLongPress: () {}, onTap: () {}, messages: messages);
                },
              );
            } else {
              return const SizedBox();
            }
        }
      },
    );
  }

  Widget _buildBottomInputBar(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey, width: 1)),
      ),
      child: Row(
        children: [
          Tooltip(
            verticalOffset: -50,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            message: 'Смайлики, GIF-файлы, стикеры (Ctrl+Shift+E,G,S)',
            textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);

                  showEmojiStickersDialog(context, position, onEmojiSelected, onGifSelected);
                },
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()),
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Iconoir(Iconoir.emoji, width: 20, height: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Tooltip(
            verticalOffset: -50,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            message: 'Прикрепить',
            textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showAttachFileDialog(context, position, onImageSelected);
                },
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()),
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(11),
                  child: Transform(
                    transform: Matrix4.rotationZ(math.pi / 1),
                    alignment: Alignment.center,
                    child: Iconoir(Iconoir.attachment, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isHovered
                    ? (context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()) : ChatifyColors.softGrey.withAlpha((0.2 * 255).toInt()))
                    : ChatifyColors.transparent,
                ),
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  ),
                  child: TextField(
                    controller: textController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение',
                      hintStyle: TextStyle(
                        color: focusNode.hasFocus ? ChatifyColors.steelGrey : (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey),
                        fontWeight: FontWeight.w300,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 6),
                      filled: false,
                    ),
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        sendMessage(value.trim());
                        textController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Tooltip(
            waitDuration: const Duration(milliseconds: 700),
            showDuration: const Duration(seconds: 700),
            verticalOffset: -50,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            message: 'Записать голосовое сообщение',
            textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  if (hasText) {
                    log('Отправка сообщения: ${textController.text}');
                    textController.clear();
                  } else {
                    log('Голосовое сообщение');
                  }
                },
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()),
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    hasText ? FluentIcons.send_16_regular : Icons.mic_none,
                    size: 20,
                    color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
