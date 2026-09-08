import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/cards/chat_user_card.dart';
import '../../../personalization/controllers/colors_controller.dart';

class ArchiveList extends StatefulWidget {
  final UserModel user;
  final bool isSearching;
  final List<UserModel> searchList;
  final List<UserModel> archivedUsers;
  final Set<String> selectedUserIds;
  final Function(UserModel) onUserSelected;

  const ArchiveList({
    super.key,
    required this.user,
    required this.isSearching,
    required this.searchList,
    required this.archivedUsers,
    required this.selectedUserIds,
    required this.onUserSelected,
  });

  @override
  State<ArchiveList> createState() => _ArchiveListState();
}

class _ArchiveListState extends State<ArchiveList> {
  final ColorsController colorsController = Get.put(ColorsController());
  List<UserModel> cachedArchivedUsers = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: APIs.getArchivedUsers(widget.user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('${S.of(context).error.replaceAll('!', '')}: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final archivedUsers = snapshot.data ?? [];

          return _buildArchivedUserList(widget.isSearching ? widget.searchList : archivedUsers);
        } else {
          return _buildArchivedUserList(widget.isSearching ? widget.searchList : cachedArchivedUsers);
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
    );
  }

  Widget _buildArchivedUserList(List<UserModel> users) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: users.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .008),
        itemBuilder: (context, index) {
          final user = users[index];
          final isSelected = widget.selectedUserIds.contains(user.id);

          return GestureDetector(
            onTap: () {
              widget.onUserSelected(user);
            },
            child: ChatUserCard(user: user, onUserSelected: widget.onUserSelected, isSelected: isSelected),
          );
        },
      ),
    );
  }
}
