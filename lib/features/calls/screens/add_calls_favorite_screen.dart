import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../chat/models/user_model.dart';
import '../../community/widgets/cards/invite_user_card.dart';
import '../../group/screens/add_new_group_screen.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import 'package:shimmer/shimmer.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';

class AddCallsFavoriteScreen extends StatefulWidget {
  const AddCallsFavoriteScreen({super.key});

  @override
  AddCallsFavoriteScreenState createState() => AddCallsFavoriteScreenState();
}

class AddCallsFavoriteScreenState extends State<AddCallsFavoriteScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<UserModel> _chatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  bool isSelectionMode = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();
  Set<UserModel> selectedUsers = {};
  Set<Contact> selectedContacts = {};

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
            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            controller: _searchController,
            keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
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
            Text(
              'Добавить в Избранное',
              style: TextStyle(
                fontSize: ChatifySizes.fontSizeBg,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  } else {
                    adjustedIndex = index - 1;
                  }
                }

                if (adjustedIndex == 0) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Контакты в Chatify', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  );
                } else if (adjustedIndex <= _chatUsers.length) {
                  final chatUser = _chatUsers[adjustedIndex - 1];
                  return UseAppUserCard(
                    user: chatUser,
                    isSelected: selectedUsers.contains(chatUser),
                    onUserSelected: _toggleUserSelection,
                    onLongPress: _handleLongPress,
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          heroTag: 'group',
          onPressed: () async {
            if (selectedUsers.isEmpty) {
              Dialogs.showSnackbar(context, 'Должен быть выбран минимум 1 контакт');
            } else {
              Navigator.push(
                context,
                createPageRoute(AddNewGroupScreen(selectedUsers: selectedUsers.toList(), selectedContacts: selectedContacts.toList())),
              );
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: Colors.white,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
