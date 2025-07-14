import 'package:chatify/features/personalization/screens/lists/unread_list_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/edit_lists_bottom_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/new_list_bottom_dialog.dart';
import 'favorite_list_screen.dart';
import 'groups_list_screen.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => ListsScreenState();
}

class ListsScreenState extends State<ListsScreen> {
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
            title: Text(
              S.of(context).lists,
              style: TextStyle(
                fontSize: ChatifySizes.fontSizeMg,
                fontWeight: FontWeight.w400,
              ),
            ),
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
                icon: const Icon(Icons.mode_edit_outline_outlined),
                onPressed: () {
                  showEditListsBottomSheet(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(ChatifyVectors.createLists, height: 100),
                      const SizedBox(height: 8),
                      Text(
                        'Любой созданный вами список становится фильтром в верхней части вкладки "Чаты".',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.buttonSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showNewListBottomSheet(context);
                  },
                  icon: const Icon(Icons.add, color: ChatifyColors.black),
                  label: const Text('Создание собственного списка', style: TextStyle(color: ChatifyColors.black)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Divider(height: 6, thickness: 6, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text('Ваши списки', style: TextStyle(color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal)),
                  ),
                  const SizedBox(height: 8),

                  _buildListItem('Непрочитанное', 'Предустановка', () {
                    Navigator.push(context, createPageRoute(const UnreadListScreen()));
                  }),
                  _buildListItem('Избранное', 'Добавить людей или группы', () {
                    Navigator.push(context, createPageRoute(const FavoriteListScreen()));
                  }),
                  _buildListItem('Группы', 'Предустановка', () {
                    Navigator.push(context, createPageRoute(const GroupsListScreen()));
                  }),
                  const SizedBox(height: 6),
                  Divider(color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text('Доступные предустановки', style: TextStyle(color: ChatifyColors.buttonSecondary, fontWeight: FontWeight.normal)),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Если вы удалите один из предустановленных списков, например "Непрочитанное" или "Группы", он будет доступен здесь.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ChatifyColors.buttonSecondary, fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: ChatifyColors.buttonSecondary,
                  fontSize: ChatifySizes.fontSizeSm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
