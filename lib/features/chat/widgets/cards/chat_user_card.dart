import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../common/enums/date_format_type.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../home/widgets/dialogs/edit_settings_chat_dialog.dart';
import '../../../home/widgets/dialogs/profile_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_model.dart';
import '../../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel user;
  final ValueChanged<UserModel> onUserSelected;
  final bool isSelected;

  const ChatUserCard({
    super.key,
    required this.user,
    required this.onUserSelected,
    required this.isSelected,
  });

  @override
  State<ChatUserCard> createState() => ChatUserCardState();
}

class ChatUserCardState extends State<ChatUserCard> {
  MessageModel? message;
  bool isSelected = false;
  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: isWindows ? 16 : 8, right: isWindows ? 15 : 8, bottom: 6),
      elevation: isWindows ? widget.isSelected ? 2 : 0.5 : isSelected ? 2 : 0.5,
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
            setState(() {
              isSelected = !isSelected;
            });
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
              : isSelected
                ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground,
          ),
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (isWindows) {
                widget.onUserSelected(widget.user);
              } else {
                Navigator.push(context, createPageRoute(ChatScreen(user: widget.user)));
              }
            },
            splashFactory: NoSplash.splashFactory,
            splashColor: ChatifyColors.transparent,
            highlightColor: ChatifyColors.transparent,
            hoverColor: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

                if (list.isNotEmpty && (message == null || message!.toId != list[0].toId)) {
                  message = list[0];
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              if (!isWindows) {
                                showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user));
                              }
                            },
                            mouseCursor: SystemMouseCursors.basic,
                            borderRadius: BorderRadius.circular(30),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                width: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                                height: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                                imageUrl: widget.user.image,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  child: SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                                ),
                              ),
                            ),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${widget.user.name}${widget.user.surname.isNotEmpty ? ' ${widget.user.surname}' : ''}',
                                    style: TextStyle(fontSize: isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, fontFamily: 'Helvetica', fontWeight: isWindows ? FontWeight.w400 : FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 6),
                                if (message != null) ...[
                                  Text(
                                    DateUtil.getLastMessageTime(
                                      context: context,
                                      time: DateTime.fromMillisecondsSinceEpoch(int.parse(message!.sent)),
                                      formatType: DateFormatType.numeric
                                    ),
                                    style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: isWindows ? context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            message != null && message!.msg.isNotEmpty
                                ? Row(
                              children: [
                                if (message!.type == Type.gif) ...[
                                  HeroIcon(HeroIcons.gif, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, size: 20),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      S.of(context).gif,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                                    ),
                                  ),
                                ] else if (message!.type == Type.image) ...[
                                  Icon(Icons.image, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      S.of(context).photo,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                                    ),
                                  ),
                                ] else if (message!.type == Type.video) ...[
                                  Icon(Icons.videocam, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      S.of(context).video,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary,
                                        fontSize: ChatifySizes.fontSizeSm,
                                      ),
                                    ),
                                  ),
                                ] else if (message!.type == Type.audio) ...[
                                  Icon(Icons.audiotrack, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      S.of(context).audio,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                                    ),
                                  ),
                                ] else if (message!.type == Type.document) ...[
                                  Icon(FluentIcons.document_16_filled, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      message!.documentName ?? S.of(context).unknownDocument,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                                    ),
                                  ),
                                ] else ...[
                                  Flexible(
                                    child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: SvgPicture.asset(
                                              ChatifyVectors.doubleCheck,
                                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                              width: 18,
                                              height: 18,
                                            ),
                                          ),
                                          const WidgetSpan(child: SizedBox(width: 4)),
                                          TextSpan(
                                            text: message!.msg,
                                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontWeight: FontWeight.w400, fontSize: ChatifySizes.fontSizeSm, fontFamily: 'Roboto'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            )
                            : Text(widget.user.about, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
