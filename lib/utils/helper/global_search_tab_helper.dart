import 'package:flutter_svg/svg.dart';
import '../../core/enums/global_search_tab_type.dart';
import 'package:flutter/material.dart';
import '../constants/app_vectors.dart';

class GlobalSearchTabHelper {
  GlobalSearchTabHelper._();

  static String getTabTitle(GlobalSearchTabType tab) {
    switch (tab) {
      case GlobalSearchTabType.unread:
        return 'Непрочитанное';
      case GlobalSearchTabType.photo:
        return 'Фото';
      case GlobalSearchTabType.video:
        return 'Видео';
      case GlobalSearchTabType.links:
        return 'Ссылки';
      case GlobalSearchTabType.gif:
        return 'GIF';
      case GlobalSearchTabType.audio:
        return 'Аудио';
      case GlobalSearchTabType.documents:
        return 'Документы';
      case GlobalSearchTabType.stickers:
        return 'Стикеры';
      case GlobalSearchTabType.survey:
        return 'Опросы';
      case GlobalSearchTabType.contacts:
        return 'Контакты';
      case GlobalSearchTabType.groups:
        return 'Группы';
      case GlobalSearchTabType.communities:
        return 'Сообщества';
      case GlobalSearchTabType.channels:
        return 'Каналы';
      case GlobalSearchTabType.bots:
        return 'Боты';
    }
  }

  static Widget getTabIcon(GlobalSearchTabType tab, Color color) {
    switch (tab) {
      case GlobalSearchTabType.unread:
        return SvgPicture.asset(ChatifyVectors.messageUnreadOutline, width: 20, height: 20, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
      case GlobalSearchTabType.photo:
        return Icon(Icons.image_outlined, size: 20, color: color);
      case GlobalSearchTabType.video:
        return Icon(Icons.videocam_outlined, size: 22, color: color);
      case GlobalSearchTabType.links:
        return Icon(Icons.link_rounded, size: 22, color: color);
      case GlobalSearchTabType.gif:
        return Icon(Icons.gif, size: 28, color: color);
      case GlobalSearchTabType.audio:
        return Icon(Icons.headphones_outlined, size: 20, color: color);
      case GlobalSearchTabType.documents:
        return SvgPicture.asset(ChatifyVectors.documentOutline, width: 20, height: 20, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
      case GlobalSearchTabType.stickers:
        return SvgPicture.asset(ChatifyVectors.sticker, width: 22, height: 22, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
      case GlobalSearchTabType.survey:
        return SvgPicture.asset(ChatifyVectors.surveyFilled, width: 18, height: 18, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
      case GlobalSearchTabType.contacts:
        return Icon(Icons.person_outline, size: 20, color: color);
      case GlobalSearchTabType.groups:
        return Icon(Icons.group_outlined, size: 22, color: color);
      case GlobalSearchTabType.communities:
        return Icon(Icons.groups_outlined, size: 22, color: color);
      case GlobalSearchTabType.channels:
        return SvgPicture.asset(ChatifyVectors.updatesOutline, width: 22, height: 22, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
      case GlobalSearchTabType.bots:
        return SvgPicture.asset(ChatifyVectors.bot, width: 18, height: 18, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
    }
  }
}
