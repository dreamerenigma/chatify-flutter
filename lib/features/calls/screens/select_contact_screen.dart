import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/personalization/screens/qr_code/qr_code_screen.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/user_model.dart';
import '../../community/widgets/cards/invite_user_card.dart';
import '../../personalization/widgets/cards/use_app_user_card.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/buttons/animated_icon_button.dart';
import '../widgets/dialog/save_contact_dialog.dart';
import '../widgets/dialog/shedule_call_bottom_dialog.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<UserModel> _chatUsers = [];
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  bool _visibleFirst = false;
  bool _visibleSecond = false;
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
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _visibleFirst = true);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => _visibleSecond = true);
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
              Text(S.of(context).choose, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),),
              Text('$totalItemsCount ${S.of(context).selectContacts}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
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
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))))
        : Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: selectedUsers.isNotEmpty ? 115 : 0),
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                  child: Scrollbar(
                    thickness: 4,
                    thumbVisibility: false,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 4),
                      itemCount: totalItemsCount,
                      itemBuilder: (context, index) {
                        if (selectedUsers.isEmpty && index == 0) {
                          return _buildInitialActionTiles();
                        }
                        if (index == 1) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 6),
                            child: Text(S.of(context).contactsOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                          );
                        }
                        if (index > 1 && index <= _chatUsers.length + 1) {
                          final adjustedIndex = index - 2;
                          final chatUser = _chatUsers[adjustedIndex];
                          return UseAppUserCard(
                            user: chatUser,
                            isSelected: selectedUsers.contains(chatUser),
                            onUserSelected: _toggleUserSelection,
                          );
                        }
                        if (index == _chatUsers.length + 2) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Text(S.of(context).inviteOnApp, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
                          );
                        }
                        final filteredIndex = index - _chatUsers.length - 3;
                        if (filteredIndex >= 0 && filteredIndex < _filteredContacts.length) {
                          final contact = _filteredContacts[filteredIndex];
                          return InviteUserCard(
                            contact: contact,
                            onInvite: () {},
                            onContactSelected: (_) {},
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (selectedUsers.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white,
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSelectedUsersRow(),
                    Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                  ],
                ),
              ),
            ),
          ],
      ),
    );
  }

  Widget _buildSelectedUsersRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: selectedUsers.map((user) => _buildSelectedUserAvatar(user)).toList()),
            ),
          ),
          AnimatedIconButton(
            visible: _visibleFirst,
            icon: Icons.videocam_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          AnimatedIconButton(
            visible: _visibleSecond,
            icon: Icons.call_outlined,
            padding: 12,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedUserAvatar(UserModel user) {
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
                    radius: 25,
                    backgroundImage: null,
                    child: CachedNetworkImage(
                      imageUrl: user.image,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300),
                      ),
                      errorWidget: (context, url, error) => SvgPicture.asset(ChatifyVectors.profile, width: 50, height: 50),
                      imageBuilder: (context, imageProvider) => CircleAvatar(radius: 25, backgroundImage: imageProvider),
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
                  onTap: () => _toggleUserSelection(user),
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.black, width: 2)),
                    child: const CircleAvatar(backgroundColor: ChatifyColors.buttonSecondary, radius: 10, child: Icon(Icons.close, size: 16, color: ChatifyColors.black)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupLimitLabel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(S.of(context).addUpToThirtyOnePeople, style: TextStyle(fontFamily: 'Roboto', fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey), textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
        ),
      ],
    );
  }

  Widget _buildInitialActionTiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGroupLimitLabel(context),
        _buildActionTile(
          onTap: () {
            Navigator.push(context, createPageRoute(const CreateLinkCallScreen()));
          },
          icon: const Icon(Icons.link, color: ChatifyColors.black, size: 23),
          label: S.of(context).newLinkCall,
        ),
        const SizedBox(height: 6),
        _buildActionTile(
          onTap: () {
            Navigator.push(context, createPageRoute(const CallPhoneNumber()));
          },
          icon: const Icon(Icons.dialpad, color: ChatifyColors.black, size: 23),
          label: S.of(context).callNumber,
        ),
        const SizedBox(height: 6),
        _buildActionTile(
          onTap: () {
            final selectedOption = SaveContactController.instance.getOption();
            Navigator.push(context, createPageRoute(NewContactScreen(user: APIs.me, selectedOption: selectedOption)));
          },
          icon: SvgPicture.asset(ChatifyVectors.userAdd, color: ChatifyColors.black, width: 23, height: 23),
          label: S.of(context).newContact,
          trailing: InkWell(
            onTap: () {
              Navigator.push(context, createPageRoute(QrCodeScreen(user: APIs.me)));
            },
            child: const Icon(Icons.qr_code, color: ChatifyColors.darkGrey, size: 25),
          ),
        ),
        const SizedBox(height: 6),
        _buildActionTile(
          onTap: () => showSheduleCallBottomDialog(context, username: widget.user.name),
          icon: const Icon(UniconsLine.calendar_alt, color: ChatifyColors.black, size: 23),
          label: S.of(context).scheduleCall,
        ),
      ],
    );
  }

  Widget _buildActionTile({required VoidCallback onTap, required Widget icon, required String label, Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
              colorsController.getColor(colorsController.selectedColorScheme.value),
              radius: 21,
              child: icon,
            ),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              const Spacer(),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}
