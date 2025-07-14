import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../chat/models/user_model.dart';
import '../../newsletter/models/newsletter.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/cards/contacts_send_card.dart';

class ContactsSendingScreen extends StatefulWidget {
  final List<UserModel> selectedUsers;

  const ContactsSendingScreen({super.key, required this.selectedUsers});

  @override
  ContactsSendingScreenState createState() => ContactsSendingScreenState();
}

class ContactsSendingScreenState extends State<ContactsSendingScreen> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<UserModel> chatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  List<NewsletterModel> newsletters = [];
  int selectedIndex = 0;
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  final TextEditingController textController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();

  Set<UserModel> selectedUsers = {};

  @override
  void initState() {
    super.initState();
    _fetchNewsletter();
    _fetchChatUsers();

    _searchController.addListener(() {
      _filterContacts();
    });
  }

  Future<void> _fetchNewsletter() async {
    if (await Permission.contacts.request().isGranted) {
      var contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contacts = contacts.toList();
        filteredContacts = List.from(contacts);
        isFetchingContacts = false;
      });
    } else {
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
            controller: _searchController,
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
            keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
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
            Text(S.of(context).contactsSending, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
            const SizedBox(height: 4),
            Text('${S.of(context).selected} ${selectedUsers.length}', style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.normal)),
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
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
        )
        : ScrollbarTheme(
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
            child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ListView.builder(
                  itemCount: chatUsers.length + filteredContacts.length + 2 + (selectedUsers.isEmpty ? 0 : 2),
                  itemBuilder: (context, index) {
                  int adjustedIndex = index;

                  if (selectedUsers.isNotEmpty) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              children: selectedUsers.map((user) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .03),
                                              child: CachedNetworkImage(
                                                width: DeviceUtils.getScreenHeight(context) * .055,
                                                height: DeviceUtils.getScreenHeight(context) * .055,
                                                imageUrl: user.image,
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) => CircleAvatar(
                                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                  backgroundImage: NetworkImage(user.image),
                                                  foregroundColor: Colors.white,
                                                  child: const Icon(CupertinoIcons.person),
                                                ),
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
                                              child: const CircleAvatar(
                                                backgroundColor: ChatifyColors.grey,
                                                radius: 12,
                                                child: Icon(Icons.close, size: 16, color: ChatifyColors.black),
                                              ),
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

                  final filteredIndex = index - chatUsers.length;
                  if (adjustedIndex > 0 && adjustedIndex <= chatUsers.length) {
                    final chatUser = chatUsers[adjustedIndex - 1];
                    return ContactsSendCard(
                      user: chatUser,
                      contact: filteredContacts[filteredIndex],
                      isSelected: selectedUsers.contains(chatUser),
                      onUserSelected: _toggleUserSelection,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          heroTag: 'newsletterList',
          onPressed: () async {
            final newsletterName = textController.text.trim();
            final newsletters = selectedUsers.map((user) => user.id).toList();

            if (selectedUsers.length < 2) {
              Dialogs.showSnackbar(context, S.of(context).atLeastTwoContactsSelected);
              return;
            }

            final createdAt = DateTime.now().millisecondsSinceEpoch.toString();
            log('Created at timestamp: $createdAt');

            final newsletter = NewsletterModel(
              id: '',
              newsletterImage: '',
              newsletterName: newsletterName,
              creatorName: APIs.user.displayName ?? 'Unknown User',
              newsletters: newsletters,
              createdAt: createdAt,
            );

            bool isSuccess = await APIs.createNewsletter(context, newsletter);

            if (isSuccess) {
              Navigator.pop(context, newsletter);
            } else {
              Get.snackbar(S.of(context).error, S.of(context).errorCreatingMailingList);
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: Colors.white,
          child: const Icon(Icons.arrow_forward_rounded, color: ChatifyColors.black),
        ),
      ),
    );
  }
}
