import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../chat/models/user_model.dart';
import '../input/search_text_input.dart';
import '../lists/archive_list.dart';

class ArchiveWidget extends StatefulWidget {
  final List<UserModel> users;
  final bool isSearching;
  final List<UserModel> searchList;
  final List<UserModel> archivedUsers;
  final UserModel user;

  const ArchiveWidget({
    super.key,
    required this.isSearching,
    required this.searchList,
    required this.users,
    required this.archivedUsers,
    required this.user,
  });

  @override
  State<ArchiveWidget> createState() => ArchiveWidgetState();
}

class ArchiveWidgetState extends State<ArchiveWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final TextEditingController favoriteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset(0, 0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).inArchive, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SearchTextInput(hintText: S.of(context).searchInChatSArchive, controller: favoriteController, padding: EdgeInsets.all(16)),
                SlideTransition(
                  position: _slideAnimation,
                  child: Visibility(
                    visible: widget.users.isEmpty,
                    child: ArchiveList(
                      isSearching: widget.isSearching,
                      searchList: widget.searchList,
                      archivedUsers: widget.archivedUsers,
                      onUserSelected: (user) {},
                      user: widget.user,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
