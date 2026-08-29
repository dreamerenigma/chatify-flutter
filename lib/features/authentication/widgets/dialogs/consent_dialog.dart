import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

Future<void> showConsentDialog(BuildContext context, String url) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry overlayEntry;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, -0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));
  final Animation<double> fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  bool isHovered = false;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
          child: GestureDetector(
          behavior: HitTestBehavior.opaque,
            onTap: () {
              animationController.reverse().then((_) => overlayEntry.remove());
            },
          ),
        ),
        Center(
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Material(
                color: ChatifyColors.transparent,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                child: Container(
                  width: 500,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.lightGrey,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.lightGrey)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Google Authorization', style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, setState) {

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) {
                                  isHovered = true;
                                  setState(() {});
                                },
                                onExit: (_) {
                                  isHovered = false;
                                  setState(() {});
                                },
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                        fontSize: ChatifySizes.fontSizeSm,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Пожалуйста, разрешите доступ к Google-аккаунту, перейдя по '),
                                        TextSpan(
                                          text: 'ссылке',
                                          style: TextStyle(
                                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                            decoration: isHovered ? TextDecoration.none : TextDecoration.underline,
                                            decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                          ),
                                          recognizer: TapGestureRecognizer()..onTap = () async {
                                            overlayEntry.remove();
                                            animationController.dispose();

                                            await Future.delayed(Duration(milliseconds: 300));
                                            await UrlUtils.launchURL(url);

                                            if (context.mounted) {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                Dialogs.showCustomDialog(context: context, message: S.of(context).connected, duration: const Duration(seconds: 4));
                                              });
                                            }
                                          },
                                        ),
                                        const TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  overlayEntry.remove();
                                  animationController.dispose();

                                  await Future.delayed(Duration(milliseconds: 300));
                                  await UrlUtils.launchURL(url);

                                  if (context.mounted) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      Dialogs.showCustomDialog(context: context, message: S.of(context).connected, duration: const Duration(seconds: 4));
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  foregroundColor: ChatifyColors.black,
                                  elevation: 1,
                                  shadowColor: ChatifyColors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()), width: 1),
                                  ),
                                ).copyWith(
                                  mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                ),
                                child: Text("Open in Browser", style: TextStyle(color: ChatifyColors.black, fontWeight: FontWeight.w400)),
                              ),
                              SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  animationController.reverse().then((_) {
                                    overlayEntry.remove();
                                    completer.complete();
                                  });
                                },
                                style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                  backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  foregroundColor: ChatifyColors.black,
                                  elevation: 1,
                                  shadowColor: ChatifyColors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1),
                                  ),
                                ).copyWith(
                                  mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                ),
                                child: Text(S.of(context).cancel, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w400)),
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
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();

  return completer.future;
}
