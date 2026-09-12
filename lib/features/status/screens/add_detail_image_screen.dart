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
          Center(child: Image.file(widget.imageFile)),
          Positioned(
            top: 40,
            left: 16,
            child: _buildIcon(icon: Icon(Icons.close), color: ChatifyColors.blackGrey, iconSize: 25, onPressed: () => Navigator.pop(context)),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildIcon(
                  icon: const Icon(Icons.crop_rotate_outlined, color: ChatifyColors.white),
                  color: ChatifyColors.blackGrey,
                  iconSize: 25,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                _buildIcon(
                  icon: SvgPicture.asset(ChatifyVectors.sticker, width: 27, height: 27, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                  color: ChatifyColors.blackGrey,
                  iconSize: 27,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                _buildIcon(
                  icon: SvgPicture.asset(ChatifyVectors.textFormat, width: 27, height: 27, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                  color: ChatifyColors.blackGrey,
                  iconSize: 25,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                _buildIcon(
                  icon: const Icon(Icons.mode_edit_outlined, color: ChatifyColors.white),
                  color: ChatifyColors.blackGrey,
                  iconSize: 25,
                  onPressed: () {},
                ),
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
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
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
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                child: IconButton(
                  icon: Padding(padding: const EdgeInsets.only(left: 3), child: const Icon(Icons.send, color: ChatifyColors.black, size: 23)),
                  onPressed: () async {
                    log('STATUS: кнопка нажата');

                    try {
                      log('STATUS: начинаем загрузку изображения');

                      final imageUrl = await APIs.uploadStatusImage(widget.imageFile);

                      log('STATUS: uploadStatusImage завершён: $imageUrl');

                      if (imageUrl == null) {
                        log('STATUS: imageUrl == null');
                        throw Exception('Не удалось загрузить изображение статуса');
                      }

                      log('STATUS: добавляем статус в Firestore');

                      await APIs.addStatus(mediaPath: imageUrl, type: 'image');

                      log('STATUS: статус успешно добавлен');

                      if (!mounted) {
                        log('STATUS: widget уже unmounted');
                        return;
                      }

                      log('STATUS: переходим на StatusScreen');

                      Navigator.push(
                        context,
                        createPageRoute(
                          StatusScreen(user: widget.user),
                        ),
                      );
                    } catch (e, stackTrace) {
                      log('STATUS ERROR: $e');
                      log('STATUS STACK: $stackTrace');
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

  Widget _buildIcon({required Widget icon, required Color color, required double iconSize, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: SizedBox(width: iconSize, height: iconSize, child: icon),
      ),
    );
  }
}
