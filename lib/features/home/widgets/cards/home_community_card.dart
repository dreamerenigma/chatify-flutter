import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/helper/date_util.dart';
import 'package:flutter/material.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../app.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../community/screens/community_info_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialogs/edit_settings_chat_dialog.dart';

class HomeCommunityCard extends StatefulWidget {
  final CommunityModel community;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isValidDate;
  final String fileToSend;
  final ValueChanged<CommunityModel> onCommunitySelected;

  const HomeCommunityCard({
    super.key,
    this.onTap,
    required this.community,
    required this.isValidDate,
    required this.fileToSend,
    required this.onCommunitySelected,
    required this.isSelected,
  });

  @override
  State<HomeCommunityCard> createState() => _HomeCommunityCardState();
}

class _HomeCommunityCardState extends State<HomeCommunityCard> {
  bool isLongPressed = false;

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
            widget.onCommunitySelected(widget.community);
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
                widget.onCommunitySelected(widget.community);
              } else {
                Navigator.push(
                  context,
                  createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: (date) => widget.isValidDate, fileToSend: widget.fileToSend)),
                );
              }
            },
            splashFactory: NoSplash.splashFactory,
            splashColor: ChatifyColors.transparent,
            highlightColor: ChatifyColors.transparent,
            hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      width: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                      height: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                      imageUrl: widget.community.image,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) => CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                        child: SvgPicture.asset(ChatifyVectors.communityUsers, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                      ),
                    ),
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
                              child: Text(
                                widget.community.name.isNotEmpty ? widget.community.name : S.of(context).unknownCommunity,
                                style: TextStyle(
                                  fontSize: isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd,
                                  fontFamily: 'Helvetica',
                                  fontWeight: isWindows ? FontWeight.w400 : FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            isWindows
                          ? Text(
                              DateUtil.getCommunityCreationDate(context: context, creationDate: widget.community.createdAt, includeTime: true),
                              style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: isWindows ? context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
                            )
                          : Icon(Icons.arrow_forward_ios_rounded, size: 16, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Icon(Icons.check, size: 18, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
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
