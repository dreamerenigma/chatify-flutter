import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../community/widgets/dialogs/delete_confirmation_dialog.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../images/profile_photo_picker.dart';
import '../options/profile_photo_option.dart';

void showEditPhotoBottomSheet(BuildContext context, Function(String?) onImagePicked, VoidCallback onDeletePressed) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(26))),
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),
          Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 18),
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * .01, right: MediaQuery.of(context).size.height * .01, bottom: MediaQuery.of(context).size.height * .01),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(FluentIcons.delete_24_regular),
                            onPressed: () {
                              showDeleteConfirmationDialog(context, onImagePicked, onDeletePressed);
                            },
                          ),
                        ),
                      ),
                      Text(S.of(context).profilePhoto, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(FluentIcons.dismiss_24_regular, size: 26),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    ProfilePhotoOption(
                      icon: Icon(Icons.camera_alt_outlined, color: ChatifyColors.darkGrey, size: 26),
                      label: S.of(context).camera,
                      onTap: () => handleContainerTap,
                    ),
                    ProfilePhotoOption(
                      icon: Icon(Icons.photo_outlined, color: ChatifyColors.darkGrey, size: 26),
                      label: S.of(context).gallery,
                      onTap: () => handleContainerTap,
                    ),
                    ProfilePhotoOption(
                      icon: SvgPicture.asset(ChatifyVectors.avatar, width: 26, height: 26, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                      label: S.of(context).avatar,
                      onTap: () => handleContainerTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
