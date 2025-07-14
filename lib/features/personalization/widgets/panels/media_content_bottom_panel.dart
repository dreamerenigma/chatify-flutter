import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:icon_forest/iconoir.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/file_util.dart';
import '../../../chat/models/user_model.dart';
import '../dialogs/emoji_stickers_dialog.dart';
import '../dialogs/light_dialog.dart';

class MediaContentBottomPanel extends StatefulWidget {
  final UserModel user;
  final ValueNotifier<bool> isFocused;
  final FocusNode captionFocusNode;
  final AnimationController animationController;
  final OverlayEntry overlayEntry;
  final Function(String) onEmojiSelected;
  final Function(String) onGifSelected;
  final String? gifUrl;

  const MediaContentBottomPanel({
    super.key,
    required this.user,
    required this.isFocused,
    required this.captionFocusNode,
    required this.animationController,
    required this.overlayEntry,
    required this.onEmojiSelected,
    required this.onGifSelected,
    this.gifUrl,
  });

  @override
  State<MediaContentBottomPanel> createState() => _MediaContentBottomPanelState();
}

class _MediaContentBottomPanelState extends State<MediaContentBottomPanel> {
  File? selectedGif;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _initializeGifSelection(widget.gifUrl);
  }

  Future<void> _initializeGifSelection(String? gifUrl) async {
    if (gifUrl == null) return;

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.gif';
    final response = await http.get(Uri.parse(gifUrl));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      selectedGif = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(widget.captionFocusNode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softNight,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      onTap: () {
                        final RenderBox renderBox = context.findRenderObject() as RenderBox;
                        final position = renderBox.localToGlobal(Offset.zero);

                        showEmojiStickersDialog(context, position, widget.onEmojiSelected, widget.onGifSelected);
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Iconoir(Iconoir.emoji, width: 20, height: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: widget.isFocused,
                      builder: (context, isFocusedValue, _) {
                        return TextSelectionTheme(
                          data: TextSelectionThemeData(
                            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                          child: TextField(
                            focusNode: widget.captionFocusNode,
                            cursorWidth: 1,
                            decoration: InputDecoration(
                              hintText: 'Подпись (необязательно)',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: isFocusedValue ? ChatifyColors.white : ChatifyColors.darkGrey, fontWeight: FontWeight.w300),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      onTap: isActive ? () {} : null,
                      mouseCursor: SystemMouseCursors.basic,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                      child: Opacity(
                        opacity: isActive ? 1.0 : 0.7,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(ChatifyVectors.timer, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 17, height: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () async {
                        await FileUtil.pickFileAndProcess(
                          context: context,
                          onFileSelected: (newFile) {},
                          animationController: widget.animationController,
                          overlayEntry: widget.overlayEntry,
                        );
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.grey,
                      child: SvgPicture.asset(
                        ChatifyVectors.add,
                        color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (selectedGif != null) {
                          await APIs.sendChatImage(widget.user, selectedGif!);

                          setState(() {
                            selectedGif = null;
                          });

                          await widget.animationController.reverse();

                          widget.overlayEntry.remove();
                        } else {
                          log("GIF-файл не выбран");
                        }
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey,
                      child: const Icon(FluentIcons.send_20_regular, size: 21, color: ChatifyColors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
