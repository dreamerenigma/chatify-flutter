import 'package:chatify/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
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
          Positioned.fill(child: Image.asset(ChatifyImages.helpBackgroundDarkV1, fit: BoxFit.cover)),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: ChatifyColors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(appName, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.bold, color: ChatifyColors.white)),
                  const SizedBox(height: 16),
                  Text('${S.of(context).version} $appVersion $appBuildNumber', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                  const SizedBox(height: 16),
                  Image.asset(ChatifyImages.appLogoLight, height: 100),
                  const SizedBox(height: 16),
                  Text('© ${DateTime.now().year} Input Studios Inc.', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(DeviceUtils.getScreenWidth(context) * .4, DeviceUtils.getScreenHeight(context) * .02),
                      backgroundColor: ChatifyColors.blue,
                      foregroundColor: ChatifyColors.white,
                      side: BorderSide.none,
                    ),
                    onPressed: () {},
                    icon: SvgPicture.asset(ChatifyVectors.license, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn), width: 25, height: 25),
                    label: Text(S.of(context).licenses),
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
