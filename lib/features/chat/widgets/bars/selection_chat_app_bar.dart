import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/selection_action_mode_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../screens/message_details_screen.dart';
import '../../screens/user_encrypt_check_screen.dart';
import '../dialogs/pin_message_dialog.dart';
import '../dialogs/user_complain_dialog.dart';

class SelectionChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List list;
  final UserModel user;
  final VoidCallback _clearSelection;
  final VoidCallback _handleDeleteSelectedMessages;
  final ValueChanged<MessageModel> _handleUpdateMessage;
  final Set<int> selectedMessages;
  final SelectionActionModeType selectionActionMode;
  final VoidCallback handleDeleteDeletedMessages;
  final VoidCallback onReply;
  final VoidCallback onCopyMessage;

  const SelectionChatAppBar({
    super.key,
    required this.selectedMessages,
    required this.list,
    required this.user,
    required this._clearSelection,
    required this._handleDeleteSelectedMessages,
    required this._handleUpdateMessage,
    required this.selectionActionMode,
    required this.handleDeleteDeletedMessages,
    required this.onReply,
    required this.onCopyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMyMessage = selectedMessages.isNotEmpty && list[selectedMessages.first].fromId == APIs.user.uid;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => _clearSelection()),
      title: Row(
        children: [
          const SizedBox(width: 16),
          Text('${selectedMessages.length}'),
          const Spacer(),
          const SizedBox(width: 21),
          if (selectionActionMode == SelectionActionModeType.normal) ...[
            IconButton(
              icon: Transform(alignment: Alignment.center, transform: Matrix4.diagonal3Values(1, -1, 1), child: const Icon(BootstrapIcons.arrow_return_left)),
              onPressed: onReply,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.star_border_rounded),
            ),
            IconButton(
              onPressed: () => _handleDeleteSelectedMessages(),
              icon: const Icon(FluentIcons.delete_24_regular),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                ChatifyVectors.arrowBendDoubleUpRight,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
              ),
            ),
          ],
          if (selectionActionMode == SelectionActionModeType.deleted) ...[
            IconButton(
              onPressed: () => handleDeleteDeletedMessages(),
              icon: const Icon(FluentIcons.delete_24_regular),
            ),
          ],
          if (selectionActionMode == SelectionActionModeType.mixed) ...[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
          if (selectionActionMode != SelectionActionModeType.mixed)
            TooltipTheme(
              data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
              child: Theme(
                data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                child: PopupMenuButton<int>(
                  tooltip: S.of(context).more,
                  position: PopupMenuPosition.under,
                  offset: const Offset(-8, 0),
                  menuPadding: EdgeInsets.symmetric(vertical: 4),
                  constraints: const BoxConstraints(minWidth: 0, maxWidth: 250),
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white,
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
                    PopupMenuItem(
                      value: 1,
                      enabled: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppPopupMenuItem(
                        text: 'Подтвержд. кода безоп.',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, createPageRoute(UserEncryptCheckScreen()));
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      enabled: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppPopupMenuItem(
                        text: S.of(context).data,
                        onTap: () {
                          Navigator.pop(context);

                          if (selectedMessages.isNotEmpty) {
                            final message = list[selectedMessages.first];

                            Navigator.push(
                              context,
                              createPageRoute(
                                MessageDetailsScreen(
                                  message: message,
                                  messages: list.cast<MessageModel>(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      enabled: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppPopupMenuItem(
                        text: S.of(context).copy,
                        onTap: () {
                          Navigator.pop(context);
                          onCopyMessage();
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      enabled: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppPopupMenuItem(
                        text: S.of(context).edit,
                        onTap: () {
                          Navigator.pop(context);
                          if (selectedMessages.isNotEmpty) {
                            final message = list[selectedMessages.first];

                            _handleUpdateMessage(message);
                          }
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 5,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppPopupMenuItem(
                        text: S.of(context).pinIt,
                        onTap: () {
                          Navigator.pop(context);
                          showPinMessageDialog(context);
                        },
                      ),
                    ),
                    if (!isMyMessage)
                      PopupMenuItem(
                        value: 6,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: S.of(context).complain,
                          onTap: () {
                            Navigator.pop(context);
                            showUserComplainDialog(context, user);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      elevation: 0,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
