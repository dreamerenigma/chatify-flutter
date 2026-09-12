import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../../version.dart';
import '../../../personalization/controllers/language_controller.dart';
import '../../../personalization/widgets/dialogs/language_bottom_sheet_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/enter_qr_code_screen.dart';
import '../dialogs/select_language_dialog.dart';

class AddAccountContent extends StatefulWidget {
  final bool isFromSplashScreen;
  final int schemeIndex;
  final bool isWebOrWindows;
  final LanguagesController languageController;

  const AddAccountContent({
  super.key,
  required this.isFromSplashScreen,
  required this.schemeIndex,
  required this.isWebOrWindows,
  required this.languageController,
  });

  @override
  State<AddAccountContent> createState() => _AddAccountContentState();
}

class _AddAccountContentState extends State<AddAccountContent> {
  bool isHoveredPrivacy = false;
  bool isHoveredTermsOfUse = false;

  String getAsset(int schemeIndex) {
    switch (schemeIndex) {
      case 0:
        return ChatifyImages.welcomeBlue;
      case 1:
        return ChatifyImages.welcomeRed;
      case 2:
        return ChatifyImages.welcomeGreen;
      case 3:
        return ChatifyImages.welcomeOrange;
      default:
        return ChatifyImages.welcomeBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = MediaQuery.of(context).size;
                final factor = screenSize.height < 600 ? 0.9 : 0.4;

                return SizedBox(
                  width: constraints.maxWidth,
                  height: screenSize.height * factor,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
                    child: Image.asset(getAsset(widget.schemeIndex), fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.isFromSplashScreen ? S.of(context).welcome : S.of(context).addingAccount,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400, height: 1.2),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: !kIsWeb && Platform.isWindows ? DeviceUtils.getScreenWidth(context) * 0.55 : double.infinity,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                    children: [
                      TextSpan(text: S.of(context).checkOutOur, style: TextStyle(height: 1.2)),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => isHoveredPrivacy = true),
                          onExit: (_) => setState(() => isHoveredPrivacy = false),
                          child: GestureDetector(
                            onTap: () async {
                              await UrlUtils.launchURL(AppLinks.privacyPolicy);
                            },
                            child: Text(
                              S.of(context).privacyPolicy,
                              style: TextStyle(
                                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                fontWeight: FontWeight.w400,
                                fontSize: ChatifySizes.fontSizeSm,
                                decoration: isHoveredPrivacy ? TextDecoration.underline : TextDecoration.none,
                                decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: S.of(context).acceptContinue, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.2)),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => isHoveredTermsOfUse = true),
                          onExit: (_) => setState(() => isHoveredTermsOfUse = false),
                          child: GestureDetector(
                            onTap: () async {
                              await UrlUtils.launchURL(AppLinks.termsOfUse);
                            },
                            child: Text(
                              S.of(context).termsOfService,
                              style: TextStyle(
                                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                fontWeight: FontWeight.w400,
                                fontSize: ChatifySizes.fontSizeSm,
                                decoration: isHoveredTermsOfUse ? TextDecoration.underline : TextDecoration.none,
                                decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: '.', style: TextStyle(fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400, height: 1.2)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (widget.isWebOrWindows ) {
                showLanguageDialog(context);
              } else {
                showLanguageBottomSheetDialog(context, widget.languageController);
              }
            },
            style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.white,
              backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              side: BorderSide.none,
              elevation: 2,
              shadowColor: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
            ).copyWith(
              mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, size: 22, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    widget.languageController.getSelectedLanguageSubtitle(context),
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeMd,
                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              ],
            ),
          ),
          if (!kIsWeb && Platform.isWindows) ...[
            const SizedBox(height: 5),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const EnterQrCodeScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ));
                },
                style: ElevatedButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  foregroundColor: ChatifyColors.black,
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                ).copyWith(
                  mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).acceptAndContinue, style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text('${S.of(context).version} $appVersion ${'build'} $appBuildNumber', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
          ],
        ],
      ),
    );
  }
}
