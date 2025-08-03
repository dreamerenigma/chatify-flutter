import 'package:chatify/features/home/widgets/lists/infos_app_list.dart';
import 'package:chatify/features/home/widgets/lists/support_list.dart';
import 'package:chatify/features/home/widgets/lists/user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../bot/models/info_app_model.dart';
import '../../../bot/models/support_model.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../community/widgets/lists/community_list.dart';
import '../../../group/models/group_model.dart';
import '../../../newsletter/models/newsletter_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/lists/group_list.dart';
import 'newsletter_list.dart';

class MainHomeContentList extends StatelessWidget {
  final List<GroupModel> groups;
  final List<NewsletterModel> newsletters;
  final List<CommunityModel> communities;
  final List<UserModel> users;
  final List<SupportAppModel> supports;
  final List<InfoAppModel> infosApp;
  final bool isSearching;
  final List<UserModel> searchList;
  final Function(UserModel) onUserSelected;

  const MainHomeContentList({
    super.key,
    required this.groups,
    required this.newsletters,
    required this.communities,
    required this.users,
    required this.supports,
    required this.infosApp,
    required this.isSearching,
    required this.searchList,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserName = Get.find<UserController>().currentUser.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (groups.isEmpty) const SizedBox(height: 6),
        if (groups.isNotEmpty)
          GroupList(groups: groups, currentUser: currentUserName, onGroupSelected: (group) {}),
        if (newsletters.isNotEmpty)
          NewsletterList(newsletters: newsletters, onNewsletterSelected: (newsletter) {}),
        if (communities.isNotEmpty)
          CommunityList(communities: communities, isHomeScreen: true, onCommunitySelected: (community) {}),
        if (users.isEmpty)
          UserList(
            isSearching: isSearching,
            searchList: searchList,
            list: users,
            isSharing: false,
            onUserSelected: onUserSelected,
            onSelectionModeChanged: (bool selecting) {},
          ),
        if (supports.isEmpty)
          SupportList(supports: supports, onSupportSelected: (support) {}),
        if (infosApp.isEmpty)
          InfosAppList(infosApp: infosApp, onInfoAppSelected: (infosApp) {}),
        const SizedBox(height: 8),
      ],
    );
  }
}
