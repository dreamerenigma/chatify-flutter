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

class EventParticipantItem extends StatelessWidget {
  final UserModel user;
  final EventModel event;

  const EventParticipantItem({
    super.key,
    required this.user,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOrganizer = user.id == event.ownerId;

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
                Text(
                  APIs.me.id == user.id ? 'Вы' : user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                ),
                Text(
                  DateUtil.getEventDateTimeShort(context: context, timestamp: event.createdAt),
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isOrganizer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
              child: Text('Организатор', style: TextStyle(color: ChatifyColors.blue, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: user.image.isNotEmpty
          ? SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40, fit: BoxFit.cover)
          : Container(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightGrey, child: Icon(Icons.person, size: 22)),
      ),
    );
  }
}
