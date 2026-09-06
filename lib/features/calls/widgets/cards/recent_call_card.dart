import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/avatar_color_util.dart';
import '../../../../utils/helper/date_util.dart';
import '../../models/recent_call_model.dart';

class RecentCallCard extends StatefulWidget {
  final RecentCallModel call;
  final VoidCallback? onTap;

  const RecentCallCard({
    super.key,
    required this.call,
    this.onTap,
  });

  @override
  State<RecentCallCard> createState() => _RecentCallCardState();
}

class _RecentCallCardState extends State<RecentCallCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                onTap: () {},
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.call.user.name,
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
              Icon(Icons.call_outlined, size: 26, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context) {
    final avatarColors = AvatarColorUtil.get(widget.call.user.id);

    return Container(
      width: DeviceUtils.getScreenHeight(context) * .055,
      height: DeviceUtils.getScreenHeight(context) * .055,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: avatarColors.background, shape: BoxShape.circle),
      child: SvgPicture.asset(ChatifyVectors.person, width: 21, height: 21, fit: BoxFit.contain, colorFilter: ColorFilter.mode(avatarColors.icon, BlendMode.srcIn)),
    );
  }
}
