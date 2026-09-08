import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/widgets/cards/invite_user_card.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../widgets/cards/use_app_user_card.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AddToListScreen extends StatefulWidget {
  final UserModel user;

  const AddToListScreen({
    super.key,
    required this.user,
  });

  @override
  AddToListScreenState createState() => AddToListScreenState();
}

class AddToListScreenState extends State<AddToListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<UserModel> chatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  Set<UserModel> selectedUsers = {};
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  Key textFieldKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _fetchChatUsers();
    _searchController.addListener(() {
      _filterContacts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final result = await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        contacts = result;
        filteredContacts = List.from(result);
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
      filteredContacts = contacts.where((contact) {
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
    int totalItemsCount = 0;

    if (!isLoading) {
      totalItemsCount += chatUsers.length;
      totalItemsCount += filteredContacts.length;

      if (selectedUsers.isEmpty) {
        totalItemsCount += 2;
      }

      if (selectedUsers.isNotEmpty) {
        totalItemsCount += 2;
      }
    }

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
                  hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
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
        actions: [
          if (!isSearching)
            IconButton(icon: const Icon(Icons.search), onPressed: _toggleSearch),

          if (isSearching && _searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(CupertinoIcons.clear_circled_solid),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))))
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedUsers.isNotEmpty)
              _buildSelectedUsers()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(S.of(context).onlyYouSeeWhoLists, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: ChatifyColors.darkGrey)),
                  ),
                ],
              ),
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                  child: Scrollbar(
                    thickness: 4,
                    thumbVisibility: false,
                    child: ListView.builder(
                      itemCount: totalItemsCount,
                      itemBuilder: (context, index) {
                        if (chatUsers.isNotEmpty && index == 1) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 6),
                            child: Text(S.of(context).contactsOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm,)),
                          );
                        }

                        if (index >= 2 && index < chatUsers.length + 2) {
                          final adjustedIndex = index - 2;
                          final chatUser = chatUsers[adjustedIndex];

                          return UseAppUserCard(user: chatUser, showSelectionButton: true, isSelected: selectedUsers.contains(chatUser), onUserSelected: _toggleUserSelection);
                        }

                        if (index == chatUsers.length + 2) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Text(S.of(context).inviteOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                          );
                        }

                        final filteredIndex = index - chatUsers.length - 3;

                        if (filteredIndex >= 0 && filteredIndex < filteredContacts.length) {
                          final contact = filteredContacts[filteredIndex];

                          return InviteUserCard(contact: contact, onInvite: () {}, onContactSelected: (_) {});
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addList',
        onPressed: () async {},
        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        foregroundColor: ChatifyColors.black,
        child: const Icon(Icons.check),
      ),
    );
  }

  // New searching method
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, top: MediaQuery.of(context).padding.top + 5, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.isDarkMode ? ChatifyColors.popupColorDark.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.1 * 255).toInt()),
                  hintText: S.of(context).settingsSearch,
                  hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_back, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                    onPressed: _toggleSearch,
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedUsers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedUsers.map((user) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
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
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.black, width: 2.0)),
                                  child: const CircleAvatar(backgroundColor: ChatifyColors.grey, radius: 12, child: Icon(Icons.close, size: 16, color: ChatifyColors.black)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
