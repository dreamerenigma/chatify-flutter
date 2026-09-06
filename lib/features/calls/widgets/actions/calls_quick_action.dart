import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../items/action_item.dart';

class CallsQuickActions extends StatelessWidget {
  final VoidCallback onNewCall;
  final VoidCallback onScheduled;
  final VoidCallback onKeyboard;
  final VoidCallback onFavorites;

  const CallsQuickActions({
    super.key,
    required this.onNewCall,
    required this.onScheduled,
    required this.onKeyboard,
    required this.onFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionItem(
            icon: Icon(Icons.call_outlined, size: 28),
            label: 'Позвонить',
            onTap: onNewCall,
          ),
          ActionItem(
            icon: Icon(Icons.calendar_month, size: 28),
            label: 'Запланировать',
            onTap: onScheduled,
          ),
          ActionItem(
            icon: SvgPicture.asset(ChatifyVectors.numpad, width: 28, height: 28, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
            label: 'Клавиатура',
            onTap: onKeyboard,
          ),
          ActionItem(
            icon: Icon(Icons.favorite_outline, size: 28),
            label: 'Избранное',
            onTap: onFavorites,
          ),
        ],
      ),
    );
  }
}
