import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/community/screens/edit_community_screen.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:shimmer/shimmer.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../chat/models/user_model.dart';
import '../../group/models/group_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../personalization/widgets/items/profile_settings_item.dart';
import '../../status/widgets/options/action_option.dart';
import '../models/community_model.dart';

class CommunityDataScreen extends StatefulWidget {
  final CommunityModel community;
  final UserModel user;

  const CommunityDataScreen({
    super.key,
    required this.community,
    required this.user,
  });

  @override
  State<CommunityDataScreen> createState() => _CommunityDataScreenState();
}

class _CommunityDataScreenState extends State<CommunityDataScreen> {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  late List<GroupModel> groups;
  bool isLoadingProfileImage = false;
  bool isCloseChatEnabled = false;
  int _selectedTab = 0;
  String? _profileImageUrl;
  String? _communityImageUrl;

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

  @override
  void initState() {
    super.initState();
    groups = [];
    _scrollController.addListener(_onScroll);
    _loadProfileImage();
    _loadCommunityImage();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _scrollOffset.value = _scrollController.offset;
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image;

    if (imagePath.isEmpty) {
      return;
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      if (!mounted) return;

      setState(() {
        _profileImageUrl = imagePath;
      });

      return;
    }

    if (mounted) {
      setState(() {
        isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.mediaService.getUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        isLoadingProfileImage = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingProfileImage = false;
      });

      log('PROFILE IMAGE URL ERROR: $e');
    }
  }

