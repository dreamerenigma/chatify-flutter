import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../chat/models/user_model.dart';

class UserAvatarImage extends StatelessWidget {
  final UserModel user;
  final double radius;

  const UserAvatarImage({
    super.key,
    required this.user,
    this.radius = 27,
  });

  @override
  Widget build(BuildContext context) {
    final image = user.image.trim();

    if (image.isEmpty || image == 'null') {
      return _buildAvatarPlaceholder();
    }

    return FutureBuilder<String?>(
      future: APIs.getMediaUrl(image),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildAvatarPlaceholder();
        }

        final imageUrl = snapshot.data;

        if (imageUrl == null || imageUrl.isEmpty) {
          return _buildAvatarPlaceholder();
        }

        return CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(radius: radius, backgroundImage: imageProvider);
          },
          placeholder: (context, url) {
            return _buildAvatarPlaceholder();
          },
          errorWidget: (context, url, error) {
            return _buildAvatarPlaceholder();
          },
        );
      },
    );
  }

  Widget _buildAvatarPlaceholder() {
    return CircleAvatar(
      backgroundColor: ChatifyColors.blackGrey,
      radius: radius, child: ClipOval(child: SvgPicture.asset(ChatifyVectors.profile, width: radius * 2, height: radius * 2, fit: BoxFit.cover),
      ),
    );
  }
}
