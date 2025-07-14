import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../community/widgets/lists/community_list.dart';
import '../../../group/models/group_model.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/widgets/lists/group_list.dart';
import '../../../newsletter/models/newsletter.dart';
import '../dialogs/filter_chats_dialog.dart';
import '../dialogs/new_chat_dialog.dart';
import '../input/search_text_input.dart';
import '../lists/newsletter_list.dart';
import '../lists/support_list.dart';
import '../lists/user_list.dart';

class ChatsWidget extends StatefulWidget {
  final UserModel user;
  final List<GroupModel> groups;
  final List<NewsletterModel> newsletters;
  final List<CommunityModel> communities;
  final List<UserModel> users;
  final bool isSearching;
  final List<UserModel> searchList;
  final List<SupportAppModel> supports;
  final Function(GroupModel) onGroupSelected;
  final ValueChanged<NewsletterModel> onNewsletterSelected;
  final ValueChanged<CommunityModel> onCommunitySelected;
  final Function(UserModel) onUserSelected;
  final Function(SupportAppModel) onSupportSelected;
  final UserModel? selectedUser;
  final CommunityModel? selectedCommunity;

  const ChatsWidget({
    super.key,
    required this.user,
    required this.groups,
    required this.newsletters,
    required this.communities,
    required this.users,
    required this.isSearching,
    required this.searchList,
    required this.supports,
    required this.onGroupSelected,
    required this.onNewsletterSelected,
    required this.onCommunitySelected,
    required this.onUserSelected,
    required this.onSupportSelected,
    required this.selectedUser,
    this.selectedCommunity,
  });

  @override
  State<ChatsWidget> createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  final TextEditingController chatsController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _newChatIconKey = GlobalKey();
  final GlobalKey _newFilterChatsIconKey = GlobalKey();
  GroupModel? selectedGroup;
  NewsletterModel? selectedNewsletter;
  CommunityModel? selectedCommunity;
  UserModel? selectedUser;
  SupportAppModel? selectedSupport;
  bool _isNewChatDialogOpen = false;
  bool _isFilterDialogOpen = false;

