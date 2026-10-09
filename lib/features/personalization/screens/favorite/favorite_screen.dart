import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../calls/screens/add_favorite_screen.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../widgets/dialogs/light_dialog.dart';

class FavoriteScreen extends StatefulWidget {
  final UserModel user;

  const FavoriteScreen({
    super.key,
    required this.user,
  });

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  final List<UserModel> favoriteUsers = [];
  bool _isEditing = false;
  bool isDisableNotifications = false;
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadFavoriteUsers();
    _loadProfileImage();
  }

  Future<void> _loadFavoriteUsers() async {
    final users = await APIs.getFavoriteUsers();

    if (!mounted) return;

    setState(() {
      favoriteUsers..clear()..addAll(users);
    });
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
  }

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
        elevation: 0,
        title: Text(_isEditing ? S.of(context).editFavorites : S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        actions: [
          IconButton(
            icon: _isEditing
              ? const Icon(Icons.check_rounded, size: 25)
              : SvgPicture.asset(ChatifyVectors.pencilOutline, width: 20, height: 20, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
            ),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'Используйте карандаш, чтобы изменять порядок списков на вкладке "Чаты".',
              style: TextStyle(color: ChatifyColors.steelGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Включены',
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.softGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                Navigator.push(context, createPageRoute(AddFavoriteScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded, size: 25, color: ChatifyColors.black),
                    ),
                    const SizedBox(width: 16),
                    Text('Добавить людей или группы', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
          if (favoriteUsers.isNotEmpty) ...[
            const SizedBox(height: 5),
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favoriteUsers.length,
                itemBuilder: (context, index) {
                  final user = favoriteUsers[index];

                  return _buildFavoriteUserCard(user);
                },
              ),
            ),
          ],
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Уведомления',
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.softGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
              hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
              onTap: () {
                setState(() {
                  isDisableNotifications = !isDisableNotifications;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 12, top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Выключить уведомления',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: CustomSwitch(
                        value: isDisableNotifications,
                        onChanged: (bool value) {
                          setState(() {
                            isDisableNotifications = value;
                          });
                        },
                        switchWidth: 55,
                        switchHeight: 33,
                        thumbSize: 25,
                        thumbPadding: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
            child: Text(
              S.of(context).favoritesChangeFavoritesCalls,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
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
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              ClipOval(
                child: user.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: _profileImageUrl ?? '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40);
                      },
                    )
                  : SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text('${user.name} ${user.surname}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
            ],
          ),
        ),
      ),
    );
  }
}
