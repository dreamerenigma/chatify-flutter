import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../personalization/controllers/language_controller.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/buttons/login_menu_button.dart';
import '../widgets/contents/add_account_content.dart';
import 'enter_phone_number.dart';

class AddAccountScreen extends StatefulWidget {
  final bool isFromSplashScreen;
  final bool showBackButton;

  const AddAccountScreen({super.key, required this.isFromSplashScreen, this.showBackButton = true});

  @override
  State<AddAccountScreen> createState() => AddAccountScreenState();
}

class AddAccountScreenState extends State<AddAccountScreen> {
  final LanguagesController languageController = Get.put(LanguagesController());
  bool isHoveredPrivacy = false;
  bool isHoveredTermsOfUse = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    int schemeIndex = int.tryParse(colorsController.selectedColorScheme.value.toString()) ?? 0;

    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Stack(
        children: [
          if (widget.showBackButton)
          Positioned(
            top: 40,
            left: 0,
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false;
                });
              },
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                mouseCursor: SystemMouseCursors.basic,
                splashFactory: NoSplash.splashFactory,
                borderRadius: BorderRadius.circular(8),
                splashColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(6)),
                  clipBehavior: Clip.hardEdge,
                  child: Icon(Icons.arrow_back, color: isHovered ? context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white : ChatifyColors.white),
                ),
              ),
            ),
          ),
          LoginMenuButton(parentContext: context),
          AddAccountContent(isFromSplashScreen: widget.isFromSplashScreen, schemeIndex: schemeIndex, isWebOrWindows: isWebOrWindows, languageController: languageController),
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 25, right: 25, bottom: MediaQuery.of(context).padding.bottom + 8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: !kIsWeb && Platform.isWindows ? DeviceUtils.getScreenWidth(context) * 0.3 : double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(createPageRoute(const EnterPhoneNumberScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: ChatifyColors.black,
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).acceptAndContinue, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
