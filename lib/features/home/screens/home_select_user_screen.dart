import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:chatify/features/calls/screens/new_contact_screen.dart';
import 'package:chatify/features/group/screens/new_group_screen.dart';
import 'package:chatify/features/personalization/screens/help/help_center_screen.dart';
import 'package:chatify/features/personalization/screens/qr_code/qr_code_screen.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../calls/widgets/dialog/save_contact_dialog.dart';
import '../../chat/models/user_model.dart';
import '../../chat/screens/chat_screen.dart';
import '../../community/screens/created_community_screen.dart';
import '../../community/widgets/cards/invite_user_card.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import 'new_newsletter_screen.dart';

class HomeSelectUserScreen extends StatefulWidget {
  const HomeSelectUserScreen({super.key});

  @override
  State<HomeSelectUserScreen> createState() => _HomeSelectUserScreenState();
}

class _HomeSelectUserScreenState extends State<HomeSelectUserScreen> {
  List<Contact> _contacts = [];
  List<Contact> filteredContacts = [];
  List<UserModel> chatUsers = [];
  List<UserModel> searchList = [];
  List<UserModel> list = [];
  bool isSearching = false;
  bool isNumericMode = false;
  bool isLoading = false;
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  Key textFieldKey = UniqueKey();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Set<UserModel> selectedUsers = {};
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    fetchContacts();
    fetchChatUsers();
    _searchController.addListener(() {
      _filterContacts();
    });
  }

  Future<void> fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = contacts.toList();
        filteredContacts = List.from(_contacts);
        isFetchingContacts = false;
      });
    } else {
      setState(() {
        isFetchingContacts = false;
      });
    }
  }

  Future<void> fetchChatUsers() async {
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

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = _contacts.where((contact) {
        final contactName = contact.displayName.toLowerCase();
        return contactName.contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchFocusNode.unfocus();
      }
    });
  }

  void _toggleInputMode() {
    setState(() {
      isNumericMode = !isNumericMode;
      textFieldKey = UniqueKey();
    });
    _searchFocusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _updateContacts() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    Dialogs.showSnackbar(context, (S.of(context).yourContactListUpdated));
  }

  void _toggleUserSelection(UserModel user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }

      if (selectedUsers.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void _navigateToChatScreen(UserModel user) {
    Navigator.push(context, createPageRoute(ChatScreen(user: user)));
  }

  void _handleTap(UserModel user) {
    if (isSelectionMode) {
      _toggleUserSelection(user);
    } else {
      _navigateToChatScreen(user);
    }
  }

  void _handleLongPress(UserModel user) {
    setState(() {
      isSelectionMode = true;
      if (!selectedUsers.contains(user)) {
        selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItemsCount = chatUsers.length + filteredContacts.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isSelectionMode) {
              setState(() {
                isSelectionMode = false;
                selectedUsers.clear();
              });
            } else if (isSearching) {
              _toggleSearch();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        titleSpacing: 0,
        title: isSelectionMode
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${selectedUsers.length}'),
            TextButton(
              child: Text(S.of(context).newMailing, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.white)),
              onPressed: () {
                Navigator.push(context, createPageRoute(const NewNewsletterScreen(selectedUsers: [])));
              },
            ),
            TextButton(
              child: Text(S.of(context).newGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.white)),
              onPressed: () {
                Navigator.push(context, createPageRoute(const NewGroupScreen()));
              },
            ),
          ],
        )
        : isSearching
          ? TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
            child: TextField(
            key: textFieldKey,
            focusNode: _searchFocusNode,
            controller: _searchController,
            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
            keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: S.of(context).searchContacts,
              hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: isSearching
                ? IconButton(icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad), onPressed: _toggleInputMode,
              )
                : null,
              ),
            ),
          )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).choose, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              Text('$totalItemsCount ${S.of(context).totalCountContacts}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
            ],
          ),
          actions: isSearching || isSelectionMode ? []
          : [
          Row(
            children: [
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)),
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search),
                onPressed: _toggleSearch,
              ),
            ],
          ),
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 1) {
                Share.share(S.of(context).letsChatInApp);
              } else if (value == 2) {
                const intent = AndroidIntent(
                  action: 'android.intent.action.VIEW',
                  data: 'content://contacts/people',
                  package: 'com.android.contacts',
                  flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                );
                try {
                  await intent.launch();
                } catch (e) {
                  Dialogs.showSnackbar(context, S.of(context).failedOpenContacts);
                }
              } else if (value == 3) {
                _updateContacts();
              } else if (value == 4) {
                Navigator.push(context, createPageRoute(const HelpCenterScreen()));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(S.of(context).inviteFriend, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(S.of(context).contacts, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(S.of(context).update, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
              PopupMenuItem(
                value: 4,
                child: Text(S.of(context).help, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.dragged)) {
                  return ChatifyColors.darkerGrey;
                }
                return ChatifyColors.darkerGrey;
              },
            ),
          ),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: ListView(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(const NewGroupScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ListTile(
                          leading: _buildIconContainer(Icons.group_add, colorsController.getColor(colorsController.selectedColorScheme.value)),
                          title: Text(S.of(context).newGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final saveContactController = SaveContactController.instance;
                        final selectedOption = saveContactController.getOption();
                        Navigator.push(context, createPageRoute(NewContactScreen(user: APIs.me, selectedOption: selectedOption)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ListTile(
                          leading: _buildIconContainer(Icons.person_add_alt_1_rounded, colorsController.getColor(colorsController.selectedColorScheme.value)),
                          title: Text(S.of(context).newContact, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.push(context, createPageRoute(QrCodeScreen(user: APIs.me, initialIndex: 1)));
                            },
                            child: const Icon(Icons.qr_code, color: ChatifyColors.grey),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(CreatedCommunityScreen(onCommunitySelected: (community) {})));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ListTile(
                          leading: _buildIconContainer(Icons.groups, colorsController.getColor(colorsController.selectedColorScheme.value)),
                          title: Text(S.of(context).newCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(S.of(context).contactsOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                ),
                ...chatUsers.map((chatUser) =>
                  UseAppUserCard(
                    user: chatUser,
                    isSelected: selectedUsers.contains(chatUser),
                    onUserSelected: _toggleUserSelection,
                    onLongPress: _handleLongPress,
                    onTap: () => _handleTap(chatUser),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Text(S.of(context).inviteOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                ),
                ...filteredContacts.map((contact) =>
                  InviteUserCard(
                    contact: contact,
                    onInvite: () {},
                    onContactSelected: (Contact selectedContact) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Icon(icon, color: ChatifyColors.white, size: 24),
    );
  }
}
