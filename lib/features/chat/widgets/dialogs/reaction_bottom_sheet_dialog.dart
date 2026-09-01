import 'package:chatify/features/personalization/widgets/dialogs/light_dialog.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

void showReactionBottomSheetDialog(BuildContext context, {required Map<String, List<String>> reactions}) {
  final totalReactions = reactions.values.fold<int>(0, (sum, users) => sum + users.length);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 12, bottom: 80),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 5, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text('$totalReactions ${totalReactions == 1 ? 'реакция' : 'реакции'}', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 33,
                        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.grey, borderRadius: BorderRadius.circular(30)),
                        child: Center(child: Icon(Icons.add_reaction_outlined, size: 21, color: ChatifyColors.buttonLightGrey)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          width: 80,
                          height: 33,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: reactions.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final entry = reactions.entries.elementAt(index);

                              return Container(
                                width: 80,
                                height: 33,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(entry.key, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${entry.value.length}',
                                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ...reactions.entries.expand((entry) {
              final reaction = entry.key;
              final users = entry.value;

              return users.map((userId) {
                final isCurrentUser = userId == APIs.user.uid;

                return Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 12),
                  child: Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey, shape: BoxShape.circle),
                              child: Center(
                                child: SvgPicture.asset(
                                  ChatifyVectors.person,
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.buttonLightGrey : ChatifyColors.darkGrey, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(isCurrentUser ? 'Вы' : userId, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                  Text(isCurrentUser ? 'Нажмите, чтобы удалить' : '', style: TextStyle(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(reaction, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            }),
          ],
        ),
      );
    },
  );
}
