import 'dart:developer';
import 'package:chatify/features/chat/screens/send_contact_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/user_model.dart';
import '../../newsletter/models/newsletter_model.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../../utils/widgets/images/user_avatar_image.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';

class ContactsSendingScreen extends StatefulWidget {
  final UserModel user;
  final List<UserModel> selectedUsers;

  const ContactsSendingScreen({
    super.key,
    required this.user,
    required this.selectedUsers,
  });

  @override
  ContactsSendingScreenState createState() => ContactsSendingScreenState();
}

class ContactsSendingScreenState extends State<ContactsSendingScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int selectedIndex = 0;
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<UserModel> chatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  List<NewsletterModel> newsletters = [];
  Set<UserModel> selectedUsers = {};
  Key textFieldKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _fetchNewsletter();
    _fetchChatUsers();
    _searchController.addListener(() {
      _filterContacts();
    });
    _loadProfileImage();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredContacts = contacts.where((contact) {
        final contactName = (contact.displayName ?? '').toLowerCase();

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

  Future<void> _fetchNewsletter() async {
    try {
      final permissionStatus =
      await FlutterContacts.permissions.request(PermissionType.read);

      if (permissionStatus == PermissionStatus.granted) {
        final contactsFromDevice = await FlutterContacts.getAll(
          properties: {
            ContactProperty.name,
            ContactProperty.phone,
          },
        );

        if (!mounted) return;

        setState(() {
          contacts = contactsFromDevice;
          filteredContacts = List.from(contactsFromDevice);
          isFetchingContacts = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          isFetchingContacts = false;
        });
      }
    } catch (e) {
      log('Error fetching contacts: $e');

      if (!mounted) return;

      setState(() {
        isFetchingContacts = false;
      });
    }
  }

  Future<void> fetchNewsletters() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Newsletters').get();
      setState(() {
        newsletters = querySnapshot.docs.map((doc) => NewsletterModel.fromDocument(doc)).toList();
      });
    } catch (e) {
      log('Error fetching newsletters: $e');
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

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = isFetchingContacts || isFetchingChatUsers;
    final currentUserId = APIs.me.id;
    final filteredChatUsers = chatUsers.where((user) => user.id != currentUserId).toList();
    final filteredContactsList = filteredContacts.where((contact) => contact.id != currentUserId).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
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
                controller: _searchController,
                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
                keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  hintText: S.of(context).searchContacts,
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
                Text(S.of(context).contactsSending, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                const SizedBox(height: 4),
                Text(
                  '${selectedUsers.length == 1 ? 'Выбран' : 'Выбрано'}: ${selectedUsers.length}',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
                ),              ],
            ),
        actions: isSearching
          ? [
              IconButton(
                icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad, size: 25),
                onPressed: _toggleInputMode,
              ),
            ]
          : [
              IconButton(
                icon: Icon(isSearching ? CupertinoIcons.clear_circled : Icons.search, size: 25),
                onPressed: _toggleSearch,
              ),
            ],
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))))
        : ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ListView.builder(
                itemCount: filteredChatUsers.length + filteredContactsList.length + 3 + (selectedUsers.isEmpty ? 0 : 1),
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
                                  key: ValueKey(user.id),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        UserAvatarImage(user: user, radius: 27),
                                        Positioned(
                                          bottom: -3,
                                          right: -7,
                                          child: GestureDetector(
                                            onTap: () => _toggleUserSelection(user),
                                            child: Container(
                                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.black, width: 2)),
                                              child: const CircleAvatar(
                                                backgroundColor:
                                                ChatifyColors.darkGrey,
                                                radius: 10,
                                                child: Icon(Icons.close_rounded, size: 16, color: ChatifyColors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        user.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 5, bottom: 0),
                        ],
                      );
                    }

                    adjustedIndex--;
                  }
                  if (adjustedIndex == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
                      child: Text('Вы', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                    );
                  }
                  adjustedIndex--;
                  if (adjustedIndex == 0) {
                    return UseAppUserCard(
                      user: APIs.me,
                      showSelectionButton: true,
                      onUserSelected: _toggleUserSelection,
                      isSelected: selectedUsers.any((user) => user.id == APIs.me.id),
                    );
                  }
                  adjustedIndex--;
                  if (adjustedIndex == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 6),
                      child: Text(
                        S.of(context).contactsOnApp,
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                      ),
                    );
                  }
                  adjustedIndex--;
                  if (adjustedIndex < filteredChatUsers.length) {
                    final chatUser = filteredChatUsers[adjustedIndex];

                    return UseAppUserCard(
                      user: chatUser,
                      showSelectionButton: true,
                      isSelected: selectedUsers.any((user) => user.id == chatUser.id),
                      onUserSelected: _toggleUserSelection,
                    );
                  }

                  adjustedIndex -= filteredChatUsers.length;

                  final filteredIndex = adjustedIndex - 1;

                  if (filteredIndex >= 0 && filteredIndex < filteredContactsList.length) {
                    final contact = filteredContactsList[filteredIndex];

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
          heroTag: 'sendContact',
          onPressed: () async {
            if (selectedUsers.isEmpty) return;

            Navigator.push(context, MaterialPageRoute(builder: (context) => SendContactScreen(users: List<UserModel>.from(selectedUsers), user: widget.user)));
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: const Icon(Icons.arrow_forward_rounded, size: 25, color: ChatifyColors.black),
        ),
      ),
    );
  }
}
