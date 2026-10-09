import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

class FullScreenAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserModel user;
  final MessageModel message;

  const FullScreenAppBar({
    super.key,
    required this.user,
    required this.message,
  });

  @override
  FullScreenAppBarState createState() => FullScreenAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FullScreenAppBarState extends State<FullScreenAppBar> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: ChatifyColors.nightGrey.withValues(alpha: 0.5),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            APIs.me.id == widget.user.id ? 'Вы' : widget.user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: ChatifyColors.white, fontSize: 15, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 2),
          Text(
            DateUtil.getEventDateTimeShort(context: context, timestamp: widget.message.sent),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: ChatifyColors.borderSecondary, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, size: 25, color: ChatifyColors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.file_download_outlined, size: 25, color: ChatifyColors.white),
          onPressed: () {
            setState(() {
              isFavorited = !isFavorited;
            });
          },
        ),
        SizedBox(width: 8),
        SvgPicture.asset(ChatifyVectors.arrowBendDoubleUpRight, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
        SizedBox(width: 18),
        SvgPicture.asset(ChatifyVectors.statusAdd, width: 27, height: 27, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
        TooltipTheme(
          data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
          child: Theme(
            data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
            child: PopupMenuButton<int>(
              tooltip: S.of(context).more,
              position: PopupMenuPosition.under,
              offset: const Offset(-8, 0),
              menuPadding: const EdgeInsets.symmetric(vertical: 4),
              constraints: const BoxConstraints(minWidth: 0, maxWidth: 200),
              icon: const Icon(Icons.more_vert),
              color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                PopupMenuItem(
                  value: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    icon: Icon(Icons.edit_outlined, size: 23, color: ChatifyColors.darkGrey),
                    text: S.of(context).change,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    icon: Icon(Icons.share_outlined, size: 23, color: ChatifyColors.darkGrey),
                    text: S.of(context).share,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    icon: Icon(Icons.star_border_rounded, size: 23, color: ChatifyColors.darkGrey),
                    text: 'В Избранное',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    icon: SvgPicture.asset(ChatifyVectors.messageOutline, width: 23, height: 23, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                    text: S.of(context).showInChat,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 5,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    icon: SvgPicture.asset(ChatifyVectors.sticker, width: 23, height: 23, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                    text: 'Создать стикер',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  enabled: false,
                  padding: EdgeInsets.zero,
                  height: 0,
                  child: CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 2, bottom: 2, color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.buttonDisabled),
                ),
                PopupMenuItem(
                  value: 6,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    icon: Icon(FluentIcons.delete_24_regular, size: 23, color: ChatifyColors.darkGrey),
                    text: S.of(context).delete,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  enabled: false,
                  padding: EdgeInsets.zero,
                  height: 0,
                  child: CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 2, bottom: 2, color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.buttonDisabled),
                ),
                PopupMenuItem(
                  value: 7,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).more,
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
    );
  }
}
