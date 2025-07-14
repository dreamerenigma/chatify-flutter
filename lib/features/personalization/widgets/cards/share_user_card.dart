import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../home/widgets/dialogs/profile_dialog.dart';
import '../dialogs/light_dialog.dart';

class ShareUserCard extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUserSelected;

  const ShareUserCard({super.key, required this.user, required this.onUserSelected});

  @override
  State<ShareUserCard> createState() => ShareUserCardState();
}

class ShareUserCardState extends State<ShareUserCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: Platform.isWindows ? 16 : 8, right: Platform.isWindows ? 15 : 8, top: 8, bottom: 8),
      elevation: isSelected ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isSelected ? Colors.blue.withAlpha((0.1 * 255).toInt()) : null,
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            isSelected = !isSelected;
            if (isSelected) {
              widget.onUserSelected(widget.user);
            }
          });
        },
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: context.isDarkMode ? ChatifyColors.cardColor : ChatifyColors.grey),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              setState(() {
                isSelected = !isSelected;
                if (isSelected) {
                  widget.onUserSelected(widget.user);
                }
              });
            },
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                return ListTile(
                  leading: Stack(
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
                              CircleAvatar(backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value), foregroundColor: ChatifyColors.white, child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        ),
                    ],
                  ),
                  title: Text(widget.user.name),
                  subtitle: Text(widget.user.status),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
