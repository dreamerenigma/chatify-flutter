import 'package:chatify/features/group/widgets/cards/group_card.dart';
import 'package:chatify/features/group/widgets/cards/newsletter_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../newsletter/models/newsletter_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/group_model.dart';
import '../widgets/cards/status_card.dart';

class AddGroupsScreen extends StatefulWidget {
  final List<UserModel> selectedUsers;

  const AddGroupsScreen({
    super.key,
    required this.selectedUsers,
  });

  @override
  State<AddGroupsScreen> createState() => _AddGroupsScreenState();
}

class _AddGroupsScreenState extends State<AddGroupsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool isFetchingContacts = true;
  bool isFetchingChatUsers = true;
  bool isSearching = false;
  bool isNumericMode = false;
  Key textFieldKey = UniqueKey();
  List<NewsletterModel> newsletters = [];
  List<GroupModel> groups = [];

  void _toggleSearch() {
    setState(() {
      if (isSearching) {
        _searchController.clear();
        _searchFocusNode.unfocus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
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
                  hintText: S.of(context).searchByNameOrPhoneNumber,
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
                Text('Добавление в группы', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                Text('Выбрано: 0 из 10', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal)),
              ],
            ),
        actions: isSearching
          ? [IconButton(icon: Icon(isNumericMode ? Icons.keyboard : Icons.dialpad), onPressed: _toggleInputMode)]
          : [IconButton(icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search), onPressed: _toggleSearch)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text('Выберите группу', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    StatusCard(),
                    const SizedBox(height: 10),
                    // NewsletterCard(newsletter: newsletter, onChanged: (bool value) {}),
                    // const SizedBox(height: 10),
                    // GroupCard(group: group),
                  ],
                ),
                Positioned.fill(child: Container(color: Colors.black.withAlpha(100))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
