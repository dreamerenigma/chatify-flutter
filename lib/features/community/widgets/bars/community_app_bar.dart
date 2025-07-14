import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/buttons/custom_search_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/dialogs/chat_settings_dialog.dart';
import '../../models/community_model.dart';

class CommunityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final CommunityModel community;
  final UserModel user;

  const CommunityAppBar({super.key, required this.community, required this.user});

  @override
  State<CommunityAppBar> createState() => CommunityAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight);
}

class CommunityAppBarState extends State<CommunityAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;
  late Animation<double> _searchScaleAnimation;
  List<CommunityModel> _communities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(parent: _searchController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCommunities() async {
    try {
      final data = await APIs.getCommunity();
      setState(() {
        _communities = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('Error loading communities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppBar(backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey);
    }

    CommunityModel community = _communities.isNotEmpty
      ? _communities[0]
      : CommunityModel(id: '', name: 'No Community', image: '', description: '', createdAt: widget.community.createdAt, creatorName: '');

    return _buildAppBar(context, community);
  }

  Widget _buildAppBar(BuildContext context, CommunityModel community) {
    return Stack(
      children: [
        _buildCommunityAppBar(context, community),
      ],
    );
  }

  Widget _buildCommunityAppBar(BuildContext context, CommunityModel community) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey)),
      ),
      child: AppBar(
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: 0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Row(
            children: [
              _buildCommunityInfo(context, community),
            ],
          ),
        ),
        actions: [
          CustomSearchButton(
            searchController: _searchController,
            searchScaleAnimation: _searchScaleAnimation,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityInfo(BuildContext context, CommunityModel community) {
    double imageSize = Platform.isWindows ? 40.0 : 35.0;

    return InkWell(
      onTap: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        showChatSettingsDialog(context, widget.user, position, initialIndex: 0);
      },
      mouseCursor: SystemMouseCursors.basic,
      borderRadius: BorderRadius.circular(8),
      splashColor: ChatifyColors.transparent,
      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .04),
              child: CachedNetworkImage(
                width: imageSize,
                height: imageSize,
                imageUrl: community.image,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey);
                },
                errorWidget: (context, url, error) {
                  return CircleAvatar(
                    backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    foregroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    child: SvgPicture.asset(ChatifyVectors.communityUsers, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                  );
                },
              ),
            ),
            SizedBox(width: Platform.isWindows ? 14 : 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                    width: Platform.isWindows ? null : 155,
                    child: Text(
                      community.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeLg,
                        fontFamily: 'Roboto',
                        fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Объявления',
                  style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, color: ChatifyColors.grey, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
