import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/avatar_color_util.dart';
import '../../../chat/models/user_model.dart';
import '../../../home/widgets/dialogs/profile_dialog.dart';
import '../dialogs/light_dialog.dart';

class UseAppUserCard extends StatefulWidget {
  final UserModel user;
  final bool isSelected;
  final EdgeInsetsGeometry? margin;
  final Color? avatarBackgroundColor;
  final Color? avatarIconColor;
  final Function(UserModel)? onUserSelected;
  final Function()? onTap;
  final Function(UserModel)? onLongPress;

  const UseAppUserCard({
    super.key,
    required this.user,
    this.isSelected = false,
    this.onUserSelected,
    this.onTap,
    this.onLongPress,
    this.margin,
    this.avatarBackgroundColor,
    this.avatarIconColor,
  });

  @override
  State<UseAppUserCard> createState() => UseAppUserCardState();
}

class UseAppUserCardState extends State<UseAppUserCard> {


  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else if (widget.onUserSelected != null) {
      setState(() {
        widget.onUserSelected!(widget.user);
      });
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress != null) {
      widget.onLongPress!(widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.user.image.isNotEmpty && widget.user.image != 'null';

    return Card(
      margin: widget.margin ?? EdgeInsets.only(left: Platform.isWindows ? 16 : 8, right: Platform.isWindows ? 15 : 8, top: 8),
      elevation: widget.isSelected ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: widget.isSelected ? Colors.blue.withAlpha((0.1 * 255).toInt()) : null,
      child: InkWell(
        onTap: _handleTap,
        onLongPress: _handleLongPress,
        borderRadius: BorderRadius.circular(15),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey,
          ),
          child: ListTile(
            leading: Stack(
              alignment: Alignment.centerRight,
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user));
                  },
                  borderRadius: BorderRadius.circular(30),
                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .03),
                    child: hasImage
                      ? CachedNetworkImage(
                          width: DeviceUtils.getScreenHeight(context) * .055,
                          height: DeviceUtils.getScreenHeight(context) * .055,
                          imageUrl: widget.user.image,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return _buildAvatarPlaceholder(context);
                          },
                        )
                      : _buildAvatarPlaceholder(context),
                  ),
                ),
                if (widget.isSelected)
                Positioned(
                  bottom: -3,
                  right: -2,
                  child: Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.check, color: ChatifyColors.white, size: 16),
                  ),
                ),
              ],
            ),
            title: Text('${widget.user.name} ${widget.user.surname}', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
            subtitle: Text(S.of(context).aboutText),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context) {
    final avatarColors = AvatarColorUtil.get(widget.user.id);

    return Container(
      width: DeviceUtils.getScreenHeight(context) * .055,
      height: DeviceUtils.getScreenHeight(context) * .055,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: avatarColors.background, shape: BoxShape.circle),
      child: SvgPicture.asset(ChatifyVectors.person, width: 21, height: 21, fit: BoxFit.contain, colorFilter: ColorFilter.mode(avatarColors.icon, BlendMode.srcIn)),
    );
  }
}
