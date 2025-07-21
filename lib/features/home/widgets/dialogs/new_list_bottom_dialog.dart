import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

void newListBottomSheetDialog(BuildContext context) {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  bool isButtonEnabled = false;

  controller.addListener(() {
    isButtonEnabled = controller.text.isNotEmpty;
  });

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.91,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(30),
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                    child: Icon(Icons.close),
                  ),
                  Text('Новый список', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 25),
              Text('Название списка', style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey)),
              SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      child: TextField(
                        focusNode: focusNode,
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Примеры: "Работа", "Друзья"',
                          hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.emoji_emotions_outlined, size: 26, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
                ],
              ),
              SizedBox(height: 20),
              Text('Любой созданный вами список становиться фильтром в верхней части вкладки "Чаты".', style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey)),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(vertical: 13),
                    minimumSize: Size(double.infinity, 0),
                    side: BorderSide.none,
                  ),
                  child: Text('Добавьте людей или группы', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: isButtonEnabled ? ChatifyColors.black : ChatifyColors.grey)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
