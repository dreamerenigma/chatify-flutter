import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/cards/chat_user_card.dart';
import '../../../personalization/controllers/colors_controller.dart';

class ArchiveList extends StatefulWidget {
  final bool isSearching;
  final List<UserModel> searchList;
  final List<UserModel> archivedUsers;
  final Function(UserModel) onUserSelected;
  final UserModel user;

  const ArchiveList({
    super.key,
    required this.isSearching,
    required this.searchList,
    required this.archivedUsers,
    required this.onUserSelected,
    required this.user,
  });

  @override
  State<ArchiveList> createState() => _ArchiveListState();
}

class _ArchiveListState extends State<ArchiveList> {
  final ColorsController colorsController = Get.put(ColorsController());
  List<UserModel> cachedArchivedUsers = [];
  bool isLoading = true;
  UserModel? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: APIs.getArchivedUsers(widget.user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
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
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedUser = user;
              });
              widget.onUserSelected(user);
            },
            child: ChatUserCard(user: user, onUserSelected: widget.onUserSelected, isSelected: _selectedUser?.id == user.id),
          );
        },
      ),
    );
  }
}
