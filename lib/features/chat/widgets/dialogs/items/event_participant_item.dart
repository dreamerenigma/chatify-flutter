import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/helper/date_util.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../models/event_model.dart';
import '../../../models/user_model.dart';

class EventParticipantItem extends StatefulWidget {
  final UserModel user;
  final EventModel event;

  const EventParticipantItem({
    super.key,
    required this.user,
    required this.event,
  });

  @override
  State<EventParticipantItem> createState() => _EventParticipantItemState();
}

class _EventParticipantItemState extends State<EventParticipantItem> {
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOrganizer = widget.user.id == widget.event.ownerId;
    final Color themeColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        APIs.me.id == widget.user.id ? 'Вы' : widget.user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                          fontSize: ChatifySizes.fontSizeMd,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ),
                    if (isOrganizer) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: themeColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                        child: Text('Организатор', style: TextStyle(color: themeColor, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ],
                ),
                Text(
                  DateUtil.getEventDateTimeShort(context: context, timestamp: widget.event.createdAt),
                  style: TextStyle(
                    color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.w400,
                    height: 1.3
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final bool hasImage = _profileImageUrl != null && _profileImageUrl!.isNotEmpty;

    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: _isLoadingProfileImage
          ? Container(
              color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightGrey,
              child: const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          : hasImage
            ? CachedNetworkImage(
                imageUrl: _profileImageUrl!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightGrey),
                errorWidget: (context, url, error) {
                  return SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40, fit: BoxFit.cover);
                },
              )
            : SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40, fit: BoxFit.cover),
      ),
    );
  }
}
