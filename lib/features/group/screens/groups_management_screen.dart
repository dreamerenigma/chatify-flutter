import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/widgets/dialogs/delete_list_dialog.dart';

class GroupsManagementScreen extends StatelessWidget {
  const GroupsManagementScreen({super.key});

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
            title: Text(S.of(context).groups, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(FluentIcons.delete_24_regular, size: 25),
                onPressed: () {
                  showDeleteListDialog(context, title: S.of(context).groups);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(child: Text(
                'Этот список обновляется для вас автоматически, отражая все групповые чаты.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400)),
              ),
            ),
            const SizedBox(height: 30),
            Text('Включить', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400)),
            const SizedBox(height: 15),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softGrey),
                  child: Icon(Icons.group, size: 25, color: ChatifyColors.steelGrey),
                ),
                const SizedBox(width: 15),
                Text('Групповые чаты', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
