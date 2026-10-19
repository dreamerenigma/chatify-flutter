import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../chat/models/user_model.dart';
import '../../chat/widgets/dialogs/user_complain_dialog.dart';
import '../../group/models/group_model.dart';
import '../../personalization/screens/privacy/privacy_protection_screen.dart';
import '../../personalization/screens/profile/disappearing_messages_chat_screen.dart';
import '../../personalization/widgets/dialogs/add_list_bottom_sheet_dialog.dart';
import '../../personalization/widgets/dialogs/closing_chat_bottom_sheet_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../personalization/widgets/items/profile_settings_item.dart';
import '../../status/widgets/options/action_option.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../models/community_model.dart';

class CommunityGroupInfoScreen extends StatefulWidget {
  final CommunityModel community;
  final UserModel user;

  const CommunityGroupInfoScreen({
    super.key,
    required this.community,
    required this.user,
  });

  @override
  State<CommunityGroupInfoScreen> createState() => _CommunityGroupInfoScreenState();
}

class _CommunityGroupInfoScreenState extends State<CommunityGroupInfoScreen> {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ScrollController _scrollController = ScrollController();
  late List<GroupModel> groups;
  bool isFavorite = false;
  bool isCloseChatEnabled = false;
  bool _isLoadingProfileImage = false;
  int disappearingMessagesDuration = 3;
  String? _communityImageUrl;
  String? _profileImageUrl;
  List<UserModel> get disappearingMessagesUsers => [APIs.me, widget.user];

  String get _creatorDisplayName {
    if (widget.community.creatorId == widget.user.id) {
      return 'Вы';
    }

    return widget.community.creatorName;
  }

