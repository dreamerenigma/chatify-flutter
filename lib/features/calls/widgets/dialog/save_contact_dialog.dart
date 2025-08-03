import 'package:chatify/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class SaveContactController extends GetxController {
  RxString selectedOptionText = ''.obs;

  void updateSelectedOptionText(BuildContext context, int option) {
    switch (option) {
      case 1:
        selectedOptionText.value = APIs.me.email;
        break;
      case 2:
        selectedOptionText.value = S.of(context).phone;
        break;
      default:
        selectedOptionText.value = S.of(context).save;
    }
  }

  static SaveContactController get instance => Get.find();

  final box = GetStorage();

  var selectedOption = 1.obs;

  @override
  void onInit() {
    super.onInit();
    selectedOption.value = box.read<int>('selectedOption') ?? 1;
  }

  void setOption(BuildContext context, int option) {
    selectedOption.value = option;
    box.write('selectedOption', option);
    updateSelectedOptionText(context, option);
  }

  int getOption() {
    return selectedOption.value;
  }

  Future<void> showSaveContactDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          title: Text('${S.of(context).save}:', style: TextStyle(fontSize: ChatifySizes.fontSizeMg)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => RadioListTile<int>(
                title: Text(APIs.me.email),
                value: 1,
                groupValue: selectedOption.value,
                activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                onChanged: (value) {
                  if (value != null) {
                    setOption(context, value);
                  }
                },
                contentPadding: const EdgeInsets.only(left: 12),
              )),
              Obx(() => RadioListTile<int>(
                title: Text(S.of(context).phone),
                value: 2,
                groupValue: selectedOption.value,
                activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                onChanged: (value) {
                  if (value != null) {
                    setOption(context, value);
                  }
                },
                contentPadding: const EdgeInsets.only(left: 12),
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(S.of(context).save, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
          ],
        );
      },
    );
  }
}
