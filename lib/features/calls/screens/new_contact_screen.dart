import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:chatify/features/personalization/screens/qr_code/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../authentication/models/country.dart';
import '../../personalization/controllers/settings_controller.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/contents/edit_new_contact_screen_content.dart';

class NewContactScreen extends StatefulWidget {
  final UserModel user;
  final int selectedOption;

  const NewContactScreen({
    super.key,
    required this.user,
    required this.selectedOption,
  });

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
        position: SnackBarPositionType.bottom,
        offset: 20,
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

  @override
  Widget build(BuildContext context) {
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
          EditNewContactScreenContent(selectedOption: widget.selectedOption),
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
