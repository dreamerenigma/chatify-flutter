import 'dart:developer';
import 'dart:io';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/file_util.dart';

class StickerContentWidget extends StatefulWidget {
  const StickerContentWidget({super.key});

  @override
  State<StickerContentWidget> createState() => _StickerContentWidgetState();
}

class _StickerContentWidgetState extends State<StickerContentWidget> {
  final RxInt selectedIndex = 0.obs;
  final RxList<bool> hoverStates = List.generate(3, (_) => false).obs;
  final RxString displayText = 'Вы пока не добавили ни одного стикера'.obs;
  final List<IconData> icons = [Ionicons.time_outline, Icons.star_border_rounded, PhosphorIcons.plus];

  void _handleIconTap(int index) async {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        displayText.value = 'Вы пока не добавили ни одного стикера';
        break;
      case 1:
        displayText.value = 'Вы пока не добавили ни одного стикера в избранное';
        break;
      case 2:
        await _pickImageFromWindows();
        break;
    }
  }

  Future<void> _pickImageFromWindows() async {
    final picturesPath = await FileUtil.getUserPicturesPath();
    log('Initial directory: $picturesPath');

    if (Platform.isWindows) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        dialogTitle: 'Открытие',
        initialDirectory: picturesPath,
      );

      log('File picker result: ${result?.files.single.path}');

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path;
        if (path != null) {
          log('Выбран файл: $path');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => Center(child: Text(displayText.value, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto')))),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildStickerPanel(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStickerPanel(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: (context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey).withAlpha((0.6 * 255).toInt()),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(icons.length, (index) {
          final bool isSelected = selectedIndex.value == index;
          final bool isHovering = hoverStates[index];
          final Color iconColor = isSelected || isHovering ? ChatifyColors.white : ChatifyColors.darkGrey;

          return MouseRegion(
            onEnter: (_) => hoverStates[index] = true,
            onExit: (_) => hoverStates[index] = false,
            child: GestureDetector(
              onTap: () => _handleIconTap(index),
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(icons[index], size: 19, color: iconColor),
              ),
            ),
          );
        }),
      ),
    ));
  }
}
