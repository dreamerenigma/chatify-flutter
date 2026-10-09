import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/tooltip_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../infos/private_messages_protected_notice.dart';

class StatusWidget extends StatefulWidget {
  final UserModel user;

  const StatusWidget({
    super.key,
    required this.user,
  });

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> with SingleTickerProviderStateMixin {
  final GlobalKey _addButtonKey = GlobalKey();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final GlobalKey _statusPrivacyKey = GlobalKey();
  final UserController userController = Get.find<UserController>();
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset(0, 0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
    _loadProfileImage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).status, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      CustomTooltip(
                        message: S.of(context).addStatus,
                        horizontalOffset: -50,
                        verticalOffset: -35,
                        position: TooltipPositionType.bottom,
                        child: IconButton(
                          key: _addButtonKey,
                          icon: const Icon(Icons.add_circle_outline_rounded),
                          onPressed: () {
                            final RenderBox button = _addButtonKey.currentContext!.findRenderObject() as RenderBox;
                            final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                            final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
                            final Size buttonSize = button.size;

                            showMenu<int>(
                              context: context,
                              position: RelativeRect.fromLTRB(buttonPosition.dx, buttonPosition.dy + buttonSize.height, overlay.size.width - buttonPosition.dx - buttonSize.width, 0),
                              color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey, width: 1)),
                              constraints: const BoxConstraints(minWidth: 0, maxWidth: 200),
                              menuPadding: EdgeInsets.symmetric(vertical: 4),
                              items: [
                                PopupMenuItem<int>(
                                  value: 1,
                                  enabled: false,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: AppPopupMenuItem(
                                    icon: const Icon(Icons.photo_library_outlined, size: 20),
                                    text: S.of(context).photosAndVideos,
                                    fontSize: ChatifySizes.fontSizeMd,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  enabled: false,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: AppPopupMenuItem(
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    text: S.of(context).text,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      CustomTooltip(
                        message: S.of(context).more,
                        horizontalOffset: -20,
                        verticalOffset: -35,
                        position: TooltipPositionType.bottom,
                        child: IconButton(
                          key: _statusPrivacyKey,
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            final RenderBox renderBox = _statusPrivacyKey.currentContext?.findRenderObject() as RenderBox;
                            final position = renderBox.localToGlobal(Offset.zero);

                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx + renderBox.size.width, 0),
                              color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey, width: 1)),
                              constraints: const BoxConstraints(minWidth: 0, maxWidth: 290),
                              menuPadding: EdgeInsets.symmetric(vertical: 4),
                              items: [
                                PopupMenuItem<int>(
                                  value: 1,
                                  enabled: false,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: AppPopupMenuItem(
                                    icon: const Icon(Icons.privacy_tip_outlined, size: 20),
                                    text: S.of(context).statusPrivacy,
                                    fontSize: ChatifySizes.fontSizeMd,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ).then((value) {
                              if (value == 1) {
                                Future.delayed(Duration(milliseconds: 100), () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(S.of(context).statusPrivacy),
                                      content: Text(S.of(context).statusPrivacySettings),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(S.of(context).close, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    onTap: () {},
                    mouseCursor: SystemMouseCursors.basic,
                    splashColor: ChatifyColors.transparent,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .5),
                                child: CachedNetworkImage(
                                  width: 46,
                                  height: 46,
                                  imageUrl: _profileImageUrl ?? '',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => CircleAvatar(
                                    backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                    foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                    child: SvgPicture.asset(ChatifyVectors.profile, width: 46, height: 46),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: Container(
                                  width: 21,
                                  height: 21,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ChatifyColors.green,
                                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white, width: 2),
                                  ),
                                  child: const Center(child: Icon(Icons.add_rounded, size: 16, color: ChatifyColors.black)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context).myStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.3)),
                                Text('Нажмите, чтобы добавить обновление статуса', style: TextStyle(color: ChatifyColors.buttonGrey ,fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
              child: PrivateMessagesProtectedNotice(),
            ),
          ],
        ),
      ),
    );
  }
}
