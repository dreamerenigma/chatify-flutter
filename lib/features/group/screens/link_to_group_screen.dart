import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../personalization/widgets/items/profile_settings_item.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../controllers/current_group_controller.dart';
import '../models/group_model.dart';
import '../widgets/images/placeholder_group_image.dart';
import 'group_permissions_screen.dart';

class LinkToGroupScreen extends StatelessWidget {
  final GroupModel group;

  const LinkToGroupScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text('Ссылка на группу', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TooltipTheme(
                data: TooltipThemeData(
                  decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(8)),
                  textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                  child: PopupMenuButton<int>(
                    tooltip: S.of(context).more,
                    position: PopupMenuPosition.under,
                    offset: const Offset(-8, 0),
                    menuPadding: const EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints(minWidth: 0, maxWidth: 230),
                    icon: const Icon(Icons.more_vert_rounded, size: 25),
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                        }

                        return ChatifyColors.transparent;
                      }),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Запись NFC тега',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    PlaceholderGroupImage(image: group.groupImage, size: MediaQuery.of(context).size.height * .07),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.groupName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 2),
                          Text(
                            'https://chat.chatify.ru/group_${group.id}&mlu=4&lir=4',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: ChatifyColors.greenSlate, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 10),
          ProfileSettingsItem(
            icon: Transform.flip(flipY: true, child: Icon(Icons.copy, size: 23, color: ChatifyColors.darkGrey)),
            title: 'Копировать ссылку',
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
          ProfileSettingsItem(
            icon: SvgPicture.asset(ChatifyVectors.arrowBendDoubleUpRight, width: 23, height: 23, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
            title: 'Переслать ссылку через Chatify',
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
          ProfileSettingsItem(
            icon: SvgPicture.asset(ChatifyVectors.messageWarningOutline, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
            title: 'Отправить ссылку по SMS',
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
          ProfileSettingsItem(
            icon: Icon(Icons.share_outlined, size: 23, color: ChatifyColors.darkGrey),
            title: 'Поделится ссылкой',
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
          ProfileSettingsItem(
            icon: Icon(Icons.qr_code, size: 25, color: ChatifyColors.darkGrey),
            title: 'Копировать ссылку',
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
          ProfileSettingsItem(
            icon: Icon(Icons.remove_circle_outline_rounded, size: 25, color: ChatifyColors.danger),
            title: 'Сбросить ссылку',
            titleColor: ChatifyColors.danger,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Управление разрешениями', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                Material(
                  color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    borderRadius: BorderRadius.circular(30),
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    onTap: () {
                      Get.find<CurrentGroupController>().setGroup(group);

                      Navigator.push(context, createPageRoute(GroupPermissionsScreen()));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                      child: Center(child: Text('Изменить', style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          ProfileSettingsItem(
            icon: SvgPicture.asset(ChatifyVectors.messageWarningOutline, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
            title: 'Чтобы вступить в эту группу, новые участники должны получить одобрение админа.',
            titleColor: ChatifyColors.darkGrey,
            titleFontSize: 15,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
          ProfileSettingsItem(
            icon: Icon(Icons.group_outlined, size: 25, color: ChatifyColors.darkGrey),
            title: 'Участники имеют доступ к ссылке в этом разделе.',
            titleColor: ChatifyColors.darkGrey,
            titleFontSize: 15,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
