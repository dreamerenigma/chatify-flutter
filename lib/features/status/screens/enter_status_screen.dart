import 'dart:math';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/dialogs/delete_confirmation_dialog.dart';
import '../widgets/dialogs/sticker_bottom_dialog.dart';
import '../widgets/dialogs/update_status_bottom_dialog.dart';
import 'package:remixicon/remixicon.dart';

class EnterStatusScreen extends StatefulWidget {
  final UserModel user;

  const EnterStatusScreen({super.key, required this.user});

  @override
  EnterStatusScreenState createState() => EnterStatusScreenState();
}

class EnterStatusScreenState extends State<EnterStatusScreen> with WidgetsBindingObserver {
  final FocusNode textFocusNode = FocusNode();
  final TextEditingController textController = TextEditingController();
  final List<String> fonts = ['Helvetica', 'Satoshi', 'Poppins'];
  final List<IconData> icons = [FluentIcons.text_t_20_regular, FluentIcons.text_t_20_regular, FluentIcons.text_t_20_regular];
  bool showEmoji = false;
  bool showEmojiKeyboard = false;
  double keyboardHeight = 0.0;
  Color backgroundColor = ChatifyColors.blackGrey;
  int currentFontIndex = 0;
  int currentIconIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _changeBackgroundColor();
    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (keyboardHeight > 0 && showEmojiKeyboard) {
      setState(() {
        showEmojiKeyboard = false;
      });
    }
  }

  void _changeFontAndIcon() {
    setState(() {
      currentFontIndex = (currentFontIndex + 1) % fonts.length;
      currentIconIndex = (currentIconIndex + 1) % icons.length;
    });
  }

  void _changeBackgroundColor() {
    final random = Random();
    setState(() {
      backgroundColor = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  void _toggleStickerDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      builder: (BuildContext context) {
        return StickerBottomSheet(onClose: () {
          Navigator.pop(context);
        });
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    if (textController.text.isNotEmpty) {
      final shouldDelete = await showDeleteConfirmationDialog(context, () {
        textController.clear();
      });

      if (shouldDelete ?? false) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: ChatifyColors.transparent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: isKeyboardOpen ? BorderRadius.zero : const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
              child: Container(height: screenHeight * 0.92, color: backgroundColor, child: _buildTextInputArea()),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: _buildIcon(Icons.close, ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 25, _showDeleteConfirmationDialog),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildIcon(PhosphorIcons.sticker, ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 25, _toggleStickerDialog),
                const SizedBox(width: 8),
                _buildIcon(Remix.text, ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 27, _changeFontAndIcon),
                const SizedBox(width: 8),
                _buildIcon(Icons.palette_outlined, ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 25, _changeBackgroundColor),
                const SizedBox(width: 8),
                _buildIcon(FluentIcons.edit_16_regular, ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 25, () {}),
              ],
            ),
          ),
          if (textController.text.trim().isEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildMediaAdd(isKeyboardOpen),
            )
          else
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomStatusBar(context),
            ),
        ],
      ),
    );
  }

  Widget _buildTextInputArea() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          ),
          child: TextField(
            controller: textController,
            focusNode: textFocusNode,
            textAlign: TextAlign.center,
            style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeGl, fontFamily: fonts[currentFontIndex]),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: S.of(context).enterStatus,
              hintStyle: TextStyle(color: ChatifyColors.white.withAlpha((0.5 * 255).toInt()), fontSize: ChatifySizes.fontSizeGl),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autofocus: true,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaAdd(bool isKeyboardOpen) {
    final mediaItems = ['Видео', 'Фото', 'Текст', 'Голос'];

    return Container(
      decoration: BoxDecoration(color: isKeyboardOpen ? ChatifyColors.blackGrey.withAlpha((0.8 * 255).toInt()) : ChatifyColors.transparent),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 12, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: mediaItems.map((item) {
            final isSelected = item == mediaItems[2];

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey : ChatifyColors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(item, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomStatusBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ChatifyColors.blackGrey.withAlpha((0.8 * 255).toInt())),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                showUpdateStatusSheetDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(color: ChatifyColors.darkSlate, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    SvgPicture.asset(ChatifyVectors.status, color: ChatifyColors.white, width: 16),
                    const SizedBox(width: 8),
                    Text(S.of(context).statusContacts, style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                child: IconButton(
                  icon: const Icon(Icons.send, color: ChatifyColors.white, size: 25),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color color, double iconSize, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 22,
      child: Center(
        child: IconButton(icon: Icon(icon, color: ChatifyColors.white, size: iconSize), onPressed: onPressed),
      ),
    );
  }
}
