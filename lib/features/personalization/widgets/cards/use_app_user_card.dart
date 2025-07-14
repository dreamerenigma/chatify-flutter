import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../home/widgets/dialogs/profile_dialog.dart';
import '../dialogs/light_dialog.dart';

class UseAppUserCard extends StatefulWidget {
  final UserModel user;
  final bool isSelected;
  final Function(UserModel)? onUserSelected;
  final Function()? onTap;
  final Function(UserModel)? onLongPress;
  final EdgeInsetsGeometry? margin;

  const UseAppUserCard({
    super.key,
    required this.user,
    this.isSelected = false,
    this.onUserSelected,
    this.onTap,
    this.onLongPress,
    this.margin,
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

    return Card(
      margin: widget.margin ?? EdgeInsets.only(left: Platform.isWindows ? 16 : 8, right: Platform.isWindows ? 15 : 8, top: 8, bottom: 8),
      elevation: widget.isSelected ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: widget.isSelected ? Colors.blue.withAlpha((0.1 * 255).toInt()) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: _handleTap,
        onLongPress: _handleLongPress,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : context.isDarkMode
              ? ChatifyColors.cardColor
              : ChatifyColors.grey,
          ),
          child: ListTile(
            leading: Stack(
              alignment: Alignment.centerRight,
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ProfileDialog(user: widget.user),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .03),
                    child: CachedNetworkImage(
                      width: DeviceUtils.getScreenHeight(context) * .055,
                      height: DeviceUtils.getScreenHeight(context) * .055,
                      imageUrl: widget.user.image,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                      CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                      ),
                    ),
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
                      border: Border.all(
                        color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            title: Text(widget.user.name),
            subtitle: const Text('Привет! Я использую Chatify.'),
          ),
        ),
      ),
    );
  }
}
