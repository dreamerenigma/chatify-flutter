import 'package:chatify/utils/popups/app_loaders.dart';
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
  final bool isSharing;
  final bool isInviting;
  final bool useApp;
  final bool showContacts;
  final Set<String> selectedUserIds;
  final List<Contact> contacts;
  final List<UserModel> searchList;
  final List<UserModel> list;
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
    required this.selectedUserIds,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ColorsController colorsController = Get.put(ColorsController());
  bool isLoading = true;
  List<UserModel> cachedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsersOnce();
  }

  Future<void> _loadUsersOnce() async {
    try {
      final userIdsSnap = await APIs.getMyUsersId().first;

      if (!mounted) return;

      final userIds = userIdsSnap.docs.map((e) => e.id).toList();
      final usersSnap = await APIs.getAllUsers(userIds).first;

      if (!mounted) return;

      final users = usersSnap.docs.map((e) => UserModel.fromJson(e.data())).toList();

      setState(() {
        cachedUsers = users;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showContacts) {
      return _buildContactsList();
    }

    return StreamBuilder(
      stream: APIs.getMyUsersId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppLoaders.buildLoadingIndicator();
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final userIds = snapshot.data?.docs.map((e) => e.id).toList() ?? [];

        if (userIds.isEmpty) {
          return _buildUserList([]);
        }

        return StreamBuilder(
          stream: APIs.getAllUsers(userIds),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppLoaders.buildLoadingIndicator();
            }

            if (snapshot.hasError) {
              return const SizedBox.shrink();
            }

            final users = snapshot.data?.docs.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

            return _buildUserList(widget.isSearching ? widget.searchList : users);
          },
        );
      },
    );
  }

  Widget _buildContactsList() {
    return Column(
      children: [
        for (final contact in widget.contacts)
          InviteUserCard(contact: contact, onContactSelected: (_) {}, onInvite: () {}),
      ],
    );
  }

  Widget _buildUserList(List<UserModel> users) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          for (final user in users)
            _buildUserItem(user),
        ],
      ),
    );
  }

  Widget _buildUserItem(UserModel user) {
    if (widget.isInviting && !widget.useApp) {
      return InviteUserCard(contact: Contact(), onContactSelected: (_) {}, onInvite: () {});
    }

    if (widget.isSharing && !widget.useApp) {
      return ShareUserCard(user: user, onUserSelected: widget.onUserSelected);
    }

    if (widget.useApp) {
      return UseAppUserCard(user: user, onUserSelected: widget.onUserSelected);
    }

    return ChatUserCard(user: user, isSelected: widget.selectedUserIds.contains(user.id), onUserSelected: widget.onUserSelected);
  }
}
