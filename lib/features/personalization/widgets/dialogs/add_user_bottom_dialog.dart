import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/welcome/screen/empty_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import 'light_dialog.dart';

void showAddUserBottomSheet(BuildContext context, String userImage, String userName, String phoneNumber) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                      child: const Icon(CupertinoIcons.person, size: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: ChatifySizes.fontSizeMd,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            phoneNumber,
                            style: TextStyle(
                              fontSize: ChatifySizes.fontSizeMd,
                              color: ChatifyColors.darkGrey,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        child: const Icon(Icons.check, color: ChatifyColors.white, size: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            await Dialogs.showCustomDialog(context: context, message: 'Загрузка...', duration: const Duration(seconds: 2));
            Navigator.push(context, createPageRoute(const EmptyScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: ChatifyColors.darkSlate,
                  child: Icon(Icons.add, color: ChatifyColors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Добавить аккаунт', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
