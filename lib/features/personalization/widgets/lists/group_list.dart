import 'package:flutter/material.dart';
import '../../../chat/models/user_model.dart';
import '../../../group/models/group_model.dart';
import '../cards/group_card.dart';

class GroupList extends StatefulWidget {
  final List<GroupModel> groups;
  final String currentUser;
  final Map<String, UserModel> users;
  final Function(GroupModel) onGroupSelected;
  final Set<String> selectedGroupIds;
  final bool showBackground;
  final bool showDate;
  final bool showMembers;

  const GroupList({
    super.key,
    required this.groups,
    required this.users,
    required this.currentUser,
    required this.onGroupSelected,
    this.selectedGroupIds = const {},
    this.showBackground = true,
    this.showDate = true,
    this.showMembers = false,
  });

  @override
  GroupListState createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    final sortedGroups = [...widget.groups];
    sortedGroups.sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));

    return Column(
      children: sortedGroups.map((group) {
        final isSelected = widget.selectedGroupIds.contains(group.id);


        return GroupCard(
          group: group,
          users: widget.users,
          currentUser: widget.currentUser,
          isSelected: isSelected,
          showDate: widget.showDate,
          showMembers: widget.showMembers,
          showBackground: widget.showBackground,
          onGroupSelected: (selected) => widget.onGroupSelected(selected),
        );
      }).toList(),
    );
  }
}
