import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../models/community_model.dart';
import '../buttons/animated_add_group_button.dart';
import '../community_widget.dart';

void showAddGroupCommunityBottomSheetDialog(BuildContext context, CommunityModel community) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                SizedBox(
                  height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align( alignment: Alignment.center, child: Text(community.name, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w500))),
                      Positioned(
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            child: Icon(Icons.close, size: 26, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, bottom: 0),
                CommunityWidgets(isValidDate: (date) => true, showAllButton: false, isInteractive: true, showGroupsSection: true, community: community, user: APIs.me),
              ],
            ),
            _buttonAddGroup(context, community),
          ],
        ),
      );
    },
  );
}

Widget _buttonAddGroup(BuildContext context, CommunityModel community) {
  return Positioned(
    bottom: 16,
    left: 0,
    right: 0,
    child: Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05), child: AnimatedAddGroupButton(community: community)),
  );
}
