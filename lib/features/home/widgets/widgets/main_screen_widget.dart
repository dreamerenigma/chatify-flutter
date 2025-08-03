import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

class MainScreenWidget extends StatelessWidget {
  final double sidePanelWidth;

  const MainScreenWidget({super.key, required this.sidePanelWidth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        width: 80,
                        height: 80,
                        ChatifyVectors.logoApp,
                        color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                      ),
                      SizedBox(height: 25),
                      Text(
                        S.of(context).appForWindows,
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300, color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black),
                      ),
                      SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          double containerWidth = screenWidth > 1080 ? screenWidth * 0.7 : screenWidth;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: containerWidth,
                              child: Text(
                                S.of(context).sendReceiveMessagesFourLinkDevice,
                                style: TextStyle(fontWeight: FontWeight.w300, height: 1.3, fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.deepNight),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildProtected(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProtected(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(HeroIcons.lockClosed, color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, size: 12),
          SizedBox(width: 8),
          Text(S.of(context).protectedEncryption, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
