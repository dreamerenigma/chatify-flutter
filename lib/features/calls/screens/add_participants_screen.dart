import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../api/apis.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import 'create_link_call_screen.dart';

class AddParticipantsScreen extends StatefulWidget {
  const AddParticipantsScreen({super.key});

  @override
  AddParticipantsScreenState createState() => AddParticipantsScreenState();
}

class AddParticipantsScreenState extends State<AddParticipantsScreen> {
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
      filteredContacts = contacts.where((contact) =>
      contact.displayName.toLowerCase().contains(query.toLowerCase())).toList();
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
    final CallTypeController callTypeController = Get.put(CallTypeController());
    final isLoading = isFetchingContacts || isFetchingChatUsers;
    int totalItemsCount = chatUsers.length + filteredContacts.length;

    if (!isLoading) {
      totalItemsCount += chatUsers.length;
      totalItemsCount += filteredContacts.length;

      if (selectedUsers.isEmpty) {
        totalItemsCount += 1;
      }

      if (selectedUsers.isNotEmpty) {
        totalItemsCount += 1;
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
                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                ),
                child: TextField(
                  focusNode: searchFocusNode,
                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
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
                  Text(S.of(context).addingParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  Text('$totalItemsCount ${S.of(context).totalCountContacts}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
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
          itemCount: filteredContacts.length + 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                onTap: () {
                  String invitationLink = _buildInvitationLink(context, callTypeController.selectedCallType.value, callTypeController.invitationId.value);
                  SharePlus.instance.share(ShareParams(text: invitationLink));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                        child: const Icon(Icons.share_outlined, color: ChatifyColors.white, size: 26),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).shareLink, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (index == 1) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Text(S.of(context).otherContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
              );
            } else {
              final adjustedIndex = index - 2;
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

String _buildInvitationLink(BuildContext context, String callType, String invitationId) {
  String callPath = callType == 'Видео' ? 'video' : 'voice';
  return '${S.of(context).joinMyAppAudioCallLink}: https://call.chatify.inputstudios.ru/$callPath/$invitationId';
}
