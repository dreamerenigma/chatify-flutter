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
  final ValueChanged<Set<String>>? onPinnedChatsChanged;
  final ValueChanged<Set<String>>? onMutedChatsChanged;
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
    this.onPinnedChatsChanged,
    this.onMutedChatsChanged,
    this.onSelectionModeChanged,
    required this.selectedUserIds,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ColorsController colorsController = Get.put(ColorsController());
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _myUsersStream;
  bool isLoading = true;
  bool hasUsersLoaded = false;
  List<UserModel> cachedUsers = [];
  Set<String> _lastPinnedChats = {};
  Set<String> _lastMutedChats = {};

  @override
  void initState() {
    super.initState();
    _myUsersStream = APIs.getMyUsersId();
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

  void _notifyPinnedChatsChanged(Set<String> pinnedChats) {
    if (setEquals(_lastPinnedChats, pinnedChats)) {
      return;
    }

    _lastPinnedChats = {...pinnedChats};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.onPinnedChatsChanged?.call(_lastPinnedChats);
    });
  }

  void _notifyMutedChatsChanged(Set<String> mutedChats) {
    if (setEquals(_lastMutedChats, mutedChats)) {
      return;
    }

    _lastMutedChats = {...mutedChats};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.onMutedChatsChanged?.call(_lastMutedChats);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showContacts) {
      return _buildContactsList();
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _myUsersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !hasUsersLoaded) {
          return AppLoaders.buildLoadingIndicator();
        }

        if (snapshot.hasError) {
          if (hasUsersLoaded) {
            return _buildUserList(cachedUsers, _lastPinnedChats, _lastMutedChats);
          }

          return const SizedBox.shrink();
        }

        final docs = snapshot.data?.docs ?? [];
        final activeDocs = docs.where((doc) => doc.data()['archived'] != true).toList();

        activeDocs.sort((a, b) {
          final aTime = int.tryParse(a.data()['lastMessageTime']?.toString() ?? '') ?? 0;
          final bTime = int.tryParse(b.data()['lastMessageTime']?.toString() ?? '') ?? 0;

          return bTime.compareTo(aTime);
        });

        final userIds = activeDocs.map((doc) => doc.id).toList();
        final pinnedChats = docs.where((doc) => doc.data()['pinned'] == true).map((doc) => doc.id).toSet();
        final mutedChats = docs.where((doc) => doc.data()['muted'] == true).map((doc) => doc.id).toSet();

        _notifyPinnedChatsChanged(pinnedChats);
        _notifyMutedChatsChanged(mutedChats);

        if (userIds.isEmpty) {
          return _buildUserList([], pinnedChats, mutedChats);
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

            final order = {
              for (int i = 0; i < userIds.length; i++)
                userIds[i]: i,
            };

            users.sort((a, b) => (order[a.id] ?? 999999).compareTo(order[b.id] ?? 999999));

            return _buildUserList(widget.isSearching ? widget.searchList : users, pinnedChats, mutedChats);
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
