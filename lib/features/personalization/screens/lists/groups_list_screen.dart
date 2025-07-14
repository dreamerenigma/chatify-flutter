import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/delete_list_dialog.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({super.key});

  @override
  State<GroupsListScreen> createState() => GroupsListScreenState();
}

class GroupsListScreenState extends State<GroupsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text('Группы', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(FluentIcons.delete_24_regular),
                onPressed: () {
                  showDeleteListDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Text(
                    'Этот список обновляется дял вас автоматически, отображая все групповые чаты.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ChatifyColors.buttonSecondary, fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Включены в список', style: TextStyle(color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal)),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                        child: Icon(Icons.group, size: 26, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white),
                      ),
                      const SizedBox(width: 16),
                      Text('Групповые чаты', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                      const Divider(height: 0, thickness: 1),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          )
      ),
    );
  }
}
