import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/authentication/screens/enter_phone_number.dart';
import 'package:chatify/features/home/screens/home_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_sounds.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../../utils/popups/custom_tooltip.dart';
import '../../../utils/popups/dialogs.dart';
import 'enter_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late Size mq;
  late AudioPlayer audioPlayer;
  bool isAnimate = false;
  bool isHovered = false;
  String? googleAuthUrl;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playClickButton(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.clickButton));
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

  void handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);

    APIs.signInWithGoogle().then((user) async {
      Navigator.pop(context);

      if (user != null) {
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          await APIs.getSelfInfo();

          Navigator.pushReplacement(context, createPageRoute(HomeScreen(user: APIs.me)));
        } else {
          await APIs.createUserInFirestore(context).then((value) async {
            await APIs.getSelfInfo();

            Navigator.pushReplacement(context, createPageRoute(HomeScreen(user: APIs.me)));
          });
        }
      } else {}
    }).catchError((e) {
      Navigator.pop(context);

      final isOffline = kIsWeb ? e.toString().contains('network') || e.toString().contains('Failed to fetch') : e is SocketException;

      if (isOffline) {
        Dialogs.showSnackbar(context, S.of(context).checkInternet);
      } else {
        log('\nError signing in with Google: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    final logoAsset = context.isDarkMode ? ChatifyImages.appLogoLight : ChatifyImages.appLogoDark;

    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              padding: EdgeInsets.only(left: 5, right: 5, top: isWebOrWindows ? 10 : 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTooltip(
                    message: 'Закрыть',
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
                            child: !isWebOrWindows && isMobile
                              ? Container()
                              : Icon(Icons.arrow_back, color: isHovered ? context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white : ChatifyColors.white),
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
                          child: Padding(
                            padding: EdgeInsets.only(top: isMobile ? 0 : 8),
                            child: Text(S.of(context).welcome, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: mq.height * .05),
                    Container(
                      height: mq.height * 0.25,
                      alignment: Alignment.center,
                      child: AnimatedContainer(duration: const Duration(seconds: 1), width: isAnimate ? mq.width * 0.5 : 0, child: Image.asset(logoAsset)),
                    ),
                    SizedBox(height: mq.height * .06),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            width: isWebOrWindows ? mq.width < 600 ? mq.width * 0.5 : mq.width < 900 ? mq.width * 0.40 : mq.width * 0.3 : double.infinity,
                            height: isWebOrWindows ? 45 : 55,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                backgroundColor: ChatifyColors.lightBlue,
                                foregroundColor: ChatifyColors.white,
                                shape: const StadiumBorder(),
                                elevation: 1,
                                side: BorderSide.none,
                              ).copyWith(
                                mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                              ),
                              onPressed: () async {
                                await playClickButton(audioPlayer);
                                if (isWindows) {
                                  await APIs.signInWithGoogleForWindows(context);
                                } else {
                                  handleGoogleBtnClick();
                                }
                              },
                              icon: Image.asset(ChatifyImages.google, height: mq.height * 0.03),
                              label: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: ChatifyColors.white, fontSize: 16),
                                  children: [
                                    TextSpan(text: S.of(context).loginWith),
                                    const TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: mq.height * .008),
                          SizedBox(
                            width: isWebOrWindows ? mq.width < 600 ? mq.width * 0.5 : mq.width < 900 ? mq.width * 0.40 : mq.width * 0.3 : double.infinity,
                            height: isWebOrWindows ? 45 : 55,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                backgroundColor: ChatifyColors.green,
                                foregroundColor: ChatifyColors.white,
                                shape: const StadiumBorder(),
                                elevation: 1,
                                side: BorderSide.none,
                              ).copyWith(
                                mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                              ),
                              onPressed: () async {
                                await playClickButton(audioPlayer);
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const EnterPhoneNumberScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ));
                              },
                              icon: const Icon(Icons.phone, size: 24, color: ChatifyColors.white),
                              label: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: ChatifyColors.white, fontSize: 16),
                                  children: [
                                    TextSpan(text: S.of(context).loginWith),
                                    TextSpan(text: S.of(context).phone, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: mq.height * .008),
                          if (isWebOrMobile)
                            SizedBox(
                              width: isWebOrWindows ? mq.width < 600 ? mq.width * 0.5 : mq.width < 900 ? mq.width * 0.40 : mq.width * 0.3 : double.infinity,
                              height: isWebOrWindows ? 45 : 55,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                  backgroundColor: ChatifyColors.violet,
                                  foregroundColor: ChatifyColors.white,
                                  shape: const StadiumBorder(),
                                  elevation: 1,
                                  side: BorderSide.none,
                                ).copyWith(
                                  mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                ),
                                onPressed: () async {
                                  await playClickButton(audioPlayer);
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const EnterEmailScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ));
                                },
                                icon: const Icon(FluentIcons.mail_24_filled, size: 24, color: ChatifyColors.white),
                                label: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: ChatifyColors.white, fontSize: 16),
                                    children: [
                                      TextSpan(text: S.of(context).loginWith),
                                      TextSpan(text: S.of(context).email, style: TextStyle(fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: mq.height * .008),
                    SizedBox(
                      width: isWebOrWindows ? mq.width <= 500 ? mq.width * 0.5 : mq.width > 750 && mq.width <= 900 ? mq.width * 0.45 : mq.width > 900 ? mq.width * 0.3 : mq.width * 0.4 : double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          S.of(context).confirmTerms,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
