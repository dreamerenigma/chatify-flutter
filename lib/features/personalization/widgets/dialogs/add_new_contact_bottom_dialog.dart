import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../calls/widgets/dialog/save_contact_dialog.dart';
import '../../screens/account/select_country_screen.dart';
import 'light_dialog.dart';

void showAddNewContactBottomSheetDialog(BuildContext context, double maxHeight) {
  final saveContactsController = Get.put(SaveContactController());
  final double maxHeight = MediaQuery.of(context).size.height * 0.62;

  Future<void> openContactAddScreen(BuildContext context) async {
    const intent = AndroidIntent(
      action: 'android.intent.action.INSERT',
      data: 'content://contacts/people',
      type: 'vnd.android.cursor.dir/contact',
      package: 'com.android.contacts',
      componentName: null,
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    try {
      await intent.launch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open contact add screen')),
      );
    }
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    isScrollControlled: true,
    builder: (_) {
      return Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close, color: ChatifyColors.darkGrey),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Expanded(
                                child: Center(child: Text('Новый контакт', style: TextStyle(fontSize: ChatifySizes.fontSizeBg))),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8, right: 16),
                                  child: const Icon(Icons.person_outline, color: ChatifyColors.darkGrey),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextSelectionTheme(
                                    data: TextSelectionThemeData(
                                      cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                      selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    ),
                                    child: TextField(
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        hintText: 'Имя',
                                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                                        isDense: true,
                                      ),
                                      textCapitalization: TextCapitalization.sentences,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60, top: 40),
                            child: TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              ),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: ChatifySizes.fontSizeMd,
                                ),
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  hintText: 'Фамилия',
                                  hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                                  isDense: true,
                                ),
                                textCapitalization: TextCapitalization.sentences,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8, right: 16),
                                  child: const Icon(Icons.call_outlined, color: ChatifyColors.darkGrey),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 100,
                                  child: TextSelectionTheme(
                                    data: TextSelectionThemeData(
                                      cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                      selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    ),
                                    child: TextField(
                                      onTap: () {
                                        Navigator.push(context, createPageRoute(const SelectCountryScreen()));
                                      },
                                      readOnly: true,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        labelText: 'Страна',
                                        labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                                        floatingLabelStyle: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: ChatifyColors.darkGrey),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        suffixIcon: const Icon(Icons.arrow_drop_down, color: ChatifyColors.darkGrey),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextSelectionTheme(
                                    data: TextSelectionThemeData(
                                      cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                      selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    ),
                                    child: TextField(
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                        hintText: 'Телефон',
                                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8, right: 16),
                                  child: const Icon(Icons.file_download_outlined, color: ChatifyColors.darkGrey),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Obx(() =>
                                    TextSelectionTheme(
                                      data: TextSelectionThemeData(
                                        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      ),
                                      child: TextField(
                                        onTap: () {
                                          saveContactsController.showSaveContactDialog(context);
                                        },
                                        readOnly: true,
                                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                          labelText: 'Сохранить:',
                                          hintText: saveContactsController.selectedOptionText.value,
                                          labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                                          floatingLabelStyle: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: ChatifyColors.darkGrey),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          suffixIcon: const Icon(Icons.arrow_drop_down, color: ChatifyColors.darkGrey),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 45),
                                  child: TextButton(
                                    onPressed: () => openContactAddScreen(context),
                                    child: Text('Добавить информацию', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  side: BorderSide.none,
                                ),
                                child: Text('Сохранить', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
