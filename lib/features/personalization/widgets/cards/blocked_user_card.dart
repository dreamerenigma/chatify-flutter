import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../chat/models/user_model.dart';

class BlockedUserCard extends StatelessWidget {
  final UserModel user;

  const BlockedUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                width: 50,
                height: 50,
                imageUrl: user.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const CircleAvatar(backgroundColor: ChatifyColors.blue, foregroundColor: ChatifyColors.white, child: Icon(CupertinoIcons.person)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(user.phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500, color: ChatifyColors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
