import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/platforms/platform_utils.dart';
import '../../personalization/screens/send/send_file_screen.dart';
import '../../authentication/screens/add_account_screen.dart';
import '../../home/screens/home_screen.dart';
import 'package:chatify/api/apis.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (kIsWeb) {
      Future.delayed(const Duration(seconds: 3), () => _navigateToNextScreen());
      return;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          _navigateToSendFileScreen(value.first.path);
        } else {
          Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);
        }
      }).catchError((error) {
        Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);
      });

      ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          _navigateToSendFileScreen(value.first.path);
        }
      });
    } else if (Platform.isWindows) {
      Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);
    }
  }

  void _navigateToSendFileScreen(String path) {
    Get.off(() => SendFileScreen(fileToSend: path, linkToSend: ''));
  }

  Future<void> _navigateToNextScreen() async {
    if (APIs.auth.currentUser != null) {
      await APIs.getSelfInfo();
      Get.off(() => HomeScreen(user: APIs.me));
    } else {
      Get.off(() => const AddAccountScreen(isFromSplashScreen: true, showBackButton: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final logoAsset = context.isDarkMode ? ChatifyImages.appLogoLight : ChatifyImages.appLogoDark;

    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Stack(
        children: [
          if (isWebOrWindows) Center(child: Image.asset(logoAsset, width: mq.size.width * .15))
          else
            Positioned(
              top: mq.size.height * 0.35,
              left: 0,
              right: 0,
              child: Center(child: Image.asset(logoAsset, width: mq.size.width * .5)),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: ChatifySizes.defaultSpace),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).createIn, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey)),
                  Image.asset(ChatifyImages.logoIS, width: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
