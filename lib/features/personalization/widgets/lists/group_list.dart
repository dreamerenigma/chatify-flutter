import 'package:flutter/material.dart';
import '../../../group/models/group_model.dart';
import '../cards/group_card.dart';

class GroupList extends StatefulWidget {
  final List<GroupModel> groups;
  final String currentUser;
  final Function(GroupModel) onGroupSelected;

  const GroupList({
    super.key,
    required this.groups,
    required this.currentUser,
    required this.onGroupSelected,
  });

  @override
  GroupListState createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  GroupModel? selectedGroup;

  @override
  Widget build(BuildContext context) {
    List<GroupModel> sortedGroups = [...widget.groups];
    sortedGroups.sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));

    return Padding(
      padding: EdgeInsets.only(top: 6),
      child: Column(
        children: sortedGroups.map((group) {
          return GroupCard(
            groupName: group.groupName,
            members: group.members,
            creatorName: group.creatorName,
            currentUser: widget.currentUser,
            createdAt: group.createdAt,
            groupImage: group.groupImage,
            isSelected: selectedGroup == group,
            onGroupSelected: (selected) {
              setState(() {
                selectedGroup = selected;
              });
              widget.onGroupSelected(selected);
            },
          );
        }).toList(),
      ),
    );
  }
}
