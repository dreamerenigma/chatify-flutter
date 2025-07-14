import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:chatify/features/personalization/screens/account/select_country_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../authentication/models/country.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/dialog/save_contact_dialog.dart';

class NewContactScreen extends StatefulWidget {
  final UserModel user;
  final int selectedOption;

  const NewContactScreen({super.key, required this.user, required this.selectedOption});

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  Country? _selectedCountry;
  final GetStorage _storage = GetStorage();

  Future<void> _openContactAddScreen(BuildContext context) async {
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

  @override
  void initState() {
    super.initState();
    _loadSelectedCountry();
  }

  void _loadSelectedCountry() {
    final storedCountry = _storage.read<Map<String, dynamic>>('selectedCountry');
    if (storedCountry != null) {
      setState(() {
        _selectedCountry = Country.fromJson(storedCountry);
      });
    }
  }

  void _saveSelectedCountry(Country country) {
    _storage.write('selectedCountry', country.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final saveContactsController = Get.put(SaveContactController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveContactsController.updateSelectedOptionText(widget.selectedOption);
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Новый контакт', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500)),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ListView(
              padding: const EdgeInsets.only(left: 12, right: 20, top: 16),
              children: [
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
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              ),
                              labelText: 'Имя',
                              labelStyle: TextStyle(
                                color: ChatifyColors.darkGrey,
                                fontSize: ChatifySizes.fontSizeMd,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                fontSize: ChatifySizes.fontSizeMd,
                              ),
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
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        ),
                        labelText: 'Фамилия',
                        labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                        floatingLabelStyle: TextStyle(
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                          fontSize: ChatifySizes.fontSizeMd,
                        ),
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
                      IntrinsicWidth(
                        child: TextSelectionTheme(
                          data: TextSelectionThemeData(
                            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                          child: TextField(
                            onTap: () async {
                              final selectedCountry = await Navigator.push(context, createPageRoute(const SelectCountryScreen()));

                              if (selectedCountry != null && selectedCountry is Country) {
                                setState(() {
                                  _selectedCountry = selectedCountry;
                                });
                                _saveSelectedCountry(selectedCountry);
                              }
                            },
                            readOnly: true,
                            style: TextStyle(
                              fontSize: ChatifySizes.fontSizeMd,
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              ),
                              labelText: 'Страна',
                              hintText: '${_selectedCountry?.alphaCode ?? ''} ${_selectedCountry?.code ?? ''}',
                              hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
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
                              labelText: 'Телефон',
                              labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                              floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
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
                        child: Obx(() => TextSelectionTheme(
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
                        )),
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
                        padding: const EdgeInsets.only(left: 35, top: 20),
                        child: TextButton(
                          onPressed: () => _openContactAddScreen(context),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.transparent),
                            overlayColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                return colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt());
                              }
                              return ChatifyColors.transparent;
                            }),
                            foregroundColor: WidgetStateProperty.all(
                              colorsController.getColor(colorsController.selectedColorScheme.value),
                            ),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 6)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Добавить информацию',
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                        child: Text('Сохранить', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
