import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/cards/chat_user_card.dart';
import '../../../community/widgets/cards/invite_user_card.dart';
import '../../../personalization/controllers/colors_controller.dart';
import '../../../personalization/widgets/cards/share_user_card.dart';
import '../../../personalization/widgets/cards/use_app_user_card.dart';

class UserList extends StatefulWidget {
  final bool isSearching;
  final List<UserModel> searchList;
  final List<UserModel> list;
  final bool isSharing;
  final bool isInviting;
  final bool useApp;
  final bool showContacts;
  final UserModel? selectedUser;
  final List<Contact> contacts;
  final Function(UserModel) onUserSelected;
  final Function(bool)? onSelectionModeChanged;

  const UserList({
    super.key,
    required this.isSearching,
    required this.searchList,
    required this.list,
    required this.isSharing,
    required this.onUserSelected,
    this.isInviting = false,
    this.useApp = false,
    this.showContacts = false,
    this.contacts = const [],
    this.onSelectionModeChanged,
    this.selectedUser,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ColorsController colorsController = Get.put(ColorsController());
  List<UserModel> cachedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsersOnce();
  }

  Future<void> _loadUsersOnce() async {
    final userIdsSnap = await APIs.getMyUsersId().first;
    final userIds = userIdsSnap.docs.map((e) => e.id).toList();

    final usersSnap = await APIs.getAllUsers(userIds).first;
    final users = usersSnap.docs.map((e) => UserModel.fromJson(e.data())).toList();

    setState(() {
      cachedUsers = users;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showContacts) {
      return _buildContactsList();
    } else {
      return StreamBuilder(
        stream: APIs.getMyUsersId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
            final userIds = snapshot.data?.docs.map((e) => e.id).toList() ?? [];

            return StreamBuilder(
              stream: APIs.getAllUsers(userIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                  final data = snapshot.data?.docs;
                  final users = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

                  if (users.isNotEmpty) {
                    cachedUsers = users;
                  }

                  isLoading = false;

                  return _buildUserList(widget.isSearching ? widget.searchList : cachedUsers);
                } else {
                  return isLoading ? _buildLoadingIndicator() : _buildUserList(widget.isSearching ? widget.searchList : cachedUsers);
                }
              },
            );
          } else {
            return isLoading ? _buildLoadingIndicator() : _buildUserList(widget.isSearching ? widget.searchList : cachedUsers);
          }
        },
      );
    }
  }

  Widget _buildContactsList() {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: widget.contacts.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final contact = widget.contacts[index];
          return InviteUserCard(
            contact: contact,
            onContactSelected: (Contact selectedContact) {
              log('Selected contact: ${selectedContact.displayName}');
            },
            onInvite: () {
              log('Invite action');
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
    );
  }

  Widget _buildUserList(List<UserModel> users) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: users.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 6),
        itemBuilder: (context, index) {
          final user = users[index];
          Widget userCard;

          if (widget.isInviting && !widget.useApp) {
            userCard = InviteUserCard(
              contact: Contact(),
              onContactSelected: (Contact selectedContact) {
                log('Selected contact: ${selectedContact.displayName}');
              },
              onInvite: () {
                log('Invite action');
              },
            );
          } else if (widget.isSharing && !widget.useApp) {
            userCard = ShareUserCard(user: user, onUserSelected: widget.onUserSelected);
          } else if (widget.useApp) {
            userCard = UseAppUserCard(user: user, onUserSelected: widget.onUserSelected);
          } else {
            userCard = ChatUserCard(
              user: user,
              onUserSelected: (selectedUser) {
                widget.onUserSelected(selectedUser);
              },
              isSelected: widget.selectedUser?.id == user.id,
            );
          }

          return GestureDetector(
            onTap: () {
              widget.onUserSelected(user);
              if (widget.onSelectionModeChanged != null) {
                widget.onSelectionModeChanged!(true);
              }
            },
            child: userCard,
          );
        },
      ),
    );
  }
}
