import 'dart:io' show Platform;
import 'package:chatify/features/authentication/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_links.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../../utils/popups/custom_tooltip.dart';
import '../../../utils/popups/dialogs.dart';
import '../../../utils/urls/url_utils.dart';
import '../../../version.dart';
import '../../personalization/controllers/language_controller.dart';
import '../../personalization/screens/help/support/screens/support_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/dialogs/select_language_dialog.dart';
import 'enter_phone_number.dart';
import 'enter_qr_code_screen.dart';

class AddAccountScreen extends StatefulWidget {
  final bool isFromSplashScreen;
  final bool showBackButton;

  const AddAccountScreen({super.key, required this.isFromSplashScreen, this.showBackButton = true});

  @override
  State<AddAccountScreen> createState() => AddAccountScreenState();
}

class AddAccountScreenState extends State<AddAccountScreen> {
  final LanguageController languageController = Get.put(LanguageController());
  final GlobalKey _newSignOutKey = GlobalKey();
  bool isHoveredPrivacy = false;
  bool isHoveredTermsOfUse = false;
  bool isHovered = false;

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

  Future<void> _showDialogsSequentially(BuildContext context) async {
    await Dialogs.showCustomDialog(context: context, message: S.of(context).settingsSearch, duration: const Duration(seconds: 1));
    await Dialogs.showCustomDialog(context: context, message: S.of(context).connected, duration: const Duration(seconds: 4));
  }

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
          Positioned(
            top: isWebOrWindows ? 0 : (isMobile ? 30 : 10),
            right: !kIsWeb && Platform.isWindows ? 5 : 0,
            child: CustomTooltip(
              message: S.of(context).login,
              horizontalOffset: -35,
              verticalOffset: 0,
              child: Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  key: _newSignOutKey,
                  onTap: () async {
                    final RenderBox renderBox = _newSignOutKey.currentContext?.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);

                    showMenu(
                      context: context,
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                      position: RelativeRect.fromLTRB(
                        position.dx,
                        isWebOrWindows ? position.dy : position.dy + renderBox.size.height,
                        position.dx + renderBox.size.width,
                        0,
                      ),
                      items: [
                        PopupMenuItem(
                          value: 1,
                          padding: EdgeInsets.zero,
                          child: InkWell(
                            mouseCursor: SystemMouseCursors.basic,
                            splashFactory: NoSplash.splashFactory,
                            splashColor: ChatifyColors.transparent,
                            highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
                            onTap: () => Navigator.pop(context, 1),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(minHeight: 48),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(S.of(context).help, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          padding: EdgeInsets.zero,
                          child: Material(
                            color: ChatifyColors.transparent,
                            child: InkWell(
                              mouseCursor: SystemMouseCursors.basic,
                              splashFactory: NoSplash.splashFactory,
                              splashColor: ChatifyColors.transparent,
                              highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                              hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
                              onTap: () => Navigator.pop(context, 2),
                              child: Container(
                                width: double.infinity,
                                constraints: BoxConstraints(minHeight: 48),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(S.of(context).login, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                              ),
                            ),
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ).then((value) async {
                      if (value == 1) {
                        await _showDialogsSequentially(context);
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const SupportScreen(title: 'Поддержка'),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ));
                      } else if (value == 2) {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ));
                      }
                    });
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  splashFactory: NoSplash.splashFactory,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.more_vert),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenSize = MediaQuery.of(context).size;

                      double factor = 0.9;

                      if (screenSize.height >= 600) {
                        factor = 0.4;
                      }

                      if (screenSize.height > 800) {
                        factor = 0.4;
                      } else if (screenSize.height <= 800 && screenSize.height > 600) {
                        factor = 0.4;
                      }

                      return SizedBox(
                        width: constraints.maxWidth,
                        height: screenSize.height * factor,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
                          child: Image.asset(getAsset(schemeIndex), fit: BoxFit.contain),
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
                            TextSpan(text: S.of(context).acceptContinue, style: TextStyle(height: 1.2)),
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
                            const TextSpan(text: '.', style: TextStyle(height: 1.2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (isWebOrWindows ) {
                      showLanguageDialog(context);
                    } else {
                      languageController.selectLanguage(context);
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
                          languageController.getSelectedLanguageSubtitle(context),
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
          ),
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 8),
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
                          Text(S.of(context).acceptAndContinue, style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
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
