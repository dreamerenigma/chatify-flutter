import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';

void showVideoCallPopupMenu(BuildContext context, {void Function(int)? onPopupItemSelected}) {
  showMenu<int>(
    context: context,
    position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 220, kToolbarHeight + 25, 8, 0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    constraints: const BoxConstraints(minWidth: 220, maxWidth: 220),
    menuPadding: const EdgeInsets.symmetric(vertical: 4),
    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
    items: [
      PopupMenuItem<int>(
        value: 1,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppPopupMenuItem(
          icon: Icon(Icons.call_outlined, size: 24, color: ChatifyColors.darkGrey),
          text: 'Аудиозвонок',
          onTap: () {
            Navigator.pop(context, 10);
          },
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppPopupMenuItem(
          icon: SvgPicture.asset(ChatifyVectors.videoCameraOutline, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          text: 'Видеозвонок',
          onTap: () {
            Navigator.pop(context, 11);
          },
        ),
      ),
      PopupMenuItem<int>(
        value: 3,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppPopupMenuItem(
          icon: SvgPicture.asset(ChatifyVectors.personCheck, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          text: 'Выберите контакты',
          onTap: () {
            Navigator.pop(context, 11);
          },
        ),
      ),
      PopupMenuItem<int>(
        value: 4,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppPopupMenuItem(
          icon: Icon(Icons.link, size: 24, color: ChatifyColors.darkGrey),
          text: 'Отправить ссылку на звонок',
          onTap: () {
            Navigator.pop(context, 11);
          },
        ),
      ),
      PopupMenuItem<int>(
        value: 5,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AppPopupMenuItem(
          icon: Icon(Icons.calendar_month_outlined, size: 24, color: ChatifyColors.darkGrey),
          text: 'Запланировать звонок',
          onTap: () {
            Navigator.pop(context, 11);
          },
        ),
      ),
    ],
  ).then((value) {
    if (value == null) return;

    onPopupItemSelected?.call(value);
  });
}
