import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../calls/screens/add_favorite_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../widgets/dialogs/light_dialog.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  final List<UserModel> favoriteUsers = [];
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
          IconButton(
            icon: _isEditing
              ? const Icon(Icons.check)
              : SvgPicture.asset(ChatifyVectors.pencilOutline, width: 20, height: 20, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
            ),
            onPressed: _toggleEdit,
          ),
          IconButton(
            icon: Icon(Icons.person_add_alt_outlined),
            onPressed: () {
              Navigator.push(context, createPageRoute(AddFavoriteScreen()));
            },
          ),
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
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {
              Navigator.push(context, createPageRoute(AddFavoriteScreen()));
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
                  const SizedBox(width: 20),
                  Text(S.of(context).addToFavorites, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
            child: Text(
              S.of(context).favoritesChangeFavoritesCalls,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeSm),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          if (favoriteUsers.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: favoriteUsers.length,
                itemBuilder: (context, index) {
                  final user = favoriteUsers[index];

                  return _buildFavoriteUserCard(user);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFavoriteUserCard(UserModel user) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              ClipOval(
                child: user.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: user.image,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return SvgPicture.asset(ChatifyVectors.profile, width: 52, height: 52);
                      },
                    )
                  : SvgPicture.asset(ChatifyVectors.profile, width: 52, height: 52,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text('${user.name} ${user.surname}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500))),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined, size: 22),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
