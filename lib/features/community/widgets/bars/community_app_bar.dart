import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/personalization/widgets/dialogs/light_dialog.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../api/apis.dart';
import '../../../../api/community_api.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/dialogs/chat_settings_dialog.dart';
import '../../models/community_model.dart';
import '../../screens/community_data_screen.dart';
import '../dialogs/add_group_community_bottom_dialog.dart';

class CommunityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final CommunityModel community;
  final UserModel user;
  final bool isEventsInfoVisible;
  final VoidCallback onCloseEventsInfo;

  const CommunityAppBar({
    super.key,
    required this.community,
    required this.user,
    required this.isEventsInfoVisible,
    required this.onCloseEventsInfo,
  });

  @override
  State<CommunityAppBar> createState() => CommunityAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}

class CommunityAppBarState extends State<CommunityAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;
  late Animation<double> _searchScaleAnimation;
  List<CommunityModel> communities = [];
  bool _isLoading = true;
  bool _isEventsInfoVisible = true;
  String? _communityImageUrl;
  double imageSize = 38;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(parent: _searchController, curve: Curves.easeInOut));
    _loadCommunities();
    _loadCommunityImage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCommunities() async {
    try {
      final data = await CommunityApi.getCommunity();
      setState(() {
        communities = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCommunityImage() async {
    try {
      if (widget.community.image.trim().isEmpty) return;

      final imageUrl = await APIs.mediaService.getUrl(widget.community.image);

      if (!mounted) return;

      setState(() {
        _communityImageUrl = imageUrl;
      });
    } catch (e) {
      log('COMMUNITY IMAGE ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppBar(backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey);
    }

    return _buildAppBar(context, widget.community);
  }

  Widget _buildAppBar(BuildContext context, CommunityModel community) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCommunityAppBar(context, community),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: _isEventsInfoVisible ? _buildCommunityEventsInfo(context) : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildCommunityAppBar(BuildContext context, CommunityModel community) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.buttonDisabled))),
      child: AppBar(
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: -5,
        elevation: 0,
        title: SizedBox(width: double.infinity, child: _buildCommunityInfo(context, community)),
        actions: [
          const SizedBox(width: 15),
          _buildCommunityIcon(context, _communityImageUrl, size: imageSize - 12, borderRadius: 4,  onDropdownTap: () {
            showAddGroupCommunityBottomSheetDialog(context, widget.community);
          }),
          const SizedBox(width: 5),
          PopupMenuButton<int>(
            tooltip: S.of(context).more,
            position: PopupMenuPosition.under,
            offset: const Offset(-8, 0),
            menuPadding: EdgeInsets.symmetric(vertical: 4),
            constraints: const BoxConstraints(minWidth: 0, maxWidth: 235),
            icon: const Icon(Icons.more_vert),
            color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                }
                return ChatifyColors.transparent;
              }),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Добавить участников',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Данные об объявлениях',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Медиа в объявлениях',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Поиск',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Без звука',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 5,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Исчезающие сообщения',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 6,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Тема чата',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 7,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: 'Ещё',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityIcon(
    BuildContext context,
    String? imageUrl, {
    double size = 33,
    bool showDropdownIcon = true,
    double borderRadius = 8,
    VoidCallback? onDropdownTap,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageUrl != null && imageUrl.trim().isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.white,
                      child: Container(width: size, height: size, color: ChatifyColors.darkGrey),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      width: size,
                      height: size,
                      color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                      alignment: Alignment.center,
                      child: Icon(Icons.groups, size: size * 0.55, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                    );
                  },
                )
              : Container(
                  width: size,
                  height: size,
                  color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                  alignment: Alignment.center,
                  child: Icon(Icons.groups, size: size * 0.55, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                ),
          ),
          if (showDropdownIcon)
            Positioned(
              right: -4,
              bottom: -2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showAddGroupCommunityBottomSheetDialog(context, widget.community);
                },
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.darkGrey, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommunityInfo(BuildContext context, CommunityModel community) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        mouseCursor: SystemMouseCursors.basic,
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(8),
        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          if (Platform.isWindows) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);

            showChatSettingsDialog(context, widget.community, position, initialIndex: 0);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CommunityDataScreen(community: widget.community, user: widget.user)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              _buildCommunityIcon(context, _communityImageUrl, size: imageSize, showDropdownIcon: false),
              SizedBox(width: Platform.isWindows ? 14 : 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      community.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeLg, fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400, height: 1.3),
                    ),
                    Text(
                      S.of(context).announcements,
                      style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeSm, color: ChatifyColors.grey, fontWeight: FontWeight.w400, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityEventsInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(ChatifyVectors.megaphoneOutline, width: 26, height: 26, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.iconGrey, BlendMode.srcIn)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, height: 1.25),
                children: [
                  const TextSpan(text: 'Создавайте мероприятия в группах объявлений. '),
                  TextSpan(
                    text: 'Подробнее',
                    style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                setState(() {
                  _isEventsInfoVisible = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4, top: 6, bottom: 6),
                child: Icon(Icons.close, size: 22, color: ChatifyColors.darkGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
