import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../models/event_model.dart';
import '../../models/user_model.dart';

class EventMessageCard extends StatelessWidget {
  final EventModel event;
  final UserModel ownerId;

  const EventMessageCard({
    super.key,
    required this.event,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    final startDate = event.startEvent.toDate();
    final endDate = event.endEvent.toDate();
    final startText = DateFormat('d MMM y, HH:mm', 'ru').format(startDate);
    final endText = DateFormat('HH:mm', 'ru',).format(endDate);
    final callTypeText = event.callType == 'video' ? 'Видеозвонок' : 'Аудиозвонок';

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
                  Text(
                    event.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
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
                  if (event.location.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 20, color: ChatifyColors.darkGrey),
                        const SizedBox(width: 7),
                        Expanded(child: Text(event.location, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
                      ],
                    ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(event.callType == 'video' ? Icons.videocam_outlined : Icons.call_outlined, size: 20, color: ChatifyColors.darkGrey),
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
    return Image.network(
      ownerId.image,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return ColoredBox(
          color: ChatifyColors.grey,
          child: SvgPicture.asset(ChatifyVectors.profile, width: 18, height: 18),
        );
      },
    );
  }
}
