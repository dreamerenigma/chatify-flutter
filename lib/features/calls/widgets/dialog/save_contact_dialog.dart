import 'package:chatify/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/custom_radio_list_tile.dart';
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
        return Dialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text('Синхронизация:', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => RadioGroup<int>(
                    groupValue: selectedOption.value,
                    onChanged: (value) {
                      if (value != null) {
                        setOption(context, value);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomRadioListTile<int>(
                          value: 1,
                          radioScale: 1.15,
                          radioPosition: RadioPositionType.left,
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          title: Text(APIs.me.email),
                          iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        CustomRadioListTile<int>(
                          value: 2,
                          radioScale: 1.15,
                          radioPosition: RadioPositionType.left,
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          title: Text(S.of(context).phone),
                          iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(S.of(context).next, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
