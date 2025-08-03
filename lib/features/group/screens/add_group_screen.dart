import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../community/widgets/community_widget.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class AddGroupScreen extends StatelessWidget {
  final DateTime? createdAt;

  const AddGroupScreen({
    super.key,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.isDarkMode ? Colors.white.withAlpha((0.1 * 255).toInt()) : Colors.black.withAlpha((0.1 * 255).toInt());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).managingGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                Text('2 из 101', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                    child: const Icon(Icons.group, color: ChatifyColors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    S.of(context).newGroup,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: ChatifyColors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(S.of(context).addNounGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(S.of(context).membersCanProposeExistingGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Text(S.of(context).groupsInCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
          ),
          Expanded(
            child: CommunityWidgets(
              createdAt: createdAt,
              isValidDate: (date) => true,
              showAllButton: false,
              isInteractive: false,
              community: APIs.community!,
            ),
          ),
        ],
      ),
    );
  }
}
