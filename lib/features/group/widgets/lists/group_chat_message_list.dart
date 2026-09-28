import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../api/group_api.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../chat/models/message_model.dart';
import '../../../chat/widgets/cards/message_card.dart';
import '../../../community/screens/add_user_screen.dart';
import '../../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/buttons/custom_scale_button.dart';
import '../../../utils/widgets/cards/info_card.dart';
import '../../../utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import '../../models/group_model.dart';
import '../../screens/description_group_screen.dart';
import '../../screens/link_to_group_screen.dart';
import '../images/placholder_group_image.dart';

class GroupChatMessageList extends StatefulWidget {
  final GroupModel group;
  final List<MessageModel> messages;

  const GroupChatMessageList({
    super.key,
    required this.group,
    required this.messages,
  });

  @override
  State<GroupChatMessageList> createState() => _GroupChatMessageListState();
}

class _GroupChatMessageListState extends State<GroupChatMessageList> {
  late Future<Map<String, String>> userNamesFuture;

  String getParticipantsText(BuildContext context, int count) {
    final word = S.of(context).participants.toLowerCase().replaceFirst('участники', 'участник');

    if (count % 10 == 1 && count % 100 != 11) {
      return word;
    }

    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return '$wordа';
    }

    return '$wordов';
  }

  @override
  void initState() {
    super.initState();
    userNamesFuture = APIs.fetchUserNames(widget.group.members, shortenNames: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GroupApi.getGroupMessages(widget.group),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
          return const SizedBox();
        }

        final data = snapshot.data?.docs ?? [];
        final list = data.map((e) => MessageModel.fromJson(e.data(), id: e.id)).toList();
        list.sort((a, b) => a.sent.compareTo(b.sent));

        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                    ),
                    child: Text(
                      DateUtil.formatDateTime(widget.group.createdAt),
                      style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: InfoCard(
                  icon: Icons.lock_outline,
                  text: 'Сообщения и звонки защищены сквозным шифрованием. ''Прочитать, прослушать или переслать их могут только ''участники этого чата.',
                  onTap: () {
                    showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
                  },
                ),
              ),
              SliverToBoxAdapter(child: _buildCardGroup()),
              SliverToBoxAdapter(child: _buildMembersBadge()),
              SliverToBoxAdapter(
                child: InfoCard(
                  svgIcon: ChatifyVectors.timerOutline,
                  iconSize: 14,
                  iconColor: ChatifyColors.darkGrey,
                  text: 'Вы обновили таймер сообщений. Новые несохраненные ''сообщения исчезнут из этого чата через 90 дней ''после отправки.',
                  textColor: ChatifyColors.darkGrey,
                  moreText: 'Изменить таймер',
                  onTap: () {},
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final message = list[list.length - 1 - index];

                    return MessageCard(
                      message: message,
                      isSelected: false,
                      onLongPress: () {},
                      onTap: () {},
                      messages: widget.messages,
                      user: APIs.me,
                    );
                  },
                  childCount: list.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardGroup() {
    final hasGroupImage = widget.group.groupImage.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showEditImageBottomDialog(
                context,
                title: 'Картинка группы',
                onImageSelected: (String value) {},
                onEmojiSelected: (Color color, String emoji) {},
                onDeletePressed: () {},
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                PlaceholderGroupImage(image: widget.group.groupImage, size: MediaQuery.of(context).size.height * .08),
                if (!hasGroupImage)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: GestureDetector(
                      onTap: () {
                        showEditImageBottomDialog(
                          context,
                          title: 'Картинка группы',
                          onImageSelected: (String value) {},
                          onEmojiSelected: (Color color, String emoji) {},
                          onDeletePressed: () {},
                        );
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, width: 2),
                        ),
                        child: const Center(child: Icon(Icons.camera_alt_rounded, size: 16, color: ChatifyColors.black)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(S.of(context).youCreatedGroup, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, height: 1.5)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: S.of(context).aboutGroups, style: const TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
                  const TextSpan(text: '  •  ', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 10, fontWeight: FontWeight.w400)),
                  TextSpan(
                    text: '${widget.group.members.length} ${getParticipantsText(context, widget.group.members.length)}',
                    style: const TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(text: 'Участники могут добавлять людей или приглашать их с помощью ссылки. ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4)),
                    TextSpan(
                      text: S.of(context).edit,
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600, height: 1.4),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.push(context, createPageRoute(const DescriptionGroupScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomScaleButton(
            onPressed: () {
              Navigator.push(context, createPageRoute(const AddUserScreen()));
            },
            icon: Icon(Icons.person_add_alt_outlined, size: 20, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
            label: Text(
              S.of(context).addParticipants,
              style: TextStyle(
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                fontSize: ChatifySizes.fontSizeMd,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: OutlinedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.darkGrey),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 8),
          CustomScaleButton(
            onPressed: () {
              Navigator.push(context, createPageRoute(const LinkToGroupScreen()));
            },
            icon: Icon(
              Icons.link,
              size: 20,
              color: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
            label: Text(
              S.of(context).inviteViaLink,
              style: TextStyle(
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                fontSize: ChatifySizes.fontSizeMd,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: OutlinedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.darkGrey),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: FutureBuilder<Map<String, String>>(
        future: userNamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2));
          }

          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final userNames = snapshot.data!;
          final memberNames = widget.group.members
              .where((memberId) => memberId != widget.group.ownerId)
              .map((memberId) => userNames[memberId] ?? S.of(context).unknownUser)
              .where((name) => name.trim().isNotEmpty).toList();

          if (memberNames.isEmpty) {
            return const SizedBox.shrink();
          }

          return Material(
            color: ChatifyColors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt(),), blurRadius: 3, spreadRadius: 1)],
              ),
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                mouseCursor: SystemMouseCursors.basic,
                borderRadius: BorderRadius.circular(7),
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    memberNames.join(', '),
                    style: const TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
