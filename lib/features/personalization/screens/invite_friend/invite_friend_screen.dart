import 'package:chatify/features/community/widgets/cards/invite_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  InviteFriendScreenState createState() => InviteFriendScreenState();
}

class InviteFriendScreenState extends State<InviteFriendScreen> {
  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isSearching = false;

  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      List<Contact> contactsFromDevice = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contacts = contactsFromDevice;
        filteredContacts = contactsFromDevice;
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
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
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
              : Text('Пригласить друга', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (isSearching) {
                    toggleSearch();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: Icon(isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
                  onPressed: toggleSearch,
                ),
              ],
            ),
          ),
        ),
        body: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: ListView.builder(
            itemCount: filteredContacts.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  onTap: () {
                    Share.share('Давайте будем общаться в Chatify. Это быстрое, удобное и безопасное приложение для бесплатного общения друг с другом. Скачать https://inputstudios.ru/download');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Поделиться ссылкой',
                                style: TextStyle(
                                  fontSize: ChatifySizes.fontSizeMd,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (index == 1) {
                return const SizedBox(height: 15);
              } else if (index == 2) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: Text(
                    'Из контактов',
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeSm,
                    ),
                  ),
                );
              } else {
                final contactIndex = index - 3;
                final contact = filteredContacts[contactIndex];
                return InviteUserCard(
                  contact: contact,
                  onInvite: () {},
                  onContactSelected: (Contact selectedContact) {},
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
