import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/user_model.dart';
import '../../group/screens/add_new_group_screen.dart';
import '../../personalization/widgets/cards/invite_user_card.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  AddUserScreenState createState() => AddUserScreenState();
}

class AddUserScreenState extends State<AddUserScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<UserModel> _chatUsers = [];
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

  void _toggleContactSelection(Contact contact) {
    setState(() {
      if (selectedContacts.contains(contact)) {
        selectedContacts.remove(contact);
      } else {
        selectedContacts.add(contact);
      }
    });
  }

  String _getContactInitials(Contact contact) {
    final nameParts = contact.displayName.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0].isNotEmpty ? nameParts[0][0] : '';
      if (nameParts.length > 1) {
        initials += nameParts[1].isNotEmpty ? nameParts[1][0] : '';
      }
    }
    return initials.toUpperCase();
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
            keyboardType:
            isNumericMode ? TextInputType.number : TextInputType.text,
            style: TextStyle(
                fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
            decoration: InputDecoration(
              hintText: 'Поиск контактов',
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
            Text('Добавить участников', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: isSearching
            ? [
          IconButton(icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad), onPressed: _toggleInputMode),
        ]
        : [
          IconButton(
            icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
      )
      : ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
            child: ListView(
              children: [
            if (selectedUsers.isNotEmpty || selectedContacts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    ...selectedUsers.map((user) {
                      return _buildSelectedUserTile(user);
                    }),
                    ...selectedContacts.map((contact) {
                      return _buildSelectedContactTile(contact);
                    }),
                  ],
                ),
              ),
            if (selectedUsers.isNotEmpty || selectedContacts.isNotEmpty)
              const Divider(),

            if (_chatUsers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Контакты в Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold)),
              ),
            ..._chatUsers.map((chatUser) => UseAppUserCard(
              user: chatUser,
              onUserSelected: (UserModel selectedUser) {
                _toggleUserSelection(selectedUser);
              },
            )),

            if (_filteredContacts.isNotEmpty)
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Text('Пригласить в Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold)),
              ),
            ..._filteredContacts.map((contact) => InviteUserCard(
              contact: contact,
              onInvite: () {},
              onContactSelected: (Contact selectedContact) {
                _toggleContactSelection(selectedContact);
              },
            )),

            ListTile(contentPadding: const EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 8),
              leading: const CircleAvatar(
                radius: 23,
                backgroundColor: ChatifyColors.darkSlate,
                child: Icon(Icons.share_outlined, color: ChatifyColors.white),
              ),
              title: Text('Пригласить по ссылке', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: (selectedUsers.isNotEmpty || selectedContacts.isNotEmpty) ? Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          heroTag: 'group',
          onPressed: () async {
            if (selectedUsers.isEmpty && selectedContacts.isEmpty) {
              Dialogs.showCustomDialog(context: context, message: 'Должен быть выбран минимум 1 контакт', duration: const Duration(seconds: 1));
            } else {
              Navigator.push(context, createPageRoute(
                AddNewGroupScreen(selectedUsers: selectedUsers.toList(), selectedContacts: selectedContacts.toList())),
              );
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: const Icon(Icons.check),
        ),
      )
      : null,
    );
  }

  Widget _buildSelectedUserTile(UserModel user) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
                  radius: 30,
                  child: user.image.isEmpty ? SvgPicture.asset(ChatifyVectors.profile, width: 60, height: 60) : null,
                ),
                const SizedBox(height: 4),
                Text(
                  user.name.length > 7
                      ? '${user.name.substring(0, 7)}...'
                      : user.name,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(
              bottom: 17,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _toggleUserSelection(user);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 12,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedContactTile(Contact contact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    _getContactInitials(contact),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.displayName.length > 7 ? '${contact.displayName.substring(0, 7)}...' : contact.displayName,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(
              bottom: 17,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _toggleContactSelection(contact);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ChatifyColors.black,
                      width: 2.0,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: ChatifyColors.grey,
                    radius: 12,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: ChatifyColors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
