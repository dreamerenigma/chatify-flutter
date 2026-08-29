import 'dart:developer';
import 'dart:io';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/status/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/icons/custom_icon.dart';
import '../widgets/dialogs/update_status_bottom_dialog.dart';
import '../widgets/inputs/detail_image_input.dart';

class AddDetailImageScreen extends StatefulWidget {
  final UserModel user;
  final File imageFile;

  const AddDetailImageScreen({
    super.key,
    required this.imageFile,
    required this.user,
  });

  @override
  AddDetailImageScreenState createState() => AddDetailImageScreenState();
}

class AddDetailImageScreenState extends State<AddDetailImageScreen> with WidgetsBindingObserver {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool _isTextFieldFocused = false;
  bool showEmoji = false;
  double keyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void toggleEmojiKeyboard() {
    if (showEmoji) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }
    setState(() {
      showEmoji = !showEmoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.file(widget.imageFile),
          ),
          Positioned(
            top: 40,
            left: 16.0,
            child: _buildIcon(icon: Icons.close, color: ChatifyColors.blackGrey, iconSize: 25, onPressed: () => Navigator.pop(context)),
          ),
          Positioned(
            top: 40,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildIcon(icon: Icon(Icons.crop_rotate_outlined), color: ChatifyColors.blackGrey, iconSize: 25, onPressed: () {}),
                const SizedBox(width: 16),
                _buildIcon(icon: ChatifyVectors.sticker, color: ChatifyColors.blackGrey, iconSize: 27, onPressed: () {}),
                const SizedBox(width: 16),
                _buildIcon(icon: Icons.text_fields, color: ChatifyColors.blackGrey, iconSize: 25, onPressed: () {}),
                const SizedBox(width: 16),
                _buildIcon(icon: Icons.mode_edit_outlined, color: ChatifyColors.blackGrey, iconSize: 25, onPressed: () {}),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !_isTextFieldFocused && !showEmoji,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.keyboard_arrow_up_rounded),
                      SizedBox(height: 8),
                      Text(S.of(context).swipeUpToSelectFilters, style: TextStyle(fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                DetailImageInput(
                  user: widget.user,
                  focusNode: focusNode,
                  onToggleEmojiKeyboard: toggleEmojiKeyboard,
                ),
                AnimatedOpacity(
                  opacity: _isTextFieldFocused || showEmoji ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: _buildBottomStatusBar(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStatusBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: ChatifyColors.blackGrey),
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
                    SvgPicture.asset(ChatifyVectors.status, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn) , width: 16),
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
                  onPressed: () async {
                    try {
                      String imageUrl = await APIs.uploadImage(widget.imageFile);

                      await APIs.addStatus(imageUrl, '', DateTime.now());

                      Navigator.push(context, createPageRoute(StatusScreen(user: widget.user)));
                    } catch (e) {
                      log('${S.of(context).errorAddingStatus}: $e');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon({required dynamic icon, required Color color, required double iconSize, required VoidCallback onPressed}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 22,
      child: Center(child: IconButton(icon: CustomIcon(icon: icon, color: ChatifyColors.white, size: iconSize), onPressed: onPressed)),
    );
  }
}
