import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class PrivacyExtendedScreen extends StatefulWidget {
  const PrivacyExtendedScreen({super.key});

  @override
  State<PrivacyExtendedScreen> createState() => PrivacyExtendedScreenState();
}

class PrivacyExtendedScreenState extends State<PrivacyExtendedScreen> {
  bool isBlockUnknownAccounts = false;
  bool isProtectIPDuringCalls = false;
  bool isDisableLinkPreview = false;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    isBlockUnknownAccounts = storage.read<bool>('isBlockUnknownAccounts') ?? false;
    isProtectIPDuringCalls = storage.read<bool>('isProtectIPDuringCalls') ?? false;
    isDisableLinkPreview = storage.read<bool>('isDisableLinkPreview') ?? false;
  }

  void toggleBlockUnknownAccounts(bool value) async {
    setState(() {
      isBlockUnknownAccounts = value;
    });

    storage.write('isBlockUnknownAccounts', isBlockUnknownAccounts);
  }

  void toggleProtectIPDuringCalls(bool value) async {
    setState(() {
      isProtectIPDuringCalls = value;
    });

    storage.write('isProtectIPDuringCalls', isProtectIPDuringCalls);
  }

  void toggleDisableLinkPreview(bool value) async {
    setState(() {
      isDisableLinkPreview = value;
    });

    storage.write('isDisableLinkPreview', isDisableLinkPreview);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(S.of(context).extended, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
            child: Scrollbar(
              thickness: 4,
              thumbVisibility: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSwitchItem(
                          context: context,
                          title: S.of(context).blockMessagesUnknownAccounts,
                          description: S.of(context).protectYourAccountAppMessages,
                          switchValue: isBlockUnknownAccounts,
                          onChanged: (value) => toggleBlockUnknownAccounts(value),
                          onDetailsTap: () {},
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        const SizedBox(height: 35),
                        buildSwitchItem(
                          context: context,
                          title: S.of(context).protectYourIpAddressCalls,
                          description: S.of(context).difficultDetermineLocationSecurely,
                          switchValue: isProtectIPDuringCalls,
                          onChanged: (value) => toggleProtectIPDuringCalls(value),
                          onDetailsTap: () {},
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        const SizedBox(height: 35),
                        buildSwitchItem(
                          context: context,
                          title: S.of(context).disableLinkPreview,
                          description: S.of(context).preventIpAddressWebsites,
                          switchValue: isDisableLinkPreview,
                          onChanged: (value) => toggleDisableLinkPreview(value),
                          onDetailsTap: () {},
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitchItem({
    required BuildContext context,
    required String title,
    required String description,
    required bool switchValue,
    required ValueChanged<bool> onChanged,
    required VoidCallback onDetailsTap,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd))),
            Switch(
              value: switchValue,
              onChanged: onChanged,
              activeColor: color,
              activeTrackColor: color.withAlpha((0.5 * 255).toInt()),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            text: description,
            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
            children: [
              TextSpan(
                text: S.of(context).readMore,
                style: TextStyle(height: 1.5, color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()..onTap = onDetailsTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
