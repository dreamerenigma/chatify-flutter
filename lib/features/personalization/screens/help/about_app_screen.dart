import 'package:chatify/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../version.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(context.isDarkMode ? ChatifyImages.helpBackgroundDarkV1 : ChatifyImages.helpBackgroundDarkV1 , fit: BoxFit.cover)),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$appName ${'Messenger'}', style: TextStyle(color: ChatifyColors.white, fontSize: 23, fontWeight: FontWeight.w400, height: 1.4)),
                  Text('${S.of(context).version} $appVersion.$appBuildNumber', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 17, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 30),
                  SvgPicture.asset(ChatifyVectors.appLogoLight, width: 90, height: 90),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('© ', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                      Text('2024—${DateTime.now().year} Input Studios Inc.', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(DeviceUtils.getScreenWidth(context) * .4, DeviceUtils.getScreenHeight(context) * .02),
                      backgroundColor: ChatifyColors.blue,
                      foregroundColor: ChatifyColors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      side: BorderSide.none,
                    ),
                    onPressed: () {},
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SvgPicture.asset(ChatifyVectors.license, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn), width: 25, height: 25),
                    ),
                    label: Text(S.of(context).licenses, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
