import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:chatify/features/personalization/screens/account/select_country_screen.dart';
import 'package:chatify/features/personalization/screens/qr_code/qr_code_screen.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/app_loaders.dart';
import '../../authentication/models/country.dart';
import '../../personalization/controllers/settings_controller.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../widgets/dialog/save_contact_dialog.dart';

class NewContactScreen extends StatefulWidget {
  final UserModel user;
  final int selectedOption;

  const NewContactScreen({super.key, required this.user, required this.selectedOption});

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  final SettingsController settingsController = Get.put(SettingsController());
  final GetStorage _storage = GetStorage();
  Country? _selectedCountry;

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
      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        S.of(context).failedToOpenContactAddScreen,
        icon: const Icon(Icons.warning_amber_rounded, size: 26),
        iconColor: ChatifyColors.yellow,
        position: SnackBarPositionType.bottom
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
      saveContactsController.updateSelectedOptionText(context, widget.selectedOption);
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 5,
            elevation: 0,
            title: Text(S.of(context).newContact, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_rounded, size: 24),
                onPressed: () {
                  Navigator.push(context, createPageRoute(QrCodeScreen(user: widget.user)));
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ListView(
              padding: const EdgeInsets.only(left: 12, right: 20, top: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 8, right: 16),
                        child: const Icon(Icons.person_outline, size: 25, color: ChatifyColors.darkGrey),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextSelectionTheme(
                          data: TextSelectionThemeData(
                            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                              labelText: S.of(context).name,
                              labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                              floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55, top: 30),
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                      selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                        labelText: S.of(context).surname,
                        labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 8, right: 16),
                        child: const Icon(Icons.alternate_email_rounded, size: 25, color: ChatifyColors.darkGrey),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextSelectionTheme(
                          data: TextSelectionThemeData(
                            cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                              labelText: S.of(context).username,
                              labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                              floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                        width: 130,
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
                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                              labelText: S.of(context).country,
                              hintText: '${_selectedCountry?.alphaCode ?? ''} ${_selectedCountry?.code ?? ''}',
                              hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
                              labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                              floatingLabelStyle: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: ChatifyColors.darkGrey),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              suffixIcon: const Icon(Icons.arrow_drop_down, color: ChatifyColors.darkGrey),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
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
                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                              labelText: S.of(context).phone,
                              labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                              floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 16, top: 3),
                      child: SvgPicture.asset(ChatifyVectors.arrowReload, width: 24, height: 24, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Text('Синхронизировать контакт на телефоне', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                              )),
                              SizedBox(width: 20),
                              Obx(() =>
                                CustomSwitch(
                                  value: settingsController.syncContacts.value,
                                  onChanged: settingsController.toggleSyncContacts,
                                  switchWidth: 58,
                                  switchHeight: 35,
                                  thumbSize: 27,
                                  thumbPadding: 3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Text('Можно синхронизировать только контакты с номером телефона', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(() =>
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: settingsController.syncContacts.value
                      ? Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8, right: 16),
                                  child: const Icon(Icons.file_download_outlined, size: 26, color: ChatifyColors.darkGrey),
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
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1)),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                                        labelText: '${S.of(context).save}:',
                                        hintText: saveContactsController.selectedOptionText.value,
                                        labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                                        floatingLabelStyle: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: ChatifyColors.darkGrey),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        suffixIcon: const Icon(Icons.arrow_drop_down, color: ChatifyColors.darkGrey),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                      ),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 50, top: 5),
                                  child: TextButton(
                                    onPressed: () => _openContactAddScreen(context),
                                    style: ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                      overlayColor: WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(WidgetState.pressed)) {
                                          return colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt());
                                        }
                                        return ChatifyColors.transparent;
                                      }),
                                      foregroundColor: WidgetStateProperty.all(colorsController.getColor(colorsController.selectedColorScheme.value)),
                                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(S.of(context).addInfo, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    side: BorderSide.none,
                  ),
                  child: Text(S.of(context).save, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
