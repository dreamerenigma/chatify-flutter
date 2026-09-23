import 'package:flutter/material.dart';
import '../../../group/models/group_model.dart';
import '../cards/group_card.dart';

class GroupList extends StatefulWidget {
  final List<GroupModel> groups;
  final String currentUser;
  final Function(GroupModel) onGroupSelected;
  final Set<String> selectedGroupIds;

  const GroupList({
    super.key,
    required this.groups,
    required this.currentUser,
    required this.onGroupSelected,
    this.selectedGroupIds = const {},
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
          currentUser: widget.currentUser,
          isSelected: isSelected,
          onGroupSelected: (selected) => widget.onGroupSelected(selected),
        );
      }).toList(),
    );
  }
}