  @override
  void initState() {
    super.initState();
    selectedCommunity = widget.selectedCommunity;
    selectedUser = widget.selectedUser;
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    chatsController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final currentUser = userController.currentUser;
    final filteredGroups = widget.groups.where((group) => group.creatorName == currentUser.id).toList();
    final filteredNewsletters = widget.newsletters.where((newsletter) => newsletter.creatorName == currentUser.id).toList();
    final filteredCommunities = widget.communities.where((community) => community.creatorName == currentUser.id).toList();
    final filteredUsers = widget.users.where((user) => user.id == currentUser.id).toList();
    final filteredSupports = widget.supports.where((support) => support.id == currentUser.id).toList();
    final hoverBackgroundColor = context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt());

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                child: Text(S.of(context).chats, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 12, top: 16, bottom: 8),
                child: Row(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        tooltipTheme: TooltipThemeData(
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          textStyle: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
                        ),
                      ),
                      child: CustomTooltip(
                        message: 'Новый чат (Ctrl+N) \nНовая группа (Ctrl+Shift+N)',
                        verticalOffset: -90,
                        horizontalOffset: -70,
                        child: Material(
                          color: ChatifyColors.transparent,
                          child: InkWell(
                            key: _newChatIconKey,
                            onTap: () async {
                              final RenderBox renderBox = _newChatIconKey.currentContext?.findRenderObject() as RenderBox;
                              final position = renderBox.localToGlobal(Offset.zero);

                              setState(() => _isNewChatDialogOpen = true);

                              await showNewChatDialog(context, position, widget.user);

                              setState(() => _isNewChatDialogOpen = false);
                            },
                            mouseCursor: SystemMouseCursors.basic,
                            splashFactory: NoSplash.splashFactory,
                            borderRadius: BorderRadius.circular(8.0),
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                            child: Container(
                              decoration: BoxDecoration(color: _isNewChatDialogOpen ? hoverBackgroundColor : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
                              child: Padding(padding: const EdgeInsets.all(12), child: Icon(FeatherIcons.edit, size: 15, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    CustomTooltip(
                      message: 'Фильтр чатов',
                      horizontalOffset: -35,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          key: _newFilterChatsIconKey,
                          onTap: () async {
                            final RenderBox renderBox = _newFilterChatsIconKey.currentContext?.findRenderObject() as RenderBox;
                            final position = renderBox.localToGlobal(Offset.zero);

                            setState(() => _isFilterDialogOpen = true);

                            await showFilterChatsDialog(context, position);

                            setState(() => _isFilterDialogOpen = false);
                          },
                          mouseCursor: SystemMouseCursors.basic,
                          splashFactory: NoSplash.splashFactory,
                          borderRadius: BorderRadius.circular(8.0),
                          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                          child: Container(
                            decoration: BoxDecoration(color: _isFilterDialogOpen ? hoverBackgroundColor : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(ChatifyVectors.filter, width: 16, height: 16, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SearchTextInput(
            hintText: S.of(context).searchNewChat,
            controller: chatsController,
            focusNode: _focusNode,
            wrapInScrollView: false,
            padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 8),
          ),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) => context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey)),
              child: Padding(
                padding: const EdgeInsets.only(right: 1),
                child: Scrollbar(
                  thickness: 4,
                  thumbVisibility: false,
                  controller: _scrollController,
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        Visibility(
                          visible: widget.groups.isNotEmpty,
                          replacement: const SizedBox.shrink(),
                          child: Obx(() {
                            final userController = Get.find<UserController>();
                            final currentUserName = userController.currentUser.name;
                            return GroupList(
                              groups: widget.groups,
                              currentUser: currentUserName,
                              onGroupSelected: (group) {
                                setState(() {
                                  selectedGroup = group;
                                  selectedNewsletter = null;
                                  selectedCommunity = null;
                                  selectedUser = null;
                                  selectedSupport = null;
                                });
                                widget.onGroupSelected(group);
                              },
                            );
                          }),
                        ),
                        Visibility(
                          visible: widget.newsletters.isNotEmpty,
                          replacement: const SizedBox.shrink(),
                          child: NewsletterList(
                            newsletters: widget.newsletters,
                            selectedNewsletter: selectedNewsletter,
                            onNewsletterSelected: (newsletter) {
                              setState(() {
                                selectedNewsletter = newsletter;
                                selectedGroup = null;
                                selectedCommunity = null;
                                selectedUser = null;
                                selectedSupport = null;
                              });
                              widget.onNewsletterSelected(newsletter);
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.communities.isNotEmpty,
                          replacement: const SizedBox.shrink(),
                          child: CommunityList(
                            communities: widget.communities,
                            isHomeScreen: true,
                            selectedCommunity: selectedCommunity,
                            onCommunitySelected: (community) {
                              setState(() {
                                selectedCommunity = community;
                                selectedGroup = null;
                                selectedNewsletter = null;
                                selectedUser = null;
                                selectedSupport = null;
                              });
                              widget.onCommunitySelected(community);
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.users.isEmpty,
                          replacement: const SizedBox.shrink(),
                          child: UserList(
                            isSearching: widget.isSearching,
                            searchList: widget.searchList,
                            list: widget.users,
                            isSharing: false,
                            selectedUser: widget.selectedUser,
                            onUserSelected: (user) {
                              setState(() {
                                selectedUser = user;
                                selectedGroup = null;
                                selectedNewsletter = null;
                                selectedCommunity = null;
                                selectedSupport = null;
                              });
                              widget.onUserSelected(user);
                            },
                            onSelectionModeChanged: (bool selecting) {},
                          ),
                        ),
                        Visibility(
                          visible: widget.supports.isNotEmpty,
                          child: SupportList(
                            supports: widget.supports,
                            selectedSupport: selectedSupport,
                            onSupportSelected: (support) {
                              setState(() {
                                selectedSupport = support;
                                selectedGroup = null;
                                selectedCommunity = null;
                                selectedNewsletter = null;
                                selectedUser = null;
                              });
                              widget.onSupportSelected(support);
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
