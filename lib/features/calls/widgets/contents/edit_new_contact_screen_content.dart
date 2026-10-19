import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../api/apis.dart';
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
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _usernameExists = false;
  bool _isCheckingUsername = false;
  String _lastCheckedUsername = '';
  Country? _selectedCountry;

  String _removeCountryCode(String? phoneNumber, String? countryCode) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return '';
    }

    final phone = phoneNumber.trim();
    final normalizedPhone = phone.replaceAll(RegExp(r'\D'), '');
    final normalizedCode = (countryCode ?? '').replaceAll(RegExp(r'\D'), '');

    if (normalizedCode.isEmpty || !normalizedPhone.startsWith(normalizedCode)) {
      return phone;
    }

    var digitsToRemove = normalizedCode.length;
    var index = 0;

    while (index < phone.length && digitsToRemove > 0) {
      if (RegExp(r'\d').hasMatch(phone[index])) {
        digitsToRemove--;
      }
      index++;
    }

    return phone.substring(index).trim();
  }

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _fillUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkUsername(_usernameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _fillUserData() {
    final user = widget.user;
    if (user == null) return;

    _nameController.text = user.name;
    _surnameController.text = user.surname;
    _usernameController.text = user.username;
    _fillPhoneFields(user.phoneNumber);
  }

  void _saveSelectedCountry(Country country) {
    _storage.write('selectedCountry', country.toJson());
  }

  void _fillPhoneFields(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      _countryController.clear();
      _phoneController.clear();
      return;
    }

    final phone = phoneNumber.trim();

    final countryCode = _selectedCountry?.code.trim() ?? '';
    final normalizedPhone = phone.replaceAll(RegExp(r'\D'), '');
    final normalizedCode = countryCode.replaceAll(RegExp(r'\D'), '');

    if (normalizedCode.isNotEmpty && normalizedPhone.startsWith(normalizedCode)) {
      _countryController.text = '${_selectedCountry?.alphaCode ?? ''} $countryCode'.trim();
      _phoneController.text = _removeCountryCode(phone, countryCode);
      return;
    }

    if (normalizedPhone.startsWith('7') && normalizedPhone.length == 11) {
      _countryController.text = 'RU +7';
      _phoneController.text = _removeCountryCode(phone, '+7');
      return;
    }

    _phoneController.text = phone;
  }

  Future<void> _checkUsername(String value) async {
    final username = value.trim().toLowerCase();

    if (!mounted) return;

    _lastCheckedUsername = username;

    if (username.isEmpty) {
      setState(() {
        _usernameExists = false;
        _isCheckingUsername = false;
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _usernameExists = false;
    });

    try {
      final exists = await APIs.usernameExists(username);

      if (!mounted || _lastCheckedUsername != username) return;

      setState(() {
        _usernameExists = exists;
        _isCheckingUsername = false;
      });
    } catch (e) {
      debugPrint('Ошибка проверки username: $e');

      if (!mounted || _lastCheckedUsername != username) return;

      setState(() {
        _usernameExists = false;
        _isCheckingUsername = false;
      });
    }
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                          selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        child: TextField(
                          controller: _usernameController,
                          onChanged: _checkUsername,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkGrey, width: 1)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                            labelText: S.of(context).username,
                            labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                            suffixIconConstraints: const BoxConstraints(minWidth: 23, minHeight: 23),
                            suffixIcon: _isCheckingUsername
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 2),
                                  ),
                                )
                              : _usernameController.text.trim().isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: SvgPicture.asset(ChatifyVectors.check, width: 20, height: 20, colorFilter: const ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: _usernameExists
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12, right: 20, top: 6),
                              child: Text('Это имя пользователя уже есть в Chatify.', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                            )
                          : const SizedBox.shrink(),
                      ),
                    ],
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
                      controller: _countryController,
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
                            _countryController.text = '${selectedCountry.alphaCode} ${selectedCountry.code}';
                            _phoneController.text = _removeCountryCode(widget.user?.phoneNumber, selectedCountry.code,
                            );
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
