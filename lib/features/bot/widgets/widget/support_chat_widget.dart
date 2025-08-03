import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/home/widgets/dialogs/confirmation_dialog.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/badges/creation_date_badge.dart';
import '../../../../common/widgets/cards/encryption_notice_card.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../chat/widgets/dialogs/calendar_dialog.dart';
import '../../../chat/widgets/dialogs/items/menu_item.dart';
import '../../../chat/widgets/dialogs/select_message_dialog.dart';
import '../../../chat/widgets/input/bottom_input.dart';
import '../../../home/controllers/overlay_color_controller.dart';
import '../../../home/widgets/dialogs/overlays/contacting_support_overlay.dart';
import '../../../personalization/widgets/dialogs/attach_files_dialog.dart';
import '../../../personalization/widgets/dialogs/emoji_stickers_dialog.dart';
import '../../../personalization/widgets/dialogs/overlays/info_chat_support_app_overlay.dart';
import '../../models/support_model.dart';
import '../bars/support_app_bar.dart';

class SupportChatWidget extends StatefulWidget {
  final SupportAppModel support;
  final double sidePanelWidth;

  const SupportChatWidget({
    super.key,
    required this.support,
    required this.sidePanelWidth,
  });

  @override
  State<SupportChatWidget> createState() => _SupportChatWidgetState();
}

class _SupportChatWidgetState extends State<SupportChatWidget> {
  late SupportAppModel support;
  late FocusNode focusNode;
  final overlayController = Get.put(OverlayColorController());
  final GlobalKey _textFieldKey = GlobalKey();
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isHovered = false;
  bool isHoveredSupportAccount = false;
  bool isHoveredMessageAi = false;
  ValueNotifier<double> scale = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();
    support = widget.support;
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

  @override
  void didUpdateWidget(covariant SupportChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.support.id != widget.support.id) {
      setState(() {
        support = widget.support;
        textController.clear();
        FocusScope.of(context).requestFocus(focusNode);
      });
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    await APIs.sendMessageSupportChat(supportId: support.id, chatId: 'main', text: text);

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
      appBar: SupportAppBar(support: widget.support),
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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
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
                        createdAt: widget.support.createdAt,
                        includeTime: true,
                        onTap: () {
                          final RenderBox renderBox = context.findRenderObject() as RenderBox;
                          final position = renderBox.localToGlobal(Offset.zero);

                          showCalendarDialog(context, position, widget.support.createdAt);
                        },
                      ),
                      EncryptionNoticeCard(
                        maxWidth: 550,
                        icon: FluentIcons.info_16_regular,
                        message: S.of(context).officialAppSupportAccount,
                        onTap: () => ContactingSupportOverlay(context).show(),
                      ),
                      _buildSupportNotice(
                        text: S.of(context).officialAppSupportBusinessAccount,
                        maxWidth: 400,
                        containerIndex: 0,
                        onTap: () {
                          showConfirmationDialog(
                            context: context,
                            description: S.of(context).appConfirmsOfficialAppSupport,
                            confirmText: S.of(context).readMore,
                            cancelText: S.of(context).ok,
                            onConfirm: () => UrlUtils.launchURL(AppLinks.accountSupport),
                          );
                        },
                      ),
                      _buildSupportNotice(
                        text: S.of(context).messagesAIGeneratedInappropriate,
                        maxWidth: 600,
                        containerIndex: 1,
                        onTap: () {
                          InfoChatSupportAppOverlay(context).show();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportNotice({required String text, required double maxWidth, required int containerIndex, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45, top: 18),
      child: GestureDetector(
        onTap: () {
              onTap();

              scale.value = 0.99;

              Future.delayed(const Duration(milliseconds: 100), () {
                scale.value = 1.0;
              });
            },
            onTapDown: (_) {
              scale.value = 0.99;
            },
            onTapUp: (_) {
              scale.value = 1.0;
            },
            onTapCancel: () {
              scale.value = 0.99;
            },
            onLongPressUp: () {
              scale.value = 1.0;
            },
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              if (containerIndex == 0) {
                isHoveredSupportAccount = true;
              } else {
                isHoveredMessageAi = true;
              }
            });
          },
          onExit: (_) {
            setState(() {
              if (containerIndex == 0) {
                isHoveredSupportAccount = false;
              } else {
                isHoveredMessageAi = false;
              }
            });
          },
          child: Center(
            child: GestureDetector(
              onTap: onTap,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double effectiveMaxWidth = maxWidth;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.black.withAlpha((0.05 * 255).toInt()),
                      border: Border.all(
                        color: (context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.black).withAlpha((containerIndex == 0 ? isHoveredSupportAccount : isHoveredMessageAi) ? 255 : 0),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
                      child: Center(
                        child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300, height: 1.2), textAlign: TextAlign.center, softWrap: true),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
