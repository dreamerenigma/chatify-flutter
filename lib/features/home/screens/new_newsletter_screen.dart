import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../generated/l10n/l10n.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../newsletter/models/newsletter_model.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class NewNewsletterScreen extends StatefulWidget {
  final List<UserModel> selectedUsers;

  const NewNewsletterScreen({super.key, required this.selectedUsers});

  @override
  NewNewsletterScreenState createState() => NewNewsletterScreenState();
}

class NewNewsletterScreenState extends State<NewNewsletterScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<UserModel> _chatUsers = [];
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

  Future<void> fetchNewsletters() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Newsletters').get();
      setState(() {
        newsletters = querySnapshot.docs.map((doc) => NewsletterModel.fromDocument(doc)).toList();
      });
    } catch (e) {
      log('${S.of(context).errorFetchingNewsletters}: $e');
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
            Text(S.of(context).newsletter, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(S.of(context).selected, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)),
        ),
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
                                    CircleAvatar(backgroundImage: NetworkImage(user.image), radius: 30),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.name.length > 7 ? '${user.name.substring(0, 7)}...' : user.name,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeLm),
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
                                        child: Icon(Icons.close, size: 16, color: ChatifyColors.black,
                                        ),
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

          if (adjustedIndex == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: S.of(context).onlyContactsPhoneNumber,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 8),
              ],
            );
          } else if (adjustedIndex <= _chatUsers.length) {
            final chatUser = _chatUsers[adjustedIndex - 1];
            return Column(
              children: [
                UseAppUserCard(
                  user: chatUser,
                  onUserSelected: (UserModel selectedUser) {
                    _toggleUserSelection(selectedUser);
                  },
                ),
              ],
            );
          }
          return null;
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'newsletterList',
          onPressed: () async {
            final newsletterName = textController.text.trim();
            final newsletters = selectedUsers.map((user) => user.id).toList();

            if (selectedUsers.length < 2) {
              Dialogs.showSnackbar(context, S.of(context).leastTwoContactsMustBeSelected);
              return;
            }

            final createdAt = DateTime.now().millisecondsSinceEpoch.toString();
            final newsletter = NewsletterModel(
              id: '',
              newsletterImage: '',
              newsletterName: newsletterName,
              creatorName: APIs.user.displayName ?? S.of(context).unknownUser,
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
          foregroundColor: ChatifyColors.white,
          child: const Icon(Icons.check),
        ),
      )
    );
  }
}
