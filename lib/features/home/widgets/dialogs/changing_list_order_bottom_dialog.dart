import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../controllers/chat_lists_controller.dart';
import 'delete_tab_confirmation_dialog.dart';

void showChangingListBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    barrierColor: ChatifyColors.transparent,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.96),
    builder: (context) {
      return ChangingListsContent();
    },
  );
}

class ChangingListsContent extends StatefulWidget {
  const ChangingListsContent({super.key});

  @override
  State<ChangingListsContent> createState() => _ChangingListsContentState();
}

class _ChangingListsContentState extends State<ChangingListsContent> {
  final ChatListsController listsController = ChatListsController.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 36, height: 4, decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.iconGrey, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: SizedBox(
              height: 44,
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close, size: 24),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text('Изменение порядка списков', textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400))),
                  ),
                  SizedBox(
                    width: 44,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.check, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(alignment: Alignment.centerLeft, child: Text('Ваши списки', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400))),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 6),
            child: Obx(() => ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: listsController.lists.length,
                proxyDecorator: (child, index, animation) {
                  return Material(color: ChatifyColors.transparent, elevation: 0, child: child);
                },
                onReorderItem: (oldIndex, newIndex) {
                  listsController.reorder(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final item = listsController.lists[index];

                  return SizedBox(
                    key: ValueKey(item.title),
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _buildListItem(
                        context,
                        title: item.title,
                        subtitle: item.subtitle,
                        onDelete: item.canDelete ? () => showDeleteTabConfirmationDialog(context, index, item.title, listsController) : null,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildAvailablePresets(context),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, {required int index, required String title, String? subtitle, VoidCallback? onDelete}) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.darkGrey, fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 2),
              if (subtitle != null)
                Text(subtitle, style: TextStyle(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
          Spacer(),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: Icon(FluentIcons.delete_16_regular, size: 23),
            ),
          ReorderableDragStartListener(
            index: index,
            child: SizedBox(
              width: 48,
              height: 56,
              child: Center(child: Icon(AkarIcons.two_line_horizontal, size: 23, color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.darkGrey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePresets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.centerLeft, child: Text('Доступные предустановки', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'Если вы удалите один из предустановленных списков, ''например «Непрочитанное» или «Группы», ' 'они будут доступны здесь.',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