  Future<void> _loadCommunityImage() async {
    try {
      if (widget.community.image.trim().isEmpty) return;

      log('COMMUNITY IMAGE PATH: "${widget.community.image}"');

      final imageUrl = await APIs.mediaService.getUrl(widget.community.image);

      log('COMMUNITY IMAGE URL: "$imageUrl"');

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
                        onTap: () {
                          Navigator.push(context, createPageRoute(EditCommunityScreen(community: widget.community)));
                        },
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _communityImageUrl != null && _communityImageUrl!.trim().isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: _communityImageUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: ChatifyColors.darkerGrey,
                                    highlightColor: ChatifyColors.steelGrey,
                                    child: Container(width: 100, height: 100, decoration: BoxDecoration(color: ChatifyColors.softNight, borderRadius: BorderRadius.circular(25))),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 100,
                                    height: 100,
                                    color: ChatifyColors.darkerGrey,
                                    child: const Center(child: Icon(Icons.groups, color: ChatifyColors.darkGrey, size: 60)),
                                  ),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(25)),
                                  child: const Center(child: Icon(Icons.groups, color: ChatifyColors.darkGrey, size: 60)),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(widget.community.name, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                            const SizedBox(height: 8),
                            Text('Сообщество · 2 группы', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildButtonsCommunity(context),
                      const SizedBox(height: 25),
                      _buildTabs(),
                      const SizedBox(height: 20),
                      _buildTabContent(),
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
                Padding(padding: const EdgeInsets.only(left: 4), child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                Positioned(
                  left: 55,
                  child: Opacity(
                    opacity: progress,
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(context, createPageRoute(EditCommunityScreen(community: widget.community)));
                          },
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
                                      return Icon(Icons.groups, size: 24, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey);
                                    },
                                  )
                                : Icon(Icons.groups, size: 24, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.community.name, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400)),
                            Text('Сообщество · ${getGroupsLabel(groups.length)}', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
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

  Widget _buildButtonsCommunity(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionOption(
            label: S.of(context).invite,
            icon: Icons.link,
            onTap: () {},
            width: 65,
            height: 50,
            labelWidth: 75,
          ),
          const SizedBox(width: 16),
          ActionOption(
            label: S.of(context).addParticipants,
            icon: Icons.person_add_alt_outlined,
            onTap: () {},
            width: 65,
            height: 50,
            labelWidth: 75,
          ),
          const SizedBox(width: 16),
          ActionOption(
            label: S.of(context).addGroups,
            icon: Icons.group_add_outlined,
            onTap: () {},
            width: 65,
            height: 50,
            labelWidth: 75,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {
              setState(() {
                _selectedTab = 0;
              });
            },
            child: Column(
              children: [
                SizedBox(height: 48, child: Center(child: Text('Сообщество', textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)))),
                Container(height: 2, width: double.infinity, color: _selectedTab == 0 ? ChatifyColors.green : ChatifyColors.transparent),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {
              setState(() {
                _selectedTab = 1;
              });
            },
            child: Column(
              children: [
                SizedBox(height: 48, child: Center(child: Text('Объявления', textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)))),
                Container(height: 2, width: double.infinity, color: _selectedTab == 1 ? ChatifyColors.green : ChatifyColors.transparent),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      return _buildCommunityContent();
    }

    return _buildAnnouncementsContent();
  }

  Widget _buildCommunityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
          child: Text(
            'Приветствуем! В этом сообществе участники могут общаться ''в тематических группах и получать важные объявления',
            textAlign: TextAlign.left,
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.softGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
          ),
        ),
        ProfileSettingsItem(
          icon: const Icon(Icons.edit_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: 'Изменить данные о сообществе',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 6),
        ProfileSettingsItem(
          icon: const Icon(Icons.group_add_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: 'Управлять группами',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 20),
        ProfileSettingsItem(
          icon: const Icon(Icons.settings_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: 'Настройки сообщества',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 20),
        ProfileSettingsItem(
          icon: const Icon(Icons.group_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: 'Просмотреть группы (2)',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 20),
        _buildParticipantCommunity(),
        _buildModerationUser(),
      ],
    );
  }

  Widget _buildParticipantCommunity() {
    const int groupsCount = 2;
    final String groupText = groupsCount == 1 ? S.of(context).generalGroup : S.of(context).generalGroups;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('$groupsCount $groupText', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      child: Center(child: Icon(Icons.person_add_alt_outlined, size: 23, color: ChatifyColors.black)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Добавить участников',
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _creatorDisplayName,
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.community : ChatifyColors.grey, borderRadius: BorderRadius.circular(3)),
                            child: Text(
                              'Владелец сообщества',
                              style: TextStyle(color: ChatifyColors.primaryGreen, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          ProfileSettingsItem(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            icon: const Icon(Icons.arrow_forward_rounded, size: 25, color: ChatifyColors.darkGrey),
            title: 'Назначить нового владельца',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: const Icon(Icons.notifications_none, color: ChatifyColors.darkGrey, size: 25),
          title: 'Уведомления',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 15),
        ProfileSettingsItem(
          icon: const Icon(Icons.image_outlined, color: ChatifyColors.darkGrey, size: 25),
          title: 'Видимость медиа',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 15),
        _buildChat(),
        _buildModerationUser(),
        _buildCommunityUpdatesNotice(context),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedTimeQuarterPass, color: ChatifyColors.darkGrey),
          title: S.of(context).disappearingMessages,
          subtitle: S.of(context).off,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: const Iconify(Mdi.message_text_lock_outline, color: ChatifyColors.darkGrey),
          title: S.of(context).closingChat,
          subtitle: S.of(context).closeHideChatDevice,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          trailing: CustomSwitch(
            value: isCloseChatEnabled,
            onChanged: (value) {
              setState(() {
                isCloseChatEnabled = value;
              });
            },
            switchWidth: 58,
            switchHeight: 35,
            thumbSize: 27,
            thumbPadding: 3,
          ),
          onTap: () {
            setState(() {
              isCloseChatEnabled = !isCloseChatEnabled;
            });
          },
        ),
        const SizedBox(height: 10),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.numpad, width: 26, height: 26, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'Конфиденциальность номера',
          subtitleWidget: RichText(
            text: TextSpan(
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, height: 1.4),
              children: [
                const TextSpan(text: 'Ваш номер телефона виден в этом чате. '),
                TextSpan(
                  text: 'Подробнее',
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildModerationUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: const Icon(Icons.thumb_down_alt_outlined, size: 25),
          title: 'Пожаловаться на объявления',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCommunityUpdatesNotice(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 32),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
            children: [
              const TextSpan(text: 'Если хотите получать обновления, необходимо покинуть сообщество. '),
              TextSpan(
                text: 'Подробнее',
                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
