import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../../api/apis.dart';
import '../../../../../../generated/l10n/l10n.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../utils/constants/app_vectors.dart';
import '../../../../../../utils/devices/device_utility.dart';
import '../../../../../chat/models/user_model.dart';
import '../../../../../personalization/controllers/user_controller.dart';
import '../../../../../personalization/widgets/dialogs/light_dialog.dart';

class UserProfileTile extends StatefulWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final UserController userController;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final double? subtitleFontSize;
  final FontWeight? subtitleFontWeight;

  const UserProfileTile({
    super.key,
    this.onTap,
    this.titleFontSize,
    this.titleFontWeight,
    this.subtitleFontSize,
    this.subtitleFontWeight,
    required this.user,
    required this.userController,
  });

  @override
  State<UserProfileTile> createState() => _UserProfileTileState();
}

class _UserProfileTileState extends State<UserProfileTile> {
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
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        mouseCursor: SystemMouseCursors.basic,
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.transparent, width: 1), shape: BoxShape.circle),
                child: ClipOval(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .2),
                    child: CachedNetworkImage(
                      width: DeviceUtils.getScreenHeight(context) * .27,
                      height: DeviceUtils.getScreenHeight(context) * .27,
                      imageUrl: _profileImageUrl ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        foregroundColor: ChatifyColors.white,
                        child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .27, height: DeviceUtils.getScreenHeight(context) * .27),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.user.phoneNumber} ${S.of(context).youCall}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, fontFamily: 'Roboto')),
                  Text(S.of(context).messageMyself, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.mildNight, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, fontFamily: 'Roboto')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
