import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/edit_lists_favorite_bottom_dialog.dart';
import 'add_list_screen.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => FavoriteListScreenState();
}

class FavoriteListScreenState extends State<FavoriteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
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
            title: Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showEditListsFavoriteBottomSheet(context);
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Text(
                    S.of(context).usePencilChangeOrderLists,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ChatifyColors.buttonSecondary, fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.of(context).includedInList, style: TextStyle(color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal)),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Navigator.push(context, createPageRoute(AddListScreen(user: APIs.me)));
                  },
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.darkerGrey,
                          child: Icon(Icons.add_rounded, size: 26, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                        ),
                        const SizedBox(width: 16),
                        Text(S.of(context).addPeopleOrGroupsFavorite, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        const Divider(height: 0, thickness: 1),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                  child: Text(
                    S.of(context).editYourFavoritesChange,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ChatifyColors.buttonSecondary, fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
