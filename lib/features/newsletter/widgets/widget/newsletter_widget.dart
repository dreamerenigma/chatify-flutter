import 'dart:developer';
import 'dart:io';
import 'package:chatify/features/newsletter/models/newsletter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/dialogs/items/menu_item.dart';
import '../../../chat/widgets/dialogs/select_message_dialog.dart';
import '../../../chat/widgets/input/bottom_input.dart';
import '../../../home/controllers/overlay_color_controller.dart';
import '../bars/newsletter_app_bar.dart';
import '../../../personalization/widgets/dialogs/attach_files_dialog.dart';
import '../../../personalization/widgets/dialogs/emoji_stickers_dialog.dart';

class NewsletterWidget extends StatefulWidget {
  final NewsletterModel newsletter;
  final List<String> newsletters;
  final double sidePanelWidth;
  final UserModel user;

  const NewsletterWidget({
    super.key,
    required this.newsletter,
    required this.sidePanelWidth,
    required this.newsletters,
    required this.user,
  });

  @override
  State<NewsletterWidget> createState() => _NewsletterWidgetState();
}

class _NewsletterWidgetState extends State<NewsletterWidget> {
  late Future<Map<String, String>> userNamesFuture;
  late NewsletterModel newsletter;
  late FocusNode focusNode;
  final overlayController = Get.put(OverlayColorController());
  final GlobalKey _textFieldKey = GlobalKey();
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    newsletter = widget.newsletter;
    userNamesFuture = APIs.fetchUserNames(newsletter.newsletters, shortenNames: true);
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
  void didUpdateWidget(covariant NewsletterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.newsletter.id != widget.newsletter.id) {
      setState(() {
        newsletter = widget.newsletter;
        textController.clear();
        FocusScope.of(context).requestFocus(focusNode);
      });
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    await APIs.sendMessageNewsletterChat(newsletterId: newsletter.id, chatId: 'main', text: text);

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
      appBar: NewsletterAppBar(newsletter: newsletter, newsletters: widget.newsletters, user: widget.user),
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
            MenuItem(icon: Ionicons.checkbox_outline, text: 'Выбрать сообщения', onTap: () {}),
            MenuItem(icon: FluentIcons.open_16_regular, text: 'Открыть чат в другом окне', onTap: () {}),
            MenuItem(icon: Ionicons.close_outline, iconSize: 20, text: 'Закрыть чат', onTap: () {}),
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
}
