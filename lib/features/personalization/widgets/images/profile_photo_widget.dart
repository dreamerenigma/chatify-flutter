import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/enums/snack_bar_position_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/app_loaders.dart';
import '../../../chat/models/user_model.dart';
import '../dialogs/light_dialog.dart';

class ProfilePhotoWidget extends StatefulWidget {
  final UserModel user;
  final double size;
  final VoidCallback onTap;

  const ProfilePhotoWidget({
    super.key,
    required this.user,
    required this.size,
    required this.onTap,
  });

  @override
  State<ProfilePhotoWidget> createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  bool _isLoaded = false;

  @override
  void didUpdateWidget(covariant ProfilePhotoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.user.image != widget.user.image) {
      _isLoaded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isLoaded) {
          CustomIconSnackBar.showAnimatedSnackBar(
            context,
            'Нет фото профиля',
            icon: const Icon(Icons.warning_amber_rounded, size: 26),
            iconColor: ChatifyColors.yellow,
            position: SnackBarPositionType.bottom
          );

          return;
        }

        widget.onTap();
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.height * .15,
            height: MediaQuery.of(context).size.height * .15,
            fit: BoxFit.cover,
            imageUrl: widget.user.image,
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              foregroundColor: ChatifyColors.white,
              child: SvgPicture.asset(ChatifyVectors.profile, width: MediaQuery.of(context).size.height * .15, height: MediaQuery.of(context).size.height * .15),
            ),
          ),
        ),
      ),
    );
  }
}