  String getGroupsLabel(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return '$count группа';
    }

    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return '$count группы';
    }

    return '$count групп';
  }

  String get disappearingMessagesSubtitle {
    switch (disappearingMessagesDuration) {
      case 0:
        return '24 часа';
      case 1:
        return '7 дней';
      case 2:
        return '90 дней';
      case 3:
      default:
        return S.of(context).off;
    }
  }

  @override
  void initState() {
    super.initState();
    groups = [];
    _scrollController.addListener(_onScroll);
    _loadProfileImage();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  void _onScroll() {
    _scrollOffset.value = _scrollController.offset;
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

  Future<void> _toggleClosingChat() async {
    if (isCloseChatEnabled) {
      setState(() {
        isCloseChatEnabled = false;
      });
      return;
    }

    setState(() {
      isCloseChatEnabled = true;
    });

    final confirmed = await showClosingChatBottomSheetDialog(context, onConfirmed: () {});

    if (!mounted) return;

    if (confirmed != true) {
      setState(() {
        isCloseChatEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white,
        statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: context.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Stack(
            children: [
              ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: ClipOval(
                            child: _communityImageUrl != null && _communityImageUrl!.trim().isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: _communityImageUrl!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: ChatifyColors.grey,
                                    highlightColor: ChatifyColors.steelGrey,
                                    child: _buildCommunityPlaceholder(),
                                  ),
                                  errorWidget: (context, url, error) => _buildCommunityPlaceholder(),
                                )
                              : _buildCommunityPlaceholder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Общая', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                            const SizedBox(height: 2),
                            Text('Группа · 1 участник', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                            const SizedBox(height: 2),
                            Text('Группа, в которой участники сообщества могут общаться на любые темы', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildButtonsGroup(context),
                      CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 20, bottom: 8),
                      _buildCommunityCard(),
                      CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 8, bottom: 10),
                      const SizedBox(height: 10),
                      _buildParticipantCommunity(),
                      const SizedBox(height: 10),
                      _buildCommunityContent(),
                      const SizedBox(height: 10),
                      _buildChat(),
                      _buildModerationUser(),
                      _buildAddInfo(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildAnimatedHeader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityPlaceholder() {
    return Container(
      width: 120,
      height: 120,
      color: ChatifyColors.grey,
      alignment: Alignment.center,
      child: SvgPicture.asset(ChatifyVectors.communityMessage, width: 75, height: 75),
    );
  }

  Widget _buildAnimatedHeader() {
    return ValueListenableBuilder<double>(
      valueListenable: _scrollOffset,
      builder: (context, scrollOffset, child) {
        final double progress = (scrollOffset / 150).clamp(0.0, 1.0);
        final double borderOpacity = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);

        return Positioned(
          top: 25,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
            height: 60,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 25), onPressed: () => Navigator.pop(context)),
                ),
                Positioned(
                  left: 55,
                  child: Opacity(
                    opacity: progress,
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 42,
                              height: 42,
                              color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                              alignment: Alignment.center,
                              child: _communityImageUrl != null && _communityImageUrl!.trim().isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: _communityImageUrl!,
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      return Icon(Icons.groups, size: 25, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey);
                                    },
                                  )
                                : Icon(Icons.groups, size: 25, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text('Общая', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.qr_code, size: 25),
                        tooltip: 'Поиск',
                      ),
                      TooltipTheme(
                        data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
                        child: Theme(
                          data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                          child: PopupMenuButton<int>(
                            tooltip: S.of(context).more,
                            position: PopupMenuPosition.under,
                            offset: const Offset(-8, 0),
                            menuPadding: const EdgeInsets.symmetric(vertical: 4),
                            constraints: const BoxConstraints(minWidth: 0, maxWidth: 280),
                            icon: const Icon(Icons.more_vert_rounded, size: 25),
                            color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            style: ButtonStyle(
                              backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                                }

                                return ChatifyColors.transparent;
                              }),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: S.of(context).addParticipants,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Изменить название',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Редактировать описание',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 4,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Разрешения группы',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuDivider(height: 8, indent: 0, endIndent: 0, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.buttonDisabled),
                              PopupMenuItem(
                                value: 5,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Создать похожую группу',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 6,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Экспорт чата',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Opacity(opacity: borderOpacity, child: Container(height: 1, color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.buttonDisabled)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonsGroup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionOption(
            label: S.of(context).call,
            icon: Icons.call_outlined,
            onTap: () {},
            width: 65,
            height: 50,
            labelWidth: 75,
          ),
          const SizedBox(width: 16),
          ActionOption(
            label: S.of(context).video,
            svgAsset: ChatifyVectors.videoCameraOutline,
            onTap: () {},
            width: 65,
            height: 50,
            labelWidth: 75,
          ),
          const SizedBox(width: 16),
          ActionOption(
            label: S.of(context).share,
            icon: Icons.share_outlined,
            onTap: () {},
            width: 65,
            height: 50,
            labelWidth: 75,
          ),
          const SizedBox(width: 16),
          ActionOption(
            label: S.of(context).search,
            icon: Icons.search_rounded,
            onTap: () {},
            width: 65,
            height: 50,
            labelWidth: 75,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard() {
    return Material(
      color: ChatifyColors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ChatifyColors.youngNight,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.buttonGrey),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(ChatifyVectors.communities, width: 32, height: 32, colorFilter: ColorFilter.mode(ChatifyColors.lightSoftNight, BlendMode.srcIn)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.community.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Сообщество · ${groups.length} группы',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_right_rounded, size: 20, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantCommunity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('1 участник', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
        ),
        const SizedBox(height: 10),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    child: Center(child: Icon(Icons.person_add_alt_rounded, size: 23, color: ChatifyColors.black)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      S.of(context).addParticipants,
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .05),
                    child: CachedNetworkImage(
                      width: DeviceUtils.getScreenHeight(context) * .05,
                      height: DeviceUtils.getScreenHeight(context) * .05,
                      imageUrl: _profileImageUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey),
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .05, height: DeviceUtils.getScreenHeight(context) * .05),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _creatorDisplayName,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.community : ChatifyColors.grey, borderRadius: BorderRadius.circular(3)),
                              child: Text('Админ группы', style: TextStyle(color: colorsController.getSelectedColor(colorsController.selectedColorScheme.value), fontSize: 11, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                        Text(
                          'Добавить метку участника',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 26),
                child: Text(
                  'См. изменения участников',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Text(
            'Настройки',
            textAlign: TextAlign.left,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
          ),
        ),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.settingsCircleOutline, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'Разрешения группы',
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 10),
        ProfileSettingsItem(
          icon: const Icon(Icons.notifications_none_rounded, size: 25, color: ChatifyColors.darkGrey),
          title: 'Уведомления',
          subtitle: 'Все',
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 5),
        ProfileSettingsItem(
          icon: const Icon(Icons.image_outlined, size: 25, color: ChatifyColors.darkGrey),
          title: 'Видимость медиа',
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          onTap: () {},
        ),
        CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 0),
      ],
    );
  }

  Widget _buildChat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: const Icon(Icons.lock_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: S.of(context).encryption,
          subtitle: S.of(context).callsProtectedEndToEndEncryption,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.timerOutline, width: 21, height: 21, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: S.of(context).disappearingMessages,
          subtitle: disappearingMessagesSubtitle,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          onTap: () async {
            final result = await Navigator.push<int>(
              context,
              createPageRoute(DisappearingMessagesChatScreen(users: disappearingMessagesUsers, selectedDuration: disappearingMessagesDuration)),
            );

            if (result != null) {
              setState(() {
                disappearingMessagesDuration = result;
              });
            }
          },
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.messageLock, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: S.of(context).closingChat,
          subtitle: S.of(context).closeHideChatDevice,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          trailing: CustomSwitch(
            value: isCloseChatEnabled,
            onChanged: (_) {
              _toggleClosingChat();
            },
            switchWidth: 55,
            switchHeight: 33,
            thumbSize: 25,
            thumbPadding: 3,
          ),
          onTap: _toggleClosingChat,
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.shieldCheckeredFilled, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'Расширенная защита конфиденциальности в чате',
          subtitle: 'Выкл.',
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          onTap: () {
            Navigator.push(context, createPageRoute(PrivacyProtectionScreen()));
          },
        ),
        CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 10),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    child: Center(child: Icon(Icons.person_add_alt_rounded, size: 23, color: ChatifyColors.black)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Создать похожую группу',
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Начните с участников, которых можно добавлять или удалять.',
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 10),
        ProfileSettingsItem(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          icon: isFavorite
            ? SvgPicture.asset(ChatifyVectors.favoriteNone, width: 24, height: 24, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn))
            : Icon(Icons.favorite_outline, size: 25, color: ChatifyColors.darkGrey),
          title: isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
          onTap: () async {
            if (isFavorite) {
              await APIs.removeUserFromFavorites(widget.user);
            } else {
              await APIs.addUserToFavorites(widget.user);
            }

            if (!mounted) return;

            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          icon: SvgPicture.asset(ChatifyVectors.addToList, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'Добавить в список',
          onTap: () {
            showAddListBottomSheetDialog(context);
          },
        ),
        ProfileSettingsItem(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          icon: Icon(Icons.file_upload_outlined, size: 25),
          iconColor: ChatifyColors.darkGrey,
          title: 'Экспорт чата',
          onTap: () {
            showAddListBottomSheetDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildModerationUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: const Icon(Icons.remove_circle_outline_outlined, size: 25),
          title: 'Очистить чат',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () {},
        ),
        const SizedBox(height: 8),
        ProfileSettingsItem(
          icon: Icon(CupertinoIcons.clear_circled, size: 25),
          title: 'Деактивировать группу',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () {},
        ),
        CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 10),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.exit, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.danger, BlendMode.srcIn)),
          title: 'Выйти из группы',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () {},
        ),
        ProfileSettingsItem(
          icon: const Icon(Icons.thumb_down_alt_outlined, size: 25),
          title: '${S.of(context).complainAbout} группу',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () {
            showUserComplainDialog(context, widget.user);
          },
        ),
      ],
    );
  }

  Widget _buildAddInfo() {
    final createdAt = widget.community.createdAt;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DeviceUtils.getScreenHeight(context) * 0.015),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).groupCreatedByYou,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: '${DateFormat('dd.MM.yyyy').format(createdAt)}, ''${DateFormat('HH:mm').format(createdAt)}',
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
