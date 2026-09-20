import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
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
  bool isStrictAccountSettings = false;
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
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text(S.of(context).extended, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSwitchItem(
                        context: context,
                        title: S.of(context).blockMessagesUnknownAccounts,
                        description: S.of(context).protectYourAccountAppMessages,
                        switchValue: isBlockUnknownAccounts,
                        onChanged: (value) => toggleBlockUnknownAccounts(value),
                        onDetailsTap: () {},
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      _buildSwitchItem(
                        context: context,
                        title: S.of(context).protectYourIpAddressCalls,
                        description: S.of(context).difficultDetermineLocationSecurely,
                        switchValue: isProtectIPDuringCalls,
                        onChanged: (value) => toggleProtectIPDuringCalls(value),
                        onDetailsTap: () {},
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      _buildSwitchItem(
                        context: context,
                        title: S.of(context).disableLinkPreview,
                        description: S.of(context).preventIpAddressWebsites,
                        switchValue: isDisableLinkPreview,
                        onChanged: (value) => toggleDisableLinkPreview(value),
                        onDetailsTap: () {},
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      _buildSwitchItem(
                        context: context,
                        title: 'Строгие настройки аккаунта',
                        description: 'Если ваш аккаунт находится в группе повышенного риска целевых кибератак, некоторые настройки будут заблокированы для дополнительной защиты. Большинству людей такой уровень защиты не нужен. Это может повлиять на качество звонков и обмена сообщениями.',
                        switchValue: isStrictAccountSettings,
                        onChanged: (value) => toggleDisableLinkPreview(value),
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        showSwitch: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required BuildContext context,
    required String title,
    required String description,
    required bool switchValue,
    required ValueChanged<bool> onChanged,
    VoidCallback? onDetailsTap,
    required Color color,
    bool showSwitch = true,
  }) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.3))),
                  if (showSwitch) ...[
                    SizedBox(width: 12),
                    CustomSwitch(
                      value: switchValue,
                      onChanged: onChanged,
                      switchWidth: 58,
                      switchHeight: 35,
                      thumbSize: 27,
                      thumbPadding: 3,
                    ),
                  ],
                ],
              ),
              if (showSwitch)
                RichText(
                  text: TextSpan(
                    text: description,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                    children: [
                      TextSpan(
                        text: S.of(context).readMore,
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.bold, height: 1.5),
                        recognizer: TapGestureRecognizer()..onTap = onDetailsTap,
                      ),
                    ],
                  ),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(description, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, height: 1.5))),
                    const SizedBox(width: 12),
                    Text(
                      switchValue ? 'Вкл.' : 'Выкл.',
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
