import 'dart:developer';
import 'package:chatify/features/newsletter/screens/photo_newsletter_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../chat/models/user_model.dart';
import '../../community/screens/add_user_screen.dart';
import '../../group/widgets/images/placholder_group_image.dart';
import '../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../personalization/widgets/dialogs/add_list_bottom_sheet_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../personalization/widgets/items/profile_settings_item.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../models/newsletter_model.dart';

class NewsletterSettingsScreen extends StatefulWidget {
  final NewsletterModel newsletter;
  final List<String> newsletters;

  const NewsletterSettingsScreen({
    super.key,
    required this.newsletter,
    required this.newsletters,
  });

  @override
  State<NewsletterSettingsScreen> createState() => _NewsletterSettingsScreenState();
}

class _NewsletterSettingsScreenState extends State<NewsletterSettingsScreen> {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ScrollController _scrollController = ScrollController();
  final Map<String, UserModel> _users = {};
  bool _isLoadingUsers = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset.value = _scrollController.offset;
      });
    });
    _loadMembers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    try {
      for (final id in widget.newsletter.members) {
        final user = await APIs.getUserById(id);

        if (user != null) {
          _users[id] = user;
        }
      }
    } catch (e) {
      log('Error loading newsletter members: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUsers = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .03 + 56),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                      child: Scrollbar(
                        thickness: 4,
                        thumbVisibility: false,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoDetails(context),
                              SizedBox(height: 40),
                              _buildChat(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildAnimatedHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return ValueListenableBuilder<double>(
      valueListenable: _scrollOffset,
      builder: (context, scrollOffset, child) {
        final double progress = ((scrollOffset - 80) / 70).clamp(0.0, 1.0);
        final double borderOpacity = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);

        return Positioned(
          top: 25,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 54,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: progress,
                    child: Container(
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
                      child: Row(
                        children: [
                          const SizedBox(width: 60),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, createPageRoute(PhotoNewsletterScreen(imageNewsletter: widget.newsletter.newsletterImage, id: widget.newsletter.id, newsletters: widget.newsletters)));
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(color: ChatifyColors.nightGrey, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(ChatifyVectors.newsletter, width: 25, height: 25, colorFilter: const ColorFilter.mode(ChatifyColors.darkerGrey, BlendMode.srcIn)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.newsletter.newsletterName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400),
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
                Positioned(
                  left: 4,
                  top: 7,
                  child: IconButton(icon: Icon(Icons.arrow_back_rounded, size: 25, color: ChatifyColors.white), onPressed: () => Navigator.pop(context)),
                ),
                Positioned(
                  right: 2,
                  top: 7,
                  child: PopupMenuButton<int>(
                    tooltip: S.of(context).more,
                    position: PopupMenuPosition.under,
                    offset: const Offset(-8, 0),
                    menuPadding: EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints(minWidth: 0, maxWidth: 290),
                    icon: const Icon(Icons.more_vert),
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
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Добавить участника...',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: 'Изменить название рассылки',
                          onTap: () {
                            Navigator.pop(context);
                          },
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

  Widget _buildInfoDetails(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(context, createPageRoute(PhotoNewsletterScreen(imageNewsletter: widget.newsletter.newsletterImage, id: widget.newsletter.id, newsletters: widget.newsletters)));
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: ChatifyColors.nightGrey, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: SvgPicture.asset(ChatifyVectors.newsletter, width: 70, height: 70, colorFilter: ColorFilter.mode(ChatifyColors.darkerGrey, BlendMode.srcIn)),
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'Список без названия',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5),
              Text(
                'Список рассылки · ${widget.newsletter.members.length} получателями',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              Text(
                'Время создания: ${DateFormat('dd.MM.yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.newsletter.createdAt)))}',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChat() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSettingsItem(
              icon: const Icon(Icons.lock_outlined, size: 25, color: ChatifyColors.darkGrey),
              title: S.of(context).encryption,
              subtitle: 'Сообщения и звонки защищены сквозным шифрованием. Подробнее',
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              onTap: () {
                showChatsCallsPrivacyBottomSheet(
                  context,
                  headerText: S.of(context).chatsCallsConfidential,
                  titleText: S.of(context).endToEndEncryptionMessagesCalls,
                );
              },
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.newsletter.members.length} ${S.of(context).recipient}',
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                      ),
                      IconButton(icon: const Icon(Icons.search, size: 23, color: ChatifyColors.darkGrey), onPressed: () {}),
                    ],
                  ),
                ),
                Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    onTap: () {
                      Navigator.push(context, createPageRoute(const AddUserScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(25)),
                            child: const Icon(Icons.person_add_alt_rounded, size: 26, color: ChatifyColors.black),
                          ),
                          const SizedBox(width: 16),
                          Text('Изменить', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
                ...widget.newsletter.members.map((id) {
                  final member = _users[id];

                  if (member == null) {
                    return const SizedBox.shrink();
                  }

                  return Material(
                    color: ChatifyColors.transparent,
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
                            PlaceholderGroupImage(image: member.image, size: 42, placeholderIcon: SvgPicture.asset(ChatifyVectors.profile, width: 42, height: 42)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          member.id == APIs.me.id ? 'Вы' : member.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (member.id == widget.newsletter.creatorName)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value,).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                                          child: Text(
                                            'Админ группы',
                                            style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeXs, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Text(
                                      member.about,
                                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                ProfileSettingsItem(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  icon: SvgPicture.asset(ChatifyVectors.addToList, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: 'Добавить в список',
                  onTap: () {
                    showAddListBottomSheetDialog(context);
                  },
                ),
                const SizedBox(height: 5),
                ProfileSettingsItem(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  icon: Icon(FluentIcons.delete_24_regular, size: 24, color: ChatifyColors.danger),
                  title: 'Удалить список рассылки',
                  titleColor: ChatifyColors.danger,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
