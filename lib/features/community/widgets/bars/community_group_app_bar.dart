import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/bars/actions/app_bar_actions.dart';
import '../../models/community_model.dart';
import '../../screens/community_group_info_screen.dart';

class CommunityGroupAppBar extends StatefulWidget implements PreferredSizeWidget {
  final CommunityModel community;
  final UserModel user;
  final VoidCallback onOpenCommunity;
  final VoidCallback onBack;

  const CommunityGroupAppBar({
    super.key,
    required this.community,
    required this.user,
    required this.onOpenCommunity,
    required this.onBack,
  });

  @override
  State<CommunityGroupAppBar> createState() => CommunityGroupAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}

class CommunityGroupAppBarState extends State<CommunityGroupAppBar> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.buttonDisabled))),
      child: AppBar(
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
        ),
        title: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(8),
            splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
            onTap: () {
              Navigator.push(context, createPageRoute(CommunityGroupInfoScreen(community: widget.community, user: widget.user)));
            },
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.grey),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(ChatifyVectors.communityMessage, width: 22, height: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Общая', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                      const SizedBox(height: 3),
                      Text(
                        APIs.me.id == widget.user.id ? 'Вы' : widget.user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          const SizedBox(width: 5),
          _buildOpenCommunityButton(context),
          const SizedBox(width: 17),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: AppBarActions(
              user: widget.user,
              isGroup: true,
              showAudioCall: false,
              showVideoCallMenu: true,
              onPopupItemSelected: (value) async {
                if (value == 1) {

                } else if (value == 2) {

                } else if (value == 3) {

                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenCommunityButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Center(
        child: GestureDetector(
          onTap: widget.onOpenCommunity,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 34,
                    height: 34,
                    color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    alignment: Alignment.center,
                    child: const Icon(Icons.groups_rounded, size: 22, color: ChatifyColors.steelGrey),
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 7,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.keyboard_arrow_right_outlined, size: 15, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
