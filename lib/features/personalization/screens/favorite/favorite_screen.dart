import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'add_favorite_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  bool _isEditing = false;

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(_isEditing ? S.of(context).editFavorites : S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        actions: [
          IconButton(icon: Icon(_isEditing ? Icons.check : JamIcons.pencil), onPressed: _toggleEdit),
          IconButton(icon: Icon(Icons.person_add_alt_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
            child: SvgPicture.asset(ChatifyVectors.favorite, width: 100, height: 100),
          ),
          const SizedBox(height: 30),
          Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeMg)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(S.of(context).easierFindPeopleGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeMd), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              Navigator.push(context, createPageRoute(const AddFavoriteScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: ChatifyColors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(S.of(context).addToFavorites, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
            child: Text(
              S.of(context).favoritesChangeFavoritesCalls,
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
