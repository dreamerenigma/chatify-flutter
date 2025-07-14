import 'dart:math';
import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'dart:async';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../../utils/helpers/window_observer.dart';

Future<void> showNewCallLinkOverlay(BuildContext context, Offset position) async {
  final completer = Completer<void>();
  final overlay = Overlay.of(context);
  final AnimationController animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: Navigator.of(context));
  final Animation<Offset> offsetAnimation = Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero,).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
  final LayerLink layerLink = LayerLink();
  final ValueNotifier<bool> isDisabledNotifier = ValueNotifier(false);
  OverlayEntry? overlayEntry;

  String? callLink;
  bool isGeneratingLink = true;
  bool isLinkGenerationStarted = false;

  String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  overlayEntry = OverlayEntry(
    builder: (context) {
      final callType = 'video';
      bool isTypeCallDropdown = false;
      bool isHovered = false;
      bool isTapped = false;
      bool isHoveredLinkCall = false;

      return StatefulBuilder(
        builder: (context, setState) {
          if (!isLinkGenerationStarted) {
            isLinkGenerationStarted = true;

            isDisabledNotifier.value = true;

            Future.delayed(const Duration(milliseconds: 500), () {
              final callId = generateRandomString(25);
              final generatedLink = 'https://call.chatify.ru/$callType/$callId';
              setState(() {
                callLink = generatedLink;
                isGeneratingLink = false;
                isDisabledNotifier.value = false;
              });
            });
          }

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await animationController.reverse();
                    overlayEntry?.remove();
                    completer.complete();
                    animationController.dispose();
                  },
                ),
              ),
              Positioned(
                left: position.dx,
                top: position.dy,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: CompositedTransformTarget(
                    link: layerLink,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: 310,
                          height: 415,
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha(102) : ChatifyColors.grey),
                            boxShadow: [
                              BoxShadow(
                                color: ChatifyColors.black.withAlpha(26),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'Создать ссылку на звонок',
                                    style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w600, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                        child: HeroIcon(HeroIcons.videoCamera, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Видеозвонок', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 6),
                                            callLink == null
                                              ? Text(
                                                  'Создание ссылки на звонок...',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                                )
                                              : MouseRegion(
                                                  onEnter: (_) => setState(() => isHoveredLinkCall = true),
                                                  onExit: (_) => setState(() => isHoveredLinkCall = false),
                                                  child: InkWell(
                                                    onTap: () {},
                                                    splashColor: ChatifyColors.transparent,
                                                    highlightColor: ChatifyColors.transparent,
                                                    child: Container(
                                                      constraints: const BoxConstraints(maxWidth: 190),
                                                      color: isHoveredLinkCall ? context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey : ChatifyColors.transparent,
                                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                                      child: Text(
                                                        callLink!,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                          height: 1.2,
                                                          decoration: TextDecoration.none,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'Любой пользователь Chatify может присоединиться к звонку по этой ссылке. Делитесь ей только с теми людьми, которым вы доверяете.',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, height: 1.3),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Тип звонка", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: isDisabledNotifier,
                                    builder: (context, isDisabled, _) {
                                      return GestureDetector(
                                        onTap: isDisabled ? null : () {
                                          setState(() => isTypeCallDropdown = !isTypeCallDropdown);
                                        },
                                        onLongPress: () {
                                          setState(() => isTapped = true);
                                        },
                                        onLongPressEnd: (_) {
                                          setState(() => isTapped = false);
                                        },
                                        onLongPressUp: () {
                                          setState(() => isTapped = false);
                                        },
                                        child: MouseRegion(
                                          onEnter: (_) {
                                            setState(() => isHovered = true);
                                          },
                                          onExit: (_) {
                                            setState(() => isHovered = false);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: isDisabled
                                                ? ChatifyColors.darkerGrey
                                                : (isTapped
                                                    ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100))
                                                    : isHovered
                                                        ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha(204) : ChatifyColors.black.withAlpha(76))
                                                        : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white)),
                                              borderRadius: isTypeCallDropdown ? const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                                              border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha(77) : ChatifyColors.grey),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      HeroIcon(HeroIcons.videoCamera, size: 19, color: isDisabled ? ChatifyColors.darkGrey : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                                      const SizedBox(width: 10),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 2),
                                                        child: Text('Видео', style: TextStyle(color: isDisabled ? ChatifyColors.darkGrey : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                                      ),
                                                    ],
                                                  ),
                                                  AnimatedContainer(
                                                    duration: const Duration(milliseconds: 50),
                                                    transform: Matrix4.translationValues(0, (isTapped || isTypeCallDropdown) ? 2.0 : 0, 0),
                                                    child: SvgPicture.asset(ChatifyVectors.arrowDown, color: isDisabled ? ChatifyColors.darkGrey : context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 25),
                                Divider(height: 1, thickness: 0, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
                                SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: isDisabledNotifier,
                                    builder: (context, isDisabled, _) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: isDisabled ? null : () {},
                                              icon: Icon(FluentIcons.copy_24_regular, size: 20, color: isDisabled ? ChatifyColors.darkGrey : ChatifyColors.black,),
                                              label: Text(
                                                'Копировать ссылку',
                                                style: TextStyle(color: isDisabled ? ChatifyColors.darkGrey : ChatifyColors.black, fontWeight: FontWeight.w300),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isDisabled ? ChatifyColors.darkerGrey : colorsController.getColor(colorsController.selectedColorScheme.value),
                                                foregroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.white,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                side: BorderSide.none,
                                                textStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: isDisabled ? null : () {},
                                              icon: SvgPicture.asset(ChatifyVectors.arrowRight, width: 21, height: 21, color: isDisabled ? ChatifyColors.darkGrey : ChatifyColors.black,),
                                              label: Text(
                                                'Отправить ссылку через Chatify',
                                                style: TextStyle(color: isDisabled ? ChatifyColors.darkGrey : ChatifyColors.black, fontWeight: FontWeight.w300),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isDisabled ? ChatifyColors.darkerGrey : colorsController.getColor(colorsController.selectedColorScheme.value),
                                                foregroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.white,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                side: BorderSide.none,
                                                textStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();

  WidgetsBinding.instance.addObserver(
    WindowObserver(
      onSizeChanged: (newSize, newPosition) {
        overlayEntry?.markNeedsBuild();
      },
    ),
  );

  return completer.future;
}
