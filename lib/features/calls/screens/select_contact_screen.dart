import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/personalization/screens/qr_code/qr_code_screen.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/user_model.dart';
import '../../community/widgets/cards/invite_user_card.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/dialog/save_contact_dialog.dart';
import 'call_phone_number.dart';
import 'create_link_call_screen.dart';
import 'new_contact_screen.dart';

class SelectContactScreen extends StatefulWidget {
  final UserModel user;
  const SelectContactScreen({super.key, required this.user});

  @override
  SelectContactScreenState createState() => SelectContactScreenState();
}

class SelectContactScreenState extends State<SelectContactScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<UserModel> _chatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();
  Set<UserModel> selectedUsers = {};

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
    int totalItemsCount = 0;

    if (!isLoading) {
      totalItemsCount += _chatUsers.length;
      totalItemsCount += _filteredContacts.length;

      if (selectedUsers.isEmpty) {
        totalItemsCount += 2;
      }

      if (selectedUsers.isNotEmpty) {
        totalItemsCount += 2;
      }
    }

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
            focusNode: _searchFocusNode,
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            controller: _searchController,
            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
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
            Text('Выбрать', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),),
            Text('$totalItemsCount контакта', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: isSearching
            ? [
          IconButton(icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad), onPressed: _toggleInputMode),
        ]
            : [
          IconButton(icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search), onPressed: _toggleSearch),
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
      )
      : ScrollConfiguration(
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
            child: ListView.builder(
              itemCount: totalItemsCount,
              itemBuilder: (context, index) {

                if (selectedUsers.isNotEmpty) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: selectedUsers.map((user) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
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
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              InkWell(
                                highlightColor: ChatifyColors.darkerGrey,
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.darkerGrey, width: 1)),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.videocam_outlined,
                                    color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    size: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                highlightColor: ChatifyColors.darkerGrey,
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.darkerGrey, width: 1)),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(Icons.call_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  }
                }

                if (selectedUsers.isEmpty && index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text('Добавьте до 30 человек', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                      ),
                      const Divider(height: 0, thickness: 1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, createPageRoute(const CreateLinkCallScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    radius: 23,
                                    child: const Icon(Icons.link, color: Colors.white, size: 23),
                                  ),
                                  const SizedBox(width: 16),
                                  Text('Новая ссылка на звонок', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, createPageRoute(const CallPhoneNumber()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    radius: 23,
                                    child: const Icon(Icons.dialpad, color: Colors.white, size: 23),
                                  ),
                                  const SizedBox(width: 16),
                                  Text('Позвонить на номер', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () {
                              final saveContactController = SaveContactController.instance;
                              final selectedOption = saveContactController.getOption();

                              Navigator.push(context, createPageRoute(NewContactScreen(user: APIs.me, selectedOption: selectedOption)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    radius: 23,
                                    child: const Icon(Icons.person_add, color: Colors.white, size: 23),
                                  ),
                                  const SizedBox(width: 16),
                                  Text('Новый контакт', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                  const SizedBox(width: 8),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, createPageRoute(QrCodeScreen(user: APIs.me)));
                                    },
                                    child: const Icon(Icons.qr_code, color: ChatifyColors.darkGrey, size: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ],
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Контакты в Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  );
                }

                if (index > 1 && index <= _chatUsers.length + 1) {
                  final adjustedIndex = index - 2;
                  final chatUser = _chatUsers[adjustedIndex];
                  return UseAppUserCard(
                    user: chatUser,
                    isSelected: selectedUsers.contains(chatUser),
                    onUserSelected: (UserModel selectedUser) {
                      _toggleUserSelection(selectedUser);
                    },
                  );
                }

                if (index == _chatUsers.length + 2) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Text('Пригласить в Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                  );
                }
                final filteredIndex = index - _chatUsers.length - 3;
                if (filteredIndex >= 0 && filteredIndex < _filteredContacts.length) {
                  final contact = _filteredContacts[filteredIndex];
                  return InviteUserCard(
                    contact: contact,
                    onInvite: () {},
                    onContactSelected: (Contact selectedContact) {},
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
