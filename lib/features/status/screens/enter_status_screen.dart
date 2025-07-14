import  'dart:math';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/dialogs/update_status_bottom_dialog.dart';

class EnterStatusScreen extends StatefulWidget {
  final UserModel user;

  const EnterStatusScreen({super.key, required this.user});

  @override
  EnterStatusScreenState createState() => EnterStatusScreenState();
}

class EnterStatusScreenState extends State<EnterStatusScreen> with WidgetsBindingObserver {
  bool showEmoji = false;
  double keyboardHeight = 0.0;
  bool showEmojiKeyboard = false;
  final FocusNode textFocusNode = FocusNode();
  Color backgroundColor = ChatifyColors.blackGrey;
  final TextEditingController textController = TextEditingController();
  final List<String> fonts = ['Helvetica', 'Satoshi', 'Poppins'];
  final List<IconData> icons = [FluentIcons.text_t_20_regular, FluentIcons.text_t_20_regular, FluentIcons.text_t_20_regular];

  int currentFontIndex = 0;
  int currentIconIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _changeBackgroundColor();
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

  void _toggleEmojiKeyboard() {
    setState(() {
      showEmojiKeyboard = !showEmojiKeyboard;
      if (showEmojiKeyboard) {
        FocusScope.of(context).unfocus();
      } else {
        textFocusNode.requestFocus();
      }
    });
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

  Future<void> _showDeleteConfirmationDialog() async {
    if (textController.text.isNotEmpty) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(left: 25, right: 25, top: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Удалить текст?', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Отмена'),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        textController.clear();
                        Navigator.of(context).pop(true);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Удалить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (shouldDelete ?? false) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: [
            _buildTextInputArea(),
            Positioned(
              top: 40,
              left: 16.0,
              child: _buildIcon(Icons.close, ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 25, _showDeleteConfirmationDialog),
            ),
            Positioned(
              top: 40,
              right: 16.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildIcon(
                    showEmojiKeyboard ? Icons.keyboard : Icons.emoji_emotions_outlined,
                    ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 25, _toggleEmojiKeyboard,
                  ),
                  const SizedBox(width: 16.0),
                  _buildIcon(
                    icons[currentIconIndex],
                    ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()),
                    27,
                    _changeFontAndIcon,
                  ),
                  const SizedBox(width: 16.0),
                  _buildIcon(Icons.palette_outlined, ChatifyColors.darkerGrey.withAlpha((0.7 * 255).toInt()), 25, () {
                    _changeBackgroundColor();
                  }),
                ],
              ),
            ),
            if (showEmojiKeyboard)
              Positioned(
                bottom: 65,
                left: 0,
                right: 0,
                child: _buildEmojiKeyboard(),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomStatusBar(context),
            ),
          ],
        ),
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
            style: TextStyle(
              color: ChatifyColors.white,
              fontSize: ChatifySizes.fontSizeGl,
              fontFamily: fonts[currentFontIndex],
            ),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Введите статус',
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

  Widget _buildBottomStatusBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ChatifyColors.blackGrey.withAlpha((0.8 * 255).toInt()),
      ),
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
                decoration: BoxDecoration(
                  color: ChatifyColors.darkSlate,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ChatifyVectors.status,
                      color: ChatifyColors.white,
                      width: 16,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Статус (Контакты)',
                      style: TextStyle(
                        color: ChatifyColors.white,
                        fontSize: ChatifySizes.fontSizeSm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
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

  Widget _buildEmojiKeyboard() {
    return Container(
      height: 250,
      color: ChatifyColors.grey,
      child: EmojiPicker(
        textEditingController: textController,
        config: Config(
          height: DeviceUtils.getScreenHeight(context) * 0.35,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            columns: 8,
            emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
          ),
          categoryViewConfig: const CategoryViewConfig(),
          bottomActionBarConfig: const BottomActionBarConfig(),
          skinToneConfig: const SkinToneConfig(),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color color, double iconSize, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 22,
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: ChatifyColors.white, size: iconSize),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
