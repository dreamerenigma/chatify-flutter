import 'dart:developer';
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

class SendFileScreen extends StatefulWidget {
  final String fileToSend;
  final String linkToSend;

  const SendFileScreen({super.key, required this.fileToSend, required this.linkToSend});

  @override
  State<SendFileScreen> createState() => SendFileScreenState();
}

class SendFileScreenState extends State<SendFileScreen> {
  final TextEditingController searchController = TextEditingController();
  List<UserModel> list = [];
  List<UserModel> searchList = [];
  List<UserModel> selectedUsers = [];
  bool isSearching = false;
  bool isNumericMode = false;
  FocusNode searchFocusNode = FocusNode();
  Key textFieldKey = UniqueKey();

  late File file;
  UserModel? selectedUser;

  @override
  void initState() {
    super.initState();
    file = File(widget.fileToSend);
    log('fileToSend: ${widget.fileToSend}');
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

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.isDarkMode ? ChatifyColors.white.withAlpha((0.1 * 255).toInt()) : ChatifyColors.black.withAlpha((0.1 * 255).toInt());

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
            title: isSearching
              ? TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Colors.blue,
                  selectionColor: Colors.blue.withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: Colors.blue,
                ),
                child: TextField(
                key: textFieldKey,
                focusNode: searchFocusNode,
                cursorColor: Colors.blue,
                controller: searchController,
                keyboardType: isNumericMode ? TextInputType.number : TextInputType.text,
                style: TextStyle(
                  fontSize: ChatifySizes.fontSizeMd, letterSpacing: 0.5),
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone number',
                    hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _onSearchChanged();
                  },
                ),
              )
            : Text(S.of(context).sendFile,
              style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
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
      body: Stack(
        children: [
          UserList(
            isSearching: isSearching,
            searchList: searchList,
            list: list,
            isSharing: true,
            onUserSelected: _onUserSelected,
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
                  Text(
                    selectedUser!.name,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward, size: 30),
                      onPressed: _onArrowPressed,
                      color: Colors.white,
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
