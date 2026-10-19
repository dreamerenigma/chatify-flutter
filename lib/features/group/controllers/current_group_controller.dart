import 'dart:developer';
import 'package:get/get.dart';
import '../models/group_model.dart';

class CurrentGroupController extends GetxController {
  final Rxn<GroupModel> _currentGroup = Rxn<GroupModel>();

  GroupModel? get currentGroup => _currentGroup.value;

  @override
  void onInit() {
    super.onInit();
    log('CurrentGroupController: onInit вызван');
  }

  void setGroup(GroupModel group) {
    log('setGroup() вызван');
    log('Название группы: ${group.groupName}');
    log('ID группы: ${group.id}');

    _currentGroup.value = group;
  }

  void clearGroup() {
    log('clearGroup() вызван');
    _currentGroup.value = null;
  }
}
