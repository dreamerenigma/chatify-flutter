import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/event_model.dart';
import '../../models/user_model.dart';

class EventMessageCard extends StatefulWidget {
  final UserModel user;
  final EventModel event;
  final UserModel ownerId;

  const EventMessageCard({
    super.key,
    required this.user,
    required this.event,
    required this.ownerId,
  });

  @override
  State<EventMessageCard> createState() => _EventMessageCardState();
}

class _EventMessageCardState extends State<EventMessageCard> {
  bool isLoadingProfileImage = false;
  String? profileImageUrl;

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
        isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        profileImageUrl = url;
        isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        profileImageUrl = null;
        isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final startDate = widget.event.startEvent.toDate();
    final endDate = widget.event.endEvent.toDate();
    final startText = DateFormat('d MMM y, HH:mm', 'ru').format(startDate);
    final endText = DateFormat('HH:mm', 'ru').format(endDate);
    final callTypeText = widget.event.callType == 'video' ? 'Видеозвонок' : 'Аудиозвонок';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary.withAlpha(25)),
              child: Icon(Icons.calendar_month_outlined, size: 22, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  if (widget.event.description.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(widget.event.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.schedule_rounded, size: 18, color: ChatifyColors.darkGrey),
                      const SizedBox(width: 7),
                      Expanded(child: Text('$startText, $endText', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  if (widget.event.location.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 20, color: ChatifyColors.darkGrey),
                        const SizedBox(width: 7),
                        Expanded(child: Text(widget.event.location, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
                      ],
                    ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(widget.event.callType == 'video' ? Icons.videocam_outlined : Icons.call_outlined, size: 20, color: ChatifyColors.darkGrey),
                      const SizedBox(width: 7),
                      Text('$callTypeText Chatify', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        clipBehavior: Clip.antiAlias,
                        child: _buildOwnerAvatar(),
                      ),
                      const SizedBox(width: 9),
                      Expanded(child: Text('Идут: 1', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOwnerAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .02),
      child: CachedNetworkImage(
        width: DeviceUtils.getScreenHeight(context) * .02,
        height: DeviceUtils.getScreenHeight(context) * .02,
        imageUrl: profileImageUrl ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey),
        errorWidget: (context, url, error) {
          return CircleAvatar(
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .02, height: DeviceUtils.getScreenHeight(context) * .02),
          );
        },
      ),
    );
  }
}
