import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/formatters/phone_formatter.dart';
import '../../chat/models/user_model.dart';
import '../../community/widgets/cards/invite_user_card.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import 'package:shimmer/shimmer.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';

class AddFavoriteScreen extends StatefulWidget {
  const AddFavoriteScreen({super.key});

  @override
  AddFavoriteScreenState createState() => AddFavoriteScreenState();
}

class AddFavoriteScreenState extends State<AddFavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<UserModel> _chatUsers = [];
  List<UserModel> _matchedChatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  Set<String> selectedUserIds = {};
  Set<Contact> selectedContacts = {};
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  bool isSelectionMode = false;
  Key textFieldKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterContacts);
  }

  void _findContactsOnApp() {
    final matched = <UserModel>[];

    for (final contact in _contacts) {
      final contactPhones = contact.phones.map((e) => PhoneFormatter.normalizePhone(e.number)).where((phone) => phone.isNotEmpty).toSet();

      for (final user in _chatUsers) {
        final userPhone = PhoneFormatter.normalizePhone(user.phoneNumber);

        if (userPhone.isNotEmpty && contactPhones.contains(userPhone)) {
          if (!matched.any((u) => u.id == user.id)) {
            matched.add(user);
          }
        }
      }
    }

    if (!mounted) return;

    setState(() {
      _matchedChatUsers = matched;
    });
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
      if (selectedUserIds.contains(user.id)) {
        selectedUserIds.remove(user.id);
      } else {
        selectedUserIds.add(user.id);
      }
    });
  }

  void _handleLongPress(UserModel user) {
    setState(() {
      isSelectionMode = true;
      selectedUserIds.add(user.id);
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      _fetchContacts(),
      _fetchChatUsers(),
    ]);

    _findContactsOnApp();
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

  @override
  Widget build(BuildContext context) {
    final isLoading = isFetchingContacts || isFetchingChatUsers;
    final hasSelectedUsers = selectedUserIds.isNotEmpty;
    final hasContactsOnApp = _matchedChatUsers.isNotEmpty;
    final itemCount = (hasSelectedUsers ? 1 : 0) + (hasContactsOnApp ? 1 + _matchedChatUsers.length : 0) + 1 + _filteredContacts.length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
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
                keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
                decoration: InputDecoration(
                  hintText: S.of(context).searchContacts,
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
                Text(S.of(context).addToFavorites, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
              ],
            ),
        actions: isSearching
        ? [
          IconButton(
            icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad),
            onPressed: _toggleInputMode,
          ),
        ]
        : [
          IconButton(
            icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))))
        : ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: ScrollbarTheme(
            data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
            child: Scrollbar(
              thickness: 4,
              thumbVisibility: false,
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  var currentIndex = index;

                  if (hasSelectedUsers) {
                    if (currentIndex == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: selectedUserIds.map((userId) {
                                final user = _chatUsers.firstWhere((user) => user.id == userId);

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
                                              backgroundImage: null,
                                              child: CachedNetworkImage(
                                                imageUrl: user.image,
                                                placeholder: (context, url) => Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300,
                                                  highlightColor: Colors.grey.shade100,
                                                  child: CircleAvatar(radius: 30, backgroundColor: Colors.grey.shade300),
                                                ),
                                                errorWidget: (context, url, error) => SvgPicture.asset(ChatifyVectors.profile, width: 60, height: 60),
                                                imageBuilder: (context, imageProvider) => CircleAvatar(radius: 30, backgroundImage: imageProvider),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              user.name.length > 7 ? '${user.name.substring(0, 7)}...' : user.name,
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
                                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.black, width: 2)),
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
                    }

                    currentIndex--;
                  }

                  if (hasContactsOnApp) {
                    if (currentIndex == 0) {
                      return Padding(padding: const EdgeInsets.all(16), child: Text(S.of(context).contactsOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold)));
                    }

                    currentIndex--;

                    if (currentIndex < _matchedChatUsers.length) {
                      final chatUser = _matchedChatUsers[currentIndex];

                      return UseAppUserCard(user: chatUser, isSelected: selectedUserIds.contains(chatUser.id), onUserSelected: _toggleUserSelection, onLongPress: _handleLongPress);
                    }

                    currentIndex -= _matchedChatUsers.length;
                  }

                  if (currentIndex == 0) {
                    return Padding(padding: const EdgeInsets.all(16), child: Text(S.of(context).inviteOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)));
                  }

                  currentIndex--;

                  if (currentIndex < _filteredContacts.length) {
                    final contact = _filteredContacts[currentIndex];

                    return InviteUserCard(contact: contact, onInvite: () {}, onContactSelected: (Contact selectedContact) {});
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'addFavorite',
          onPressed: () async {},
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: Icon(Icons.check_rounded, size: 28, color: ChatifyColors.black),
        ),
      ),
    );
  }
}
