import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';

class CallOptionsPopupButton extends StatefulWidget {
  final ValueChanged<int> onSelected;

  const CallOptionsPopupButton({
    super.key,
    required this.onSelected,
  });

  @override
  State<CallOptionsPopupButton> createState() => _CallOptionsPopupButtonState();
}

class _CallOptionsPopupButtonState extends State<CallOptionsPopupButton> {
  bool _isMenuOpen = false;

  void _setMenuOpen(bool value) {
    if (_isMenuOpen == value) return;

    setState(() {
      _isMenuOpen = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _isMenuOpen ? ChatifyColors.darkGrey : ChatifyColors.white;

    return PopupMenuButton<int>(
      tooltip: S.of(context).call,
      position: PopupMenuPosition.under,
      offset: const Offset(10, 10),
      menuPadding: EdgeInsets.symmetric(vertical: 4),
      constraints: const BoxConstraints(minWidth: 0, maxWidth: 250),
      color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onOpened: () {
        _setMenuOpen(true);
      },
      onCanceled: () {
        _setMenuOpen(false);
      },
      onSelected: (value) {
        _setMenuOpen(false);
        widget.onSelected(value);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
          }
          return ChatifyColors.transparent;
        }),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 1,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            icon: Icon(Icons.call_outlined, size: 23),
            text: 'Аудиозвонок',
            onTap: () {
              Navigator.pop(context, 1);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            icon: Icon(Icons.videocam_outlined, size: 25),
            text: 'Видеозвонок',
            onTap: () {
              Navigator.pop(context, 2);
            },
          ),
        ),
        PopupMenuDivider(height: 8, indent: 0, endIndent: 0, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonDisabled),
        PopupMenuItem<int>(
          value: 3,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            icon: SvgPicture.asset(ChatifyVectors.personCheck, width: 23, height: 23, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
            text: 'Выберите контакты',
            onTap: () {
              Navigator.pop(context, 3);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            icon: Icon(Icons.link_rounded, size: 23),
            text: 'Отправить ссылку на звонок',
            onTap: () {
              Navigator.pop(context, 4);
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 5,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppPopupMenuItem(
            icon: Icon(Icons.calendar_month_outlined, size: 23),
            text: 'Запланировать звонок',
            onTap: () {
              Navigator.pop(context, 5);
            },
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(ChatifyVectors.videoCameraOutline, width: 24, height: 24, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
          Icon(Icons.arrow_drop_down, size: 25, color: iconColor),
        ],
      ),
    );
  }
}
