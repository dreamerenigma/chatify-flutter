import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../home/widgets/dialogs/profile_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/recent_call_model.dart';

class RecentCallCard extends StatefulWidget {
  final RecentCallModel call;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const RecentCallCard({
    super.key,
    required this.call,
    this.selectionMode = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<RecentCallCard> createState() => _RecentCallCardState();
}

class _RecentCallCardState extends State<RecentCallCard> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Material(
      color: widget.isSelected ? primaryColor.withAlpha((0.3 * 255).toInt()) : ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 6, top: 10, bottom: 10),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {
                          showDialog(context: context, builder: (_) => ProfileDialog(user: widget.call.user));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .03),
                          child: widget.call.user.image.isNotEmpty
                            ? CachedNetworkImage(
                                width: DeviceUtils.getScreenHeight(context) * .055,
                                height: DeviceUtils.getScreenHeight(context) * .055,
                                imageUrl: widget.call.user.image,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return _buildAvatarPlaceholder(context);
                                },
                              )
                            : _buildAvatarPlaceholder(context),
                        ),
                      ),
                      if (widget.selectionMode && widget.isSelected)
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
                            child: const Icon(Icons.check, color: ChatifyColors.black, size: 17),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.call.user.name} ${widget.call.user.surname}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: widget.call.isMissed ? ChatifyColors.danger : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              widget.call.isIncoming ? Icons.call_received_rounded : Icons.call_made_rounded,
                              size: 16,
                              color: widget.call.isMissed ? ChatifyColors.danger : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                DateUtil.getCallDateTime(context: context, time: widget.call.time),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: ChatifyColors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () {
                        Navigator.push(context, createPageRoute(OutgoingAudioCallScreen(user: widget.call.user)));
                      },
                      child: const SizedBox(width: 48, height: 48, child: Center(child: Icon(Icons.call_outlined, size: 26))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context) {
    return Container(
      width: DeviceUtils.getScreenHeight(context) * .055,
      height: DeviceUtils.getScreenHeight(context) * .055,
      alignment: Alignment.center,
      child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .055, height: DeviceUtils.getScreenHeight(context) * .055, fit: BoxFit.contain),
    );
  }
}
