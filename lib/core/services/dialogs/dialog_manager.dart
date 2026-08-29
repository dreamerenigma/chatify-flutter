import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../features/home/controllers/dialog_controller.dart';
import '../../../features/home/widgets/checkboxes/custom_checkbox.dart';
import '../../../features/home/widgets/dialogs/confirmation_dialog.dart';
import '../../../features/personalization/widgets/dialogs/light_dialog.dart';

class DialogManager {
  final _storage = GetStorage();
  static const _lastMonthlyDialogKey = 'last_confirmation_dialog_shown';
  static const _shouldNotShowAgainKey = 'should_not_show_rating_dialog';
  final dialogController = Get.find<DialogController>();

  void _saveCheckboxState(bool selected) {
    dialogController.selectedOptions[0] = selected;
  }

  Future<void> showMonthlyRatingDialog(BuildContext context) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      final now = DateTime.now();

      final shouldNotShowAgain = _storage.read<bool>(_shouldNotShowAgainKey) ?? false;
      if (shouldNotShowAgain) return;

      final lastShownStr = _storage.read<String>(_lastMonthlyDialogKey);
      if (lastShownStr != null) {
        final lastShown = DateTime.tryParse(lastShownStr);
        if (lastShown != null && now.difference(lastShown).inDays < 30) return;
      }

      showConfirmationDialog(
        context: context,
        title: 'Оцените Chatify',
        description: 'Хотите оценить Chatify в Input Studios Store?',
        confirmText: 'Оценить',
        cancelText: 'Не сейчас',
        onConfirm: () {},
        confirmButtonColor: colorsController.getColor(colorsController.selectedColorScheme.value),
        additionalWidget: Row(
          children: [
            CustomCheckbox(
              selectedOptions: dialogController.selectedOptions,
              onChanged: (selected) {
                _saveCheckboxState(selected);
                _storage.write(_shouldNotShowAgainKey, selected);
              },
              index: 0,
            ),
            const SizedBox(width: 8),
            Text('Больше не показывать', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
          ],
        ),
      );

      _storage.write(_lastMonthlyDialogKey, now.toIso8601String());
    }
  }
}
