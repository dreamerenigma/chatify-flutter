import 'dart:io';
import 'package:chatify/features/group/screens/new_group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/screens/edit_image_screen.dart';
import '../../../home/widgets/lists/user_list.dart';
import '../../widgets/dialogs/light_dialog.dart';

class SendFileScreen extends StatefulWidget {
  final String fileToSend;
  final String linkToSend;

  const SendFileScreen({
    super.key,
    required this.fileToSend,
    required this.linkToSend,
  });

  @override
  State<SendFileScreen> createState() => SendFileScreenState();
}

class SendFileScreenState extends State<SendFileScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isNumericMode = false;
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  List<UserModel> selectedUsers = [];
  FocusNode searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();

  late File file;
  UserModel? selectedUser;

  @override
  void initState() {
    super.initState();
    file = File(widget.fileToSend);
    searchList = List.from(list);
  }

  void _onUserSelected(UserModel user) {
    setState(() {
      selectedUser = user;
    });
  }

  void _onArrowPressed() {
    if (selectedUser != null) {
      Navigator.push(context, createPageRoute(EditImageScreen(fileToSend: file, user: selectedUser!)));
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();

    setState(() {
      searchList = list.where((user) => user.name.toLowerCase().contains(query) || user.email.toLowerCase().contains(query)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
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
                  controller: searchController,
                  keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, letterSpacing: 0.5),
                    decoration: InputDecoration(
                      hintText: S.of(context).searchByNameOrPhoneNumber,
                      hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _onSearchChanged();
                    },
                  ),
                )
              : Text('${S.of(context).send}...', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
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
            actions: isSearching
              ? [
                  IconButton(icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad), onPressed: _toggleInputMode),
                ]
              : [
                  IconButton(
                    icon: const Icon(Icons.group_add_outlined, size: 23),
                    onPressed: () {
                      Navigator.push(context, createPageRoute(NewGroupScreen(selectedUsers: selectedUsers)));
                    },
                  ),
                  IconButton(icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search), onPressed: _toggleSearch),
                ],
          ),
        ),
      ),
      body: Stack(
        children: [
          UserList(
            isSearching: isSearching,
            searchList: searchList,
            list: list,
            isSharing: true,
            onUserSelected: _onUserSelected,
            selectedUserIds: {},
            pinnedChats: const {},
            mutedChats: const {},
          ),
          if (selectedUser != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: ChatifyColors.cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedUser!.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward, size: 30),
                      onPressed: _onArrowPressed,
                      color: ChatifyColors.white,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
