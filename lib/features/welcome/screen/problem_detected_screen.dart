import 'dart:io';
import 'package:chatify/features/personalization/screens/help/help_center_screen.dart';
import 'package:chatify/features/personalization/screens/help/support/screens/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../../utils/popups/custom_tooltip.dart';
import '../../../utils/popups/dialogs.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';

class ProblemDetectedScreen extends StatefulWidget {
  const ProblemDetectedScreen({super.key});

  @override
  State<ProblemDetectedScreen> createState() => _ProblemDetectedScreenState();
}

class _ProblemDetectedScreenState extends State<ProblemDetectedScreen> {
  bool isHovered = false;
  bool isHoveredFaq = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight > 600 ? 60.0 : 30.0;

    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Stack(
        children: [
          Container(
            height: (isWebOrWindows && !isMobile) ? 55 : 75,
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
              boxShadow: [
                BoxShadow(
                  color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.none,
            child: Padding(
              padding: EdgeInsets.only(top: isMobile ? 35 : 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: CustomTooltip(
                      message: 'Назад',
                      horizontalOffset: -35,
                      verticalOffset: 10,
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
                        child: Material(
                          color: ChatifyColors.transparent,
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
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(S.of(context).problemDetected, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: isMobile ? Alignment.topCenter : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: isMobile ? 40 : 70, bottom: 15),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
                  decoration: BoxDecoration(
                    color: isAndroid ? ChatifyColors.transparent : ChatifyColors.deepNight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _buildContent(),
                ),
              ),
            ),
          ),
          if (isMobile) ...[
            GestureDetector(
              onTap: () async {
                await Dialogs.showCustomDialog(context: context, message: S.of(context).connected, duration: const Duration(seconds: 4));
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const SupportScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ));
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  child: Center(
                    child: Text(S.of(context).thereNoAnswerMyQuestion, style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: Platform.isWindows ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(S.of(context).enteredNotValidNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, height: 1.5), textAlign: Platform.isWindows ? TextAlign.center : TextAlign.left),
            const SizedBox(height: 20),
            Text(S.of(context).returnPreviousScreen, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, height: 1.5), textAlign: Platform.isWindows ? TextAlign.center : TextAlign.left),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: Platform.isWindows ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Platform.isWindows ? Alignment.center : Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '1. ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, height: 1.5)),
                          TextSpan(text: S.of(context).listSuggestedCountries, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, height: 1.5)),
                        ],
                      ),
                      textAlign: Platform.isWindows ? TextAlign.center : TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Platform.isWindows ? Alignment.center : Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '2. ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, height: 1.5)),
                          TextSpan(text: S.of(context).doNotEnterZero, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, height: 1.5)),
                        ],
                      ),
                      textAlign: Platform.isWindows ? TextAlign.center : TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(S.of(context).correctPhoneNumYourCountry, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, height: 1.5), textAlign: Platform.isWindows ? TextAlign.center : TextAlign.left),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: S.of(context).moreDetailedInfo, style: TextStyle(height: 1.5)),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => isHoveredFaq = true),
                      onExit: (_) => setState(() => isHoveredFaq = false),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const HelpCenterScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                          ));
                        },
                        child: Text(
                          S.of(context).articleFaq,
                          style: TextStyle(
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            fontWeight: FontWeight.w400,
                            fontSize: ChatifySizes.fontSizeSm,
                            decoration: isHoveredFaq ? TextDecoration.underline : TextDecoration.none,
                            decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '.', style: TextStyle(height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (Platform.isWindows)
              SizedBox(
                child: ElevatedButton(
                  onPressed: () async {
                    await Dialogs.showCustomDialog(context: context, message: S.of(context).connected, duration: const Duration(seconds: 4));
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SupportScreen(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ).copyWith(
                    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                  ),
                  child: Text(
                    S.of(context).thereNoAnswerMyQuestion,
                    style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
