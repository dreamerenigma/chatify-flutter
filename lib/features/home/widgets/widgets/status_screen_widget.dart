import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';

class StatusScreenWidget extends StatelessWidget {
  final double sidePanelWidth;

  const StatusScreenWidget({super.key, required this.sidePanelWidth});

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
                      SizedBox(
                        child: Text(
                          S.of(context).clickContactNameStatus,
                          style: TextStyle(fontWeight: FontWeight.w300, height: 1.3, fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(padding: const EdgeInsets.only(right: 6), child: HeroIcon(HeroIcons.lockClosed, color: ChatifyColors.darkGrey, size: 14)),
                            ),
                            TextSpan(
                              text: S.of(context).statusUpdatesProtectedEncryption,
                              style: TextStyle(fontSize: 13, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
