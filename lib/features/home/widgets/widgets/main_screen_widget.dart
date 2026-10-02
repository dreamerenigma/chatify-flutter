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
                        colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey, BlendMode.srcIn),
                      ),
                      SizedBox(height: 25),
                      Text(
                        S.of(context).appForWindows,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 19, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          double containerWidth = screenWidth > 1080 ? screenWidth * 0.7 : screenWidth;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: containerWidth,
                              child: Text(
                                S.of(context).sendReceiveMessagesFourLinkDevice,
                                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.deepNight, height: 1.3, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
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
          HeroIcon(HeroIcons.lockClosed, size: 12, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              S.of(context).protectedEncryption,
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
