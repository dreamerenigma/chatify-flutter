import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/models/user_status_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/user_status_screen.dart';
import '../../screens/view_status_screen.dart';
import '../dialogs/add_status_bottom_dialog.dart';

class StatusHeaderWidget extends StatefulWidget {
  final UserModel user;
  final UserStatusModel? userStatus;
  final String? statusImageUrl;
  final String? profileImageUrl;
  final VoidCallback onAddStatus;

  const StatusHeaderWidget({
    super.key,
    required this.user,
    required this.userStatus,
    required this.statusImageUrl,
    required this.profileImageUrl,
    required this.onAddStatus,
  });

  @override
  State<StatusHeaderWidget> createState() => _StatusHeaderWidgetState();
}

class _StatusHeaderWidgetState extends State<StatusHeaderWidget> {

  @override
  Widget build(BuildContext context) {
    final hasStatus = widget.userStatus != null;
    final imageUrl = widget.statusImageUrl?.trim().isNotEmpty == true ? widget.statusImageUrl!.trim() : widget.profileImageUrl;

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () async {
          if (widget.userStatus != null) {
            await Navigator.push(context, createPageRoute(ViewStatusScreen(imageUrl: widget.statusImageUrl!, user: widget.user, status: widget.userStatus!)));

            if (!mounted) return;

            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: ChatifyColors.transparent, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light));
          } else {
            showAddStatusBottomDialog(context, widget.user);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.centerRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: hasStatus ? const EdgeInsets.all(2) : EdgeInsets.zero, decoration: hasStatus
                      ? BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1.5))
                      : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .5),
                      child: CachedNetworkImage(
                        width: DeviceUtils.getScreenHeight(context) * .062,
                        height: DeviceUtils.getScreenHeight(context) * .062,
                        imageUrl: imageUrl ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Container(
                            color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              ChatifyVectors.person,
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, BlendMode.srcIn),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                            width: DeviceUtils.getScreenHeight(context) * .062,
                            height: DeviceUtils.getScreenHeight(context) * .062,
                            color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              ChatifyVectors.person,
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, BlendMode.srcIn),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (widget.userStatus == null)
                    Positioned(
                      bottom: -3,
                      right: -5,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          splashFactory: NoSplash.splashFactory,
                          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          onTap: () {},
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                              border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                            ),
                            child: const Icon(Icons.add, color: ChatifyColors.black, size: 18),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userStatus != null ? 'Статус' : S.of(context).addStatus, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                    Text(
                      widget.userStatus != null ? DateUtil.formatStatusTime(widget.userStatus!.createdAt) : widget.user.status.isNotEmpty ? widget.user.status : S.of(context).addNewStatus,
                      style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.5),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              if (widget.userStatus != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () {
                        Navigator.push(context, createPageRoute(UserStatusScreen(user: widget.user, statusImageUrl: widget.statusImageUrl)));
                      },
                      child: const Icon(Icons.more_horiz, size: 28, color: ChatifyColors.darkGrey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
