import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

class CommunitiesScreenWidget extends StatelessWidget {
  final double sidePanelWidth;

  const CommunitiesScreenWidget({
    super.key,
    required this.sidePanelWidth,
  });

  @override
  Widget build(BuildContext context) {
    return  Stack(
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
                      SvgPicture.asset(ChatifyVectors.communities, width: 65, height: 65, colorFilter: ColorFilter.mode(ChatifyColors.steelGrey, BlendMode.srcIn)),
                      const SizedBox(height: 16),
                      Text(
                        'Создавайте сообщества',
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 30, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Объединяйте участников в тематические группы и легко отправляйте им объявление от админа.',
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.3),
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
                              child: Padding(padding: const EdgeInsets.only(right: 4), child: Icon(Icons.lock_outline_rounded, size: 18, color: ChatifyColors.darkGrey)),
                            ),
                            TextSpan(
                              text: 'Ваши личные сообщения в сообществах защищены сквозным шифрованием',
                              style: TextStyle(fontSize: 13, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
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
