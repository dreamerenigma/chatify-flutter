import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/enums/chat_list_type.dart';
import '../models/list_item_data.dart';

class ChatListsController extends GetxController {
  static ChatListsController get instance => Get.find();
  final GetStorage _storage = GetStorage();
  static const String _listsOrderKey = 'chat_lists_order';

  final RxList<ListItemData> lists = <ListItemData>[
    ListItemData(title: 'Непрочитанное', subtitle: 'Предустановка', canDelete: true, type: ChatListType.unread),
    ListItemData(title: 'Избранное', canDelete: false, type: ChatListType.favorite),
    ListItemData(title: 'Группы', subtitle: 'Предустановка', canDelete: true, type: ChatListType.groups),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadOrder();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    final item = lists.removeAt(oldIndex);
    lists.insert(newIndex, item);

    _saveOrder();
  }

  void _saveOrder() {
    _storage.write(
      _listsOrderKey,
      lists.map((item) => item.type.name).toList(),
    );
  }

  void _loadOrder() {
    final savedOrder = _storage.read<List>(_listsOrderKey);

    if (savedOrder == null) {
      return;
    }

    final itemsByType = {
      for (final item in lists) item.type.name: item,
    };

    final restored = <ListItemData>[];

    for (final typeName in savedOrder) {
      final item = itemsByType[typeName];

      if (item != null) {
        restored.add(item);
      }
    }

    for (final item in lists) {
      if (!restored.contains(item)) {
        restored.add(item);
      }
    }

    lists.assignAll(restored);
  }

  void deleteList(int index) {
    if (index < 0 || index >= lists.length) {
      return;
    }

    lists.removeAt(index);
    _saveOrder();
  }
}
