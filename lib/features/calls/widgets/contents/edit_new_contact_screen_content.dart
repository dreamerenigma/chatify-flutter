import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../authentication/models/country.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/controllers/settings_controller.dart';
import '../../../personalization/screens/account/select_country_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../dialog/save_contact_dialog.dart';

class EditNewContactScreenContent extends StatefulWidget {
  final Country? initialCountry;
  final ValueChanged<Country>? onCountryChanged;
  final VoidCallback? onAddContact;
  final int selectedOption;
  final UserModel? user;

  const EditNewContactScreenContent({
    super.key,
    this.initialCountry,
    this.onCountryChanged,
    this.onAddContact,
    required this.selectedOption,
    this.user,
  });

  @override
  State<EditNewContactScreenContent> createState() => _EditNewContactScreenContentState();
}

class _EditNewContactScreenContentState extends State<EditNewContactScreenContent> {
  final GetStorage _storage = GetStorage();
  final SettingsController settingsController = Get.put(SettingsController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _fillUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillUserData() {
    final user = widget.user;

    if (user == null) {
      return;
    }

    _nameController.text = user.name;
    _surnameController.text = user.surname;
    _usernameController.text = user.username;
    _phoneController.text = user.phoneNumber;
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

    return ScrollConfiguration(
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
                      controller: _nameController,
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
                controller: _surnameController,
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
                      controller: _usernameController,
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
                      onTap: () async {
                        final selectedCountry = await Navigator.push(context, createPageRoute(const SelectCountryScreen()));

                        if (selectedCountry != null && selectedCountry is Country) {
                          setState(() {
                            _selectedCountry = selectedCountry;
                          });
                          _saveSelectedCountry(selectedCountry);

                          widget.onCountryChanged?.call(selectedCountry);
                        }
                      },
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
                      controller: _phoneController,
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
                              switchWidth: 55,
                              switchHeight: 33,
                              thumbSize: 25,
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
                            onPressed: widget.onAddContact,
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
    );
  }
}
