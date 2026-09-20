import 'package:chatify/features/personalization/widgets/dialogs/light_dialog.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../api/chat_api.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/avatar_color_util.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

void showReactionBottomSheetDialog(BuildContext context, {required MessageModel message}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (_) {
      return ReactionBottomSheetContent(message: message);
    },
  );
}

class ReactionBottomSheetContent extends StatefulWidget {
  final MessageModel message;

  const ReactionBottomSheetContent({
    super.key,
    required this.message,
  });

  @override State<ReactionBottomSheetContent> createState() => _ReactionBottomSheetContentState();
}

class _ReactionBottomSheetContentState extends State<ReactionBottomSheetContent> {
  late Map<String, List<String>> localReactions;
  Map<String, UserModel> users = {};
  bool isLoadingUsers = true;

  String get reactionsTitle {
    if (totalReactions == 0) {
      return '$totalReactions реакций';
    }

    if (totalReactions == 1) {
      return '1 реакция';
    }

    if (totalReactions >= 2 && totalReactions <= 4) {
      return '$totalReactions реакции';
    }

    return '$totalReactions реакций';
  }

  int get totalReactions {
    return localReactions.values.fold<int>( 0, (sum, users) => sum + users.length);
  }

  @override
  void initState() {
    super.initState();
    localReactions = {
      for (final entry in widget.message.reactions.entries) entry.key: List<String>.from(entry.value),
    };
    _loadReactionUsers();
  }

  Future<void> _toggleReaction(String reaction) async {
    final currentUserId = APIs.user.uid;
    final users = localReactions[reaction] ?? [];

    final hasReacted = users.contains(currentUserId);

    if (hasReacted) {
      setState(() {
        localReactions[reaction]?.remove(currentUserId);
      });

      await ChatApi.deleteReactions(widget.message, reaction);
    } else {
      setState(() {
        localReactions.putIfAbsent(reaction, () => []);
        localReactions[reaction]!.add(currentUserId);
      });

      await ChatApi.updateMessageReaction(widget.message, reaction);
    }
  }

  Future<void> _loadReactionUsers() async {
    final userIds = localReactions.values.expand((users) => users).toSet();

    if (userIds.isEmpty) {
      if (mounted) {
        setState(() {
          isLoadingUsers = false;
        });
      }
      return;
    }

    final result = <String, UserModel>{};

    for (final userId in userIds) {
      final user = await APIs.getUserById(userId);

      if (user != null) {
        result[userId] = user;
      }
    }

    if (!mounted) return;

    setState(() {
      users = result;
      isLoadingUsers = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 80),
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Padding(padding: const EdgeInsets.only(left: 20, right: 20), child: Text(reactionsTitle, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500))),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 33,
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.grey, borderRadius: BorderRadius.circular(30)),
                      child: Center(child: Icon(Icons.add_reaction_outlined, size: 21, color: ChatifyColors.buttonLightGrey)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        height: 33,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: localReactions.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final entry = localReactions.entries.elementAt(index);
                            final users = entry.value;
                            final isEmpty = users.isEmpty;

                            return Material(
                              color: ChatifyColors.transparent,
                              child: InkWell(
                                onTap: () => _toggleReaction(entry.key),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  width: 80,
                                  height: 33,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(color: isEmpty ? (context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.grey) : colorsController.getColor(colorsController.selectedColorScheme.value,).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(entry.key, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${users.length}',
                                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (localReactions.isNotEmpty)
            ...localReactions.entries.expand((entry) {
              final reaction = entry.key;
              final users = entry.value;

              return users.map((userId) {
                final isCurrentUser = userId == APIs.user.uid;
                final user = this.users[userId];
                final userName = isCurrentUser ? 'Вы' : user?.name.isNotEmpty == true ? user!.name : userId;
                final avatarColors = AvatarColorUtil.get(userId);

                return Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 12),
                  child: Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      onTap: isCurrentUser
                        ? () async {
                            setState(() {
                              localReactions[reaction]?.remove(APIs.user.uid);
                            });

                            await ChatApi.deleteReactions(widget.message, reaction);
                          }
                        : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: avatarColors.background, shape: BoxShape.circle),
                              child: Center(
                                child: SvgPicture.asset(ChatifyVectors.person, width: 18, height: 18, colorFilter: ColorFilter.mode(avatarColors.icon, BlendMode.srcIn)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.center,
                                children: [
                                  Text(userName, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                  if (isCurrentUser)
                                    Text('Нажмите, чтобы удалить', style: TextStyle(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(reaction, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            }),
        ],
      ),
    );
  }
}
