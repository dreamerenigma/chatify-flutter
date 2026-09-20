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
import '../../../utils/formatters/phone_formatter.dart';
import '../../../utils/popups/dialogs.dart';
import '../../calls/widgets/dialog/save_contact_dialog.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../chat/models/user_model.dart';
import '../../chat/screens/chat_screen.dart';
import '../../community/screens/created_community_screen.dart';
import '../../community/widgets/cards/invite_user_card.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../widgets/items/app_action_menu_item.dart';
import 'contacts_screen.dart';
import '../../newsletter/screens/new_newsletter_screen.dart';

class HomeSelectUserScreen extends StatefulWidget {
  final bool isFavoritesMode;

  const HomeSelectUserScreen({
    super.key,
    this.isFavoritesMode = false,
  });

  @override
  State<HomeSelectUserScreen> createState() => _HomeSelectUserScreenState();
}

class _HomeSelectUserScreenState extends State<HomeSelectUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool isSearching = false;
  bool isNumericMode = false;
  bool isLoading = false;
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSelectionMode = false;
  Key textFieldKey = UniqueKey();
  List<Contact> _contacts = [];
  List<Contact> filteredContacts = [];
  List<UserModel> matchedChatUsers = [];
  List<UserModel> chatUsers = [];
  List<UserModel> searchList = [];
  List<UserModel> list = [];
  Set<UserModel> selectedUsers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterContacts);
    if (widget.isFavoritesMode) {
      isSearching = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      });
    }
  }

  Future<void> _loadData() async {
    await Future.wait([
      fetchContacts(),
      fetchChatUsers(),
    ]);

    _findContactsOnApp();
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

  void _findContactsOnApp() {
    final matched = <UserModel>[];

    for (final contact in _contacts) {
      final contactPhones = contact.phones.map((e) => PhoneFormatter.normalizePhone(e.number)).where((phone) => phone.isNotEmpty).toSet();

      for (final user in chatUsers) {
        final userPhone =
        PhoneFormatter.normalizePhone(user.phoneNumber);

        if (userPhone.isNotEmpty && contactPhones.contains(userPhone)) {
          if (!matched.any((u) => u.id == user.id)) {
            matched.add(user);
          }
        }
      }
    }

    if (!mounted) return;

    setState(() {
      matchedChatUsers = matched;
    });
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
              return;
            }

            if (widget.isFavoritesMode) {
              Navigator.pop(context);
              return;
            }

            if (isSearching) {
              _toggleSearch();
              return;
            }

            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: isSelectionMode
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${selectedUsers.length}', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, createPageRoute(const NewNewsletterScreen(selectedUsers: [])));
                  },
                  style: TextButton.styleFrom(foregroundColor: ChatifyColors.steelGrey, splashFactory: NoSplash.splashFactory),
                  child: Text(
                    S.of(context).newMailing,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, createPageRoute(const NewGroupScreen()));
                  },
                  style: TextButton.styleFrom(foregroundColor: ChatifyColors.steelGrey, splashFactory: NoSplash.splashFactory),
                  child: Text(
                    S.of(context).newGroup,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            )
          : isSearching
            ?  _buildSearchField()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).choose, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  SizedBox(height: 3),
                  Text('$totalItemsCount ${S.of(context).totalCountContacts}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
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
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 2.5),
                    ),
                  ),
                IconButton(
                  icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search),
                  onPressed: _toggleSearch,
                ),
              ],
            ),
          TooltipTheme(
            data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: PopupMenuButton<int>(
                tooltip: S.of(context).more,
                position: PopupMenuPosition.under,
                offset: const Offset(-8, 0),
                menuPadding: EdgeInsets.symmetric(vertical: 4),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 200),
                icon: const Icon(Icons.more_vert),
                color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                    }

                    return ChatifyColors.transparent;
                  }),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Настройки контакта',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(const ContactsScreen()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).inviteFriend,
                      onTap: () {
                        Navigator.pop(context);
                        SharePlus.instance.share(ShareParams(text: S.of(context).letsChatInApp));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).contacts,
                      onTap: () async {
                        Navigator.pop(context);
                        const intent = AndroidIntent(action: 'android.intent.action.VIEW', data: 'content://contacts/people', package: 'com.android.contacts', flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK]);
                        try {
                          await intent.launch();
                        } catch (e) {
                          Dialogs.showSnackbar(context, S.of(context).failedOpenContacts);
                        }
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).update,
                      onTap: () {
                        Navigator.pop(context);
                        _updateContacts();
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).help,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, createPageRoute(const HelpCenterScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: ListView(
              children: [
                if (!widget.isFavoritesMode)
                  Column(
                    children: [
                      SizedBox(height: 8),
                      AppActionMenuItem(
                        icon: _buildIconContainer(Icons.group_add, iconSize: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        title: S.of(context).newGroup,
                        onTap: () {
                          Navigator.push(context, createPageRoute(const NewGroupScreen()));
                        },
                      ),
                      AppActionMenuItem(
                        icon: _buildIconContainer(Icons.person_add_alt_1_rounded, iconSize: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        title: S.of(context).newContact,
                        onTap: () {
                          final saveContactController = SaveContactController.instance;
                          final selectedOption = saveContactController.getOption();

                          Navigator.push(context, createPageRoute(NewContactScreen(user: APIs.me, selectedOption: selectedOption)));
                        },
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.push(context, createPageRoute(QrCodeScreen(user: APIs.me, initialIndex: 1)));
                          },
                          child: const Icon(Icons.qr_code, size: 24, color: ChatifyColors.grey),
                        ),
                      ),
                      AppActionMenuItem(
                        icon: _buildIconContainer(Icons.groups, iconSize: 26, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        title: S.of(context).newCommunity,
                        subtitle: 'Объединяйте группы по темам',
                        onTap: () {
                          Navigator.push(context, createPageRoute(CreatedCommunityScreen(onCommunitySelected: (community) {})));
                        },
                      ),
                    ],
                  ),
                if (matchedChatUsers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(S.of(context).contactsOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
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
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(S.of(context).inviteOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
                ...filteredContacts.map((contact) =>
                  InviteUserCard(
                    contact: contact,
                    onInvite: () {},
                    onContactSelected: (Contact selectedContact) {},
                  ),
                ),
                _buildOptionItem(
                  icon: Icons.share,
                  text: S.of(context).newMailing,
                  onTap: () {},
                ),
                _buildOptionItem(
                  icon: Icons.question_mark_rounded,
                  text: S.of(context).newMailing,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextSelectionTheme(
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
          hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: isSearching ? IconButton(icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad, size: 24, color: ChatifyColors.darkGrey), onPressed: _toggleInputMode): null,
          contentPadding: EdgeInsets.only(top: 12)
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, {double iconSize = 24, required Color color}) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Icon(icon, color: ChatifyColors.black, size: iconSize),
    );
  }

  Widget _buildOptionItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 25, color: ChatifyColors.darkGrey),
            const SizedBox(width: 25),
            Expanded(
              child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
