import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../home/widgets/dialogs/edit_settings_chat_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/support_info_screen.dart';

class SupportCard extends StatefulWidget {
  final SupportAppModel support;
  final ValueChanged<SupportAppModel> onSupportSelected;
  final bool isSelected;

  const SupportCard({
    super.key,
    required this.support,
    required this.isSelected,
    required this.onSupportSelected,
  });

  @override
  State<SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<SupportCard> {
  bool isLongPressed = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: isWindows ? 16 : 8, right: isWindows ? 15 : 8),
      elevation: isWindows ? widget.isSelected ? 2 : 0.5 : widget.isSelected ? 2 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: GestureDetector(
        onSecondaryTapDown: (details) {
          if (isWindows) {
            Future.delayed(Duration(milliseconds: 100), () {
              showEditSettingsChatDialog(context, details.globalPosition);
            });
          }
        },
        onLongPress: () {
          if (isWindows) {
            setState(() {
              isLongPressed = true;
            });
          } else {
            widget.onSupportSelected(widget.support);
          }
        },
        onLongPressUp: () {
          if (isWindows) {
            setState(() {
              isLongPressed = false;
            });
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isWindows
              ? isLongPressed || widget.isSelected
                ? context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground
              : widget.isSelected
                ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground,
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (isWindows) {
                widget.onSupportSelected(widget.support);
              } else {
                Navigator.push(context, createPageRoute(SupportInfoScreen()));
              }
            },
            splashFactory: NoSplash.splashFactory,
            splashColor: ChatifyColors.transparent,
            highlightColor: ChatifyColors.transparent,
            hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        child: SvgPicture.asset(ChatifyVectors.logoApp, color: ChatifyColors.white, width: 28, height: 28),
                      ),
                      if (!isWindows && isSelected)
                      Positioned(
                        bottom: -3,
                        right: -2,
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.check, color: ChatifyColors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    widget.support.name,
                                    style: TextStyle(
                                      fontSize: isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd,
                                      fontFamily: 'Helvetica',
                                      fontWeight: isWindows ? FontWeight.w400 : FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.support.surname,
                                    style: TextStyle(
                                      fontSize: isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd,
                                      fontFamily: 'Helvetica',
                                      fontWeight: isWindows ? FontWeight.w400 : FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              DateUtil.getCommunityCreationDate(context: context, creationDate: widget.support.createdAt, includeTime: true),
                              style: TextStyle(
                                fontSize: ChatifySizes.fontSizeLm,
                                color: isWindows ? context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (widget.support.lastMessage != null && widget.support.lastMessage!.isNotEmpty)
                        Text(
                          widget.support.lastMessage!,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
