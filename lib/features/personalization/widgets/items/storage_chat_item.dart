import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../api/apis.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/widgets/shimmers/shimmer_effect.dart';

class StorageChatItem extends StatelessWidget {
  final UserModel user;
  final String storageSize;

  const StorageChatItem({
    super.key,
    required this.user,
    required this.storageSize,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = DeviceUtils.getScreenHeight(context) * .055;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          ClipOval(
            child: FutureBuilder<String?>(
              future: APIs.getMediaUrl(user.image),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerEffect(width: avatarSize, height: avatarSize, borderRadius: avatarSize, angle: -0.16);
                }

                final url = snapshot.data;

                if (url == null || url.isEmpty) {
                  return _buildAvatarPlaceholder(context, avatarSize);
                }

                return CachedNetworkImage(
                  width: avatarSize,
                  height: avatarSize,
                  imageUrl: url,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return _buildAvatarPlaceholder(context, avatarSize);
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '${user.name} ${user.surname}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: SvgPicture.asset(ChatifyVectors.profile, width: size, height: size),
    );
  }
}
