import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../../generated/l10n/l10n.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../utils/constants/app_vectors.dart';
import '../../../../../chat/models/user_model.dart';
import '../../../../../personalization/controllers/user_controller.dart';
import '../../../../../personalization/widgets/dialogs/light_dialog.dart';

class UserProfileTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
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
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.transparent, width: 1),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
                    errorWidget: (context, url, error) => Center(
                      child: SvgPicture.asset(
                        ChatifyVectors.newUser,
                        color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.iconGrey,
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.phoneNumber} ${S.of(context).youCall}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, fontFamily: 'Roboto')),
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
