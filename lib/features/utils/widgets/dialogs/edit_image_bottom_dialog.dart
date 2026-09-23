import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../community/screens/emoji_sticker_screen.dart';
import '../../../community/screens/search_internet_screen.dart';
import '../../../community/widgets/items/community_image_items.dart';
import '../../../status/widgets/dialogs/delete_confirmation_dialog.dart';

void showEditImageBottomDialog(
  BuildContext context, {
  required String title,
  VoidCallback? onDeletePressed,
  required ValueChanged<String> onImageSelected,
  required Function(Color color, String emoji) onEmojiSelected,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(26))),
    builder: (bottomSheetContext) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 6),
              child: SizedBox(
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (onDeletePressed != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(FluentIcons.delete_24_regular, size: 26),
                          onPressed: () {
                            showDeleteConfirmationDialog(bottomSheetContext, onDeletePressed);
                          },
                        ),
                      ),
                    Center(child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400))),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 26),
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommunityImageItem(
                  icon: Icons.camera_alt_outlined,
                  title: S.of(context).camera,
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();

                    await Future<void>.delayed(Duration.zero);

                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

                    if (image == null) {
                      return;
                    }

                    onImageSelected(image.path);
                  },
                ),
                CommunityImageItem(
                  icon: Icons.image_outlined,
                  title: S.of(context).gallery,
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();

                    await Future<void>.delayed(Duration.zero);

                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                    if (image == null) return;

                    onImageSelected(image.path);
                  },
                ),
                CommunityImageItem(
                  svgAsset: ChatifyVectors.emojiSticker,
                  title: S.of(context).emoticonsStickers,
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    final result = await Navigator.push(context, createPageRoute(EmojiStickerScreen(initialColor: Colors.red[200]!, initialEmoji: '')));

                    if (result == null || result is! Map) {
                      return;
                    }

                    final Color? color = result['color'] as Color?;
                    final String? emoji = result['emoji'] as String?;

                    if (color == null || emoji == null || emoji.isEmpty) {
                      return;
                    }

                    onEmojiSelected(color, emoji);
                  },
                ),
                CommunityImageItem(
                  icon: Icons.search,
                  title: S.of(context).searchInternet,
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(bottomSheetContext, createPageRoute(SearchInternetScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
