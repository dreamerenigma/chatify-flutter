import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:chatify/utils/helper/avatar_color_util.dart';
import 'package:chatify/utils/helper/date_util.dart';
import 'package:chatify/utils/devices/device_utility.dart';
import 'package:chatify/generated/l10n/l10n.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../models/user_model.dart';
import '../dialogs/chat_settings_dialog.dart';

class UserInfoWidget extends StatelessWidget {
  final UserModel user;
  final bool showStatusText;

  const UserInfoWidget({
    super.key,
    required this.user,
    required this.showStatusText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.basic,
      splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(8),
      splashColor: ChatifyColors.transparent,
      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
      onTap: () {
        if (Platform.isWindows) {
          final renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);

          showChatSettingsDialog(context, user, position, initialIndex: 0);
        } else {
          Navigator.push(context, createPageRoute(ViewProfileScreen(user: user)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(context),
            SizedBox(width: Platform.isWindows ? 14 : 10),
            Flexible(child: _buildUserText(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarColors = AvatarColorUtil.get(user.id);

    return ClipRRect(
      borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .04),
      child: CachedNetworkImage(
        width: 40,
        height: 40,
        imageUrl: user.image,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Container(width: 40, height: 40, color: ChatifyColors.blackGrey);
        },
        errorWidget: (context, url, error) {
          return Container(
            width: 40,
            height: 40,
            color: avatarColors.background,
            alignment: Alignment.center,
            child: SvgPicture.asset(ChatifyVectors.person, width: 19, height: 19, colorFilter: ColorFilter.mode(avatarColors.icon, BlendMode.srcIn)),
          );
        },
      ),
    );
  }

  Widget _buildUserText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${user.name}${user.surname.isNotEmpty ? ' ${user.surname}' : ''}',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeLg, fontFamily: 'Roboto', fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400),
        ),
        const SizedBox(height: 2),
        _buildStatus(context),
      ],
    );
  }

  Widget _buildStatus(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: APIs.firestore.collection('Users').doc(user.id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final isTyping = userData['is_typing'] ?? false;
        final isOnline = userData['is_online'] ?? false;
        final lastActiveText = _getLastActiveText(context, userData['last_active']);

        return SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedOpacity(
                opacity: showStatusText ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInCubic,
                child: Text(
                  S.of(context).contactDetails,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              AnimatedOpacity(
                opacity: showStatusText ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInCubic,
                child: Text(
                  isTyping ? S.of(context).printing : isOnline ? S.of(context).online : lastActiveText,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getLastActiveText(BuildContext context, dynamic lastActive) {
    if (lastActive is Timestamp) {
      return DateUtil.getLastActiveTime(context: context, lastActive: lastActive, addWasPrefix: true);
    }

    if (lastActive is String) {
      final millis = int.tryParse(lastActive);

      if (millis != null) {
        final timestamp = Timestamp.fromMillisecondsSinceEpoch(millis);

        return DateUtil.getLastActiveTime(context: context, lastActive: timestamp, addWasPrefix: true);
      }
    }

    return S.of(context).lastSeenNotAvailable;
  }
}
