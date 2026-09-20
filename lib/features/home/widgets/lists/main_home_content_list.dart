import 'package:chatify/features/home/widgets/lists/infos_app_list.dart';
import 'package:chatify/features/home/widgets/lists/support_list.dart';
import 'package:chatify/features/home/widgets/lists/user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/selection_type.dart';
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
  final Set<String> pinnedChats;
  final Set<String> mutedChats;
  final List<SupportAppModel> supports;
  final List<InfoAppModel> infosApp;
  final bool isSearching;
  final bool isTabsVisible;
  final bool isAccessKeyVisible;
  final bool isSelectionMode;
  final List<UserModel> searchList;
  final Set<String> selectedUserIds;
  final Set<String> selectedNewsletterIds;
  final Set<String> selectedCommunityIds;
  final Function(UserModel) onUserSelected;
  final ValueChanged<NewsletterModel>? onNewsletterSelected;
  final ValueChanged<CommunityModel> onCommunitySelected;
  final SelectionType selectionType;

  const MainHomeContentList({
    super.key,
    required this.groups,
    required this.newsletters,
    required this.communities,
    required this.users,
    required this.pinnedChats,
    required this.mutedChats,
    required this.supports,
    required this.infosApp,
    required this.isSearching,
    required this.isTabsVisible,
    required this.isAccessKeyVisible,
    required this.searchList,
    required this.selectedUserIds,
    required this.onUserSelected,
    required this.selectedNewsletterIds,
    required this.selectedCommunityIds,
    required this.selectionType,
    required this.onCommunitySelected,
    this.isSelectionMode = false,
    this.onNewsletterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserName = Get.find<UserController>().currentUser.name;
    final isNewsletterSelection = selectionType == SelectionType.newsletters;
    final isCommunitySelection = selectionType == SelectionType.communities;
    final isChatSelection = selectionType == SelectionType.chats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isTabsVisible && !isAccessKeyVisible)
          const SizedBox(height: 6),
        if (groups.isNotEmpty)
          IgnorePointer(ignoring: isSelectionMode, child: GroupList(groups: groups, currentUser: currentUserName, onGroupSelected: (group) {})),
        if (newsletters.isNotEmpty)
          IgnorePointer(
            ignoring: selectionType != SelectionType.none && !isNewsletterSelection,
            child: NewsletterList(
              newsletters: newsletters,
              isSelectionMode: selectionType == SelectionType.newsletters,
              selectedNewsletterIds: selectedNewsletterIds,
              onNewsletterSelected: onNewsletterSelected,
            ),
          ),
        if (communities.isNotEmpty)
          IgnorePointer(
            ignoring: selectionType != SelectionType.none && !isCommunitySelection,
            child: CommunityList(
              communities: communities,
              isHomeScreen: true,
              isSelectionMode: selectionType == SelectionType.communities,
              selectedCommunityIds: selectedCommunityIds,
              onCommunitySelected: onCommunitySelected,
            ),
          ),
        if (users.isNotEmpty)
          IgnorePointer(
            ignoring: selectionType != SelectionType.none && !isChatSelection,
            child: UserList(
              isSearching: isSearching,
              searchList: searchList,
              list: users,
              isSharing: false,
              onUserSelected: onUserSelected,
              selectedUserIds: selectedUserIds,
              pinnedChats: pinnedChats,
              mutedChats: mutedChats,
            ),
          ),
        if (supports.isNotEmpty) ...[
          if (users.isEmpty)
            const SizedBox(height: 8),
          IgnorePointer(ignoring: isSelectionMode, child: SupportList(supports: supports, onSupportSelected: (support) {})),
        ],
        if (infosApp.isNotEmpty)
          IgnorePointer(ignoring: isSelectionMode, child: InfosAppList(infosApp: infosApp, onInfoAppSelected: (infosApp) {})),
        const SizedBox(height: 8),
      ],
    );
  }
}
