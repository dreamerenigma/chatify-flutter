import 'package:flutter/material.dart';
import '../../../chat/models/user_model.dart';
import '../../models/blocked_user.dart';
import '../cards/blocked_user_card.dart';

class BlockedUserList extends StatelessWidget {
  final List<BlockedUser> blockedUser;
  final UserModel user;

  const BlockedUserList({super.key, required this.blockedUser, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
      child: Column(
        children: blockedUser.map((group) {
          return BlockedUserCard(
            user: user,
          );
        }).toList(),
      ),
    );
  }
}
