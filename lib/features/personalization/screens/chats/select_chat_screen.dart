import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../chat/models/user_model.dart';
import '../../widgets/cards/use_app_user_card.dart';

class SelectChatScreen extends StatefulWidget {
  const SelectChatScreen({super.key});

  @override
  SelectChatScreenState createState() => SelectChatScreenState();
}

class SelectChatScreenState extends State<SelectChatScreen> {
  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isSearching = false;
  List<UserModel> chatUsers = [];
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  Set<UserModel> selectedUsers = {};

  @override
  void initState() {
    super.initState();
    _fetchChatUsers();
  }

  void _toggleUserSelection(UserModel user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  Future<void> _fetchChatUsers() async {
    final userIds = (await APIs.getMyUsersId().first).docs.map((e) => e.id).toList();
    if (userIds.isNotEmpty) {
      final chatUserDocs = (await APIs.getAllUsers(userIds).first).docs;
      setState(() {
        chatUsers = chatUserDocs.map((e) => UserModel.fromJson(e.data())).toList();
        isFetchingChatUsers = false;
      });
    } else {
      setState(() {
        isFetchingChatUsers = false;
      });
    }
  }

  void onSearchChanged(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) =>
      contact.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (isSearching) {
        searchFocusNode.requestFocus();
      } else {
        filteredContacts = List.from(contacts);
        searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = isFetchingContacts || isFetchingChatUsers;

    if (!isLoading) {

      if (selectedUsers.isEmpty) {
      }

      if (selectedUsers.isNotEmpty) {
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
              boxShadow: [
                BoxShadow(
                  color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: AppBar(
              titleSpacing: 0,
              title: isSearching
                  ? TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.blue,
                  selectionColor: Colors.blue.withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: Colors.blue,
                ),
                child: TextField(
                  focusNode: searchFocusNode,
                  cursorColor: ChatifyColors.blue,
                  controller: searchController,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
                  decoration: InputDecoration(
                    hintText: S.of(context).settingsSearch,
                    hintStyle:
                    TextStyle(fontSize: ChatifySizes.fontSizeMd),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: onSearchChanged,
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).selectChat, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                ],
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search),
                  onPressed: toggleSearch,
                ),
              ],
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: filteredContacts.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 12),
                child: Text(S.of(context).otherContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
              );
            } else {
              final adjustedIndex = index - 1;
              if (adjustedIndex >= 0 && adjustedIndex < chatUsers.length) {
                final chatUser = chatUsers[adjustedIndex];
                return UseAppUserCard(
                  user: chatUser,
                  onUserSelected: (UserModel selectedUser) {
                    _toggleUserSelection(selectedUser);
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        ),
      ),
    );
  }
}
