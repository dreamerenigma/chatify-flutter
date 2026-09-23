import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/welcome/screen/empty_screen.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../widget/press_scale_widget.dart';
import 'light_dialog.dart';

void showAddUserBottomSheet(BuildContext context, String userImage, String userName, String phoneNumber) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    showDragHandle: false,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 14),
        Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 25),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Добавьте ещё один аккаунт Chatify, чтобы легко переключаться между аккаунтами.', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1)),
            child: Column(
              children: [
                PressScale(
                  scale: 0.99,
                  onTap: () async {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            width: 40,
                            height: 40,
                            imageUrl: userImage,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              foregroundColor: ChatifyColors.white,
                              child: SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userName, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                  Text(phoneNumber, style: TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400, height: 1.4)),
                                ],
                              ),
                              SvgPicture.asset(ChatifyVectors.checkCircleFilled, width: 26, height: 26, colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                PressScale(
                  scale: 0.99,
                  onTap: () async {
                    Navigator.pop(context);

                    await Dialogs.showCustomDialog(context: context, message: S.of(context).loading, duration: const Duration(seconds: 2));

                    if (!context.mounted) return;

                    Navigator.push(context, createPageRoute(const EmptyScreen()));
                  },
                  child: Material(
                    color: ChatifyColors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      child: Row(
                        children: [
                          const CircleAvatar(radius: 22, backgroundColor: ChatifyColors.cardColor, child: Icon(Icons.add_rounded, size: 27, color: ChatifyColors.white)),
                          const SizedBox(width: 14),
                          Text('Добавить аккаунт Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Другие профили', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1)),
            child:PressScale(
              scale: 0.99,
              onTap: () async {
                Navigator.pop(context);
              },
              child: Material(
                color: ChatifyColors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 22, backgroundColor: ChatifyColors.cardColor, child: Icon(Icons.add_rounded, size: 27, color: ChatifyColors.white)),
                      const SizedBox(width: 14),
                      Text('Добавить ВКонтакте', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
