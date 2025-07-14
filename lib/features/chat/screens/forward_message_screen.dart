import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/group/screens/new_group_screen.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../api/apis.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../home/widgets/dialogs/widget/tiles/user_profile_tile.dart';
import '../../personalization/controllers/user_controller.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/user_model.dart';
import '../widgets/dialogs/confidentiality_bottom_dialog.dart';

class ForwardMessageScreen extends StatefulWidget {
  const ForwardMessageScreen({super.key});

  @override
  State<ForwardMessageScreen> createState() => ForwardMessageScreenState();
}

class ForwardMessageScreenState extends State<ForwardMessageScreen> {
  final TextEditingController searchController = TextEditingController();
  final userController = Get.find<UserController>();
  List<UserModel> list = [];
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<UserModel> chatUsers = [];
  List<UserModel> searchList = [];
  List<UserModel> selectedUsers = [];
  bool isSearching = false;
  bool isNumericMode = false;
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  FocusNode searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();
  late File file;
  UserModel? selectedUser;

  @override
  void initState() {
    super.initState();
    searchList = List.from(list);
    fetchContacts();
    fetchChatUsers();
    searchController.addListener(() {
      filterContacts();
    });
  }

  Future<void> fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        contacts = contacts;
        filteredContacts = List.from(contacts);
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

  void filterContacts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        final contactName = contact.displayName.toLowerCase();
        return contactName.contains(query);
      }).toList();
    });
  }

  void onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      searchList = list
          .where((user) =>
      user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      if (isSearching) {
        searchController.clear();
        searchFocusNode.unfocus();
        searchList = List.from(list);
      } else {
        searchFocusNode.requestFocus();
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
      searchFocusNode.requestFocus();
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
    final shadowColor = context.isDarkMode ? ChatifyColors.white.withAlpha((0.1 * 255).toInt()) : ChatifyColors.black.withAlpha((0.1 * 255).toInt());
    final isLoading = isFetchingContacts || isFetchingChatUsers;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 0,
                blurRadius: 0.5,
                offset: const Offset(0, 0.5),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
            titleSpacing: 0,
            title: isSearching
                ? TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              ),
              child: TextField(
                key: textFieldKey,
                focusNode: searchFocusNode,
                cursorColor: Colors.blue,
                controller: searchController,
                keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
                decoration: InputDecoration(
                  hintText: 'Поиск по имени или номеру телефона',
                  hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  onSearchChanged();
                },
              ),
            )
            : Text('Переслать...',
            style: TextStyle(fontSize: ChatifySizes.fontSizeMg)),
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
            actions: isSearching
                ? [
              IconButton(
                icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad),
                onPressed: _toggleInputMode,
              ),
            ]
                : [
              IconButton(
                icon: const Icon(Icons.group_add_outlined, size: 23),
                onPressed: () {
                  Navigator.push(context, createPageRoute(const NewGroupScreen()));
                },
              ),
              IconButton(
                icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search),
                onPressed: _toggleSearch,
              ),
            ],
          ),
        ),
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))))
        : ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
          child: ListView(
            children: [
              _buildStatus(),
              if (selectedUsers.isNotEmpty) ...[
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
                                  CircleAvatar(
                                    backgroundImage: user.image.isNotEmpty ? CachedNetworkImageProvider(user.image) : null,
                                    radius: 30,
                                    child: user.image.isEmpty ? SvgPicture.asset(ChatifyVectors.profile, width: 60, height: 60) : null,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text('Часто общаетесь', style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightSoftNight)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: UserProfileTile(
                      userController: userController,
                      titleFontSize: ChatifySizes.fontSizeMd,
                      titleFontWeight: FontWeight.w400,
                      subtitleFontSize: 15,
                      subtitleFontWeight: FontWeight.w300,
                      onTap: () {},
                      user: APIs.me,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text('Другие контакты', style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightSoftNight)),
              ),
              ...List.generate(chatUsers.length, (index) {
                final chatUser = chatUsers[index];

                return UseAppUserCard(
                  user: chatUser,
                  onUserSelected: (UserModel selectedUser) {
                    _toggleUserSelection(selectedUser);
                  },
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                );
              }),
            ],
          ),
        ),
    );
  }

  Widget _buildStatus() {
    return InkWell(
      onTap: () {},
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
              child: SvgPicture.asset(ChatifyVectors.statusAdd, width: 24, height: 24, color: ChatifyColors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Статус", style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    Text("Мои контакты", style: TextStyle(fontSize: 15, color: ChatifyColors.softBlack, fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showConfidentialityBottomSheet(context);
              },
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
                child: Icon(Icons.more_horiz, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
