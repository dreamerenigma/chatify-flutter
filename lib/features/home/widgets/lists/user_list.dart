import 'package:chatify/utils/popups/app_loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  final Set<String> pinnedChats;
  final Set<String> mutedChats;
  final Function(UserModel) onUserSelected;
  final Function(bool)? onSelectionModeChanged;

  const UserList({
    super.key,
    required this.isSearching,
    required this.searchList,
    required this.list,
    required this.isSharing,
    required this.onUserSelected,
    required this.pinnedChats,
    required this.mutedChats,
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


  @override
  Widget build(BuildContext context) {
    if (widget.showContacts) {
      return _buildContactsList();
    }

    return _buildUserList(
      widget.isSearching ? widget.searchList : widget.list,
      widget.pinnedChats,
      widget.mutedChats,
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

  Widget _buildUserList(List<UserModel> users, Set<String> pinnedChats, Set<String> mutedChats) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          for (final user in users)
            _buildUserItem(user, isPinned: pinnedChats.contains(user.id), isMuted: mutedChats.contains(user.id)),
        ],
      ),
    );
  }

  Widget _buildUserItem(UserModel user, {required bool isPinned, required bool isMuted}) {
    if (widget.isInviting && !widget.useApp) {
      return InviteUserCard(contact: Contact(), onContactSelected: (_) {}, onInvite: () {});
    }

    if (widget.isSharing && !widget.useApp) {
      return ShareUserCard(user: user, onUserSelected: widget.onUserSelected);
    }

    if (widget.useApp) {
      return UseAppUserCard(user: user, onUserSelected: widget.onUserSelected);
    }

    return ChatUserCard(user: user, isSelected: widget.selectedUserIds.contains(user.id), isPinned: isPinned, isMuted: isMuted, onUserSelected: widget.onUserSelected);
  }
}
