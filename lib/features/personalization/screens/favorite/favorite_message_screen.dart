import 'package:flutter/material.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../home/widgets/icons/centered_star_icon.dart';

class FavoriteMessageScreen extends StatelessWidget {
  const FavoriteMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Избранные сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        backgroundColor: ChatifyColors.blackGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 100, height: 100, child: const CenteredStarIcon()),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .2),
              child: Text(
                S.of(context).longPressMessageChannelFavorites,
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
