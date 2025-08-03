import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/user_model.dart';
import '../../community/widgets/cards/invite_user_card.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import 'add_new_group_screen.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  NewGroupScreenState createState() => NewGroupScreenState();
}

class NewGroupScreenState extends State<NewGroupScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<UserModel> _chatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();
  Set<UserModel> selectedUsers = {};
  Set<Contact> selectedContacts = {};

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _fetchChatUsers();

    _searchController.addListener(() {
      _filterContacts();
    });
  }

  Future<void> _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = contacts.toList();
        _filteredContacts = List.from(_contacts);
        isFetchingContacts = false;
      });
    } else {
      setState(() {
        isFetchingContacts = false;
      });
    }
  }

  Future<void> _fetchChatUsers() async {
    final userIds = (await APIs.getMyUsersId().first).docs.map((e) => e.id).toList();
    if (userIds.isNotEmpty) {
      final chatUserDocs = (await APIs.getAllUsers(userIds).first).docs;
      setState(() {
        _chatUsers = chatUserDocs.map((e) => UserModel.fromJson(e.data())).toList();
        isFetchingChatUsers = false;
      });
    } else {
      setState(() {
        isFetchingChatUsers = false;
      });
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final contactName = contact.displayName.toLowerCase();
        return contactName.contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      if (isSearching) {
        _searchController.clear();
        _searchFocusNode.unfocus();
        searchList = List.from(list);
      } else {
        _searchFocusNode.requestFocus();
      }
      isSearching = !isSearching;
    });
  }

  void _toggleInputMode() {
    setState(() {
      isNumericMode = !isNumericMode;
      textFieldKey = UniqueKey();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
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

  @override
  Widget build(BuildContext context) {
    final isLoading = isFetchingContacts || isFetchingChatUsers;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isSearching) {
              _toggleSearch();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: isSearching
            ? TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          ),
          child: TextField(
            key: textFieldKey,
            focusNode: _searchFocusNode,
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            controller: _searchController,
            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
            decoration: InputDecoration(
              hintText: S.of(context).searchByNameOrPhoneNumber,
              hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).newGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
            Text(S.of(context).addParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: isSearching
          ? [
              IconButton(icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad), onPressed: _toggleInputMode),
            ]
          : [
              IconButton(icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search), onPressed: _toggleSearch),
            ],
      ),
      body: isLoading
        ? Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
          )
        : ListView.builder(
        itemCount: _chatUsers.length + _filteredContacts.length + 2 + (selectedUsers.isEmpty ? 0 : 2),
        itemBuilder: (context, index) {
          int adjustedIndex = index;

          if (selectedUsers.isNotEmpty) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: selectedUsers.map((user) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomRight,
                              children: [
                                Column(
                                  children: [
                                    user.image.isNotEmpty
                                    ? CachedNetworkImage(
                                      imageUrl: user.image,
                                        placeholder: (context, url) => const CircleAvatar(
                                          backgroundColor: ChatifyColors.grey,
                                          radius: 30,
                                          child: Icon(Icons.person, color: ChatifyColors.white, size: 24),
                                        ),
                                        errorWidget: (context, url, error) => const CircleAvatar(
                                          backgroundColor: ChatifyColors.blackGrey,
                                          radius: 30,
                                          child: Icon(Icons.error, color: ChatifyColors.red, size: 24),
                                        ),
                                        imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider, radius: 30),
                                      )
                                    : const CircleAvatar(backgroundColor: ChatifyColors.blackGrey, radius: 30, child: Icon(Icons.person, color: ChatifyColors.white, size: 24)),
                                  ],
                                ),
                                Positioned(
                                  bottom: -3,
                                  right: -5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _toggleUserSelection(user);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.black, width: 2.0)),
                                      child: const CircleAvatar(backgroundColor: ChatifyColors.grey, radius: 12, child: Icon(Icons.close, size: 16, color: ChatifyColors.black)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(),
                ],
              );
            } else {
              adjustedIndex = index - 1;
            }
          }

          if (adjustedIndex == 0) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(S.of(context).contactsOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey)),
            );
          } else if (adjustedIndex <= _chatUsers.length) {
            final chatUser = _chatUsers[adjustedIndex - 1];
            return UseAppUserCard(
              user: chatUser,
              onUserSelected: (UserModel selectedUser) {
                _toggleUserSelection(selectedUser);
              },
            );
          } else if (adjustedIndex == _chatUsers.length + 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(S.of(context).inviteOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey)),
            );
          } else {
            final filteredIndex = adjustedIndex - _chatUsers.length - 2;
            if (filteredIndex >= 0 && filteredIndex < _filteredContacts.length) {
              final contact = _filteredContacts[filteredIndex];
              return InviteUserCard(
                contact: contact,
                onInvite: () {},
                onContactSelected: (Contact selectedContact) {},
              );
            } else {
              return const SizedBox();
            }
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'group',
          onPressed: () async {
            if (selectedUsers.isEmpty) {
              Dialogs.showSnackbar(context, S.of(context).pleaseSelectLeastOneParticipant);
            } else {
              Navigator.push(context, createPageRoute(AddNewGroupScreen(selectedUsers: selectedUsers.toList(), selectedContacts: selectedContacts.toList())));
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
    );
  }
}
