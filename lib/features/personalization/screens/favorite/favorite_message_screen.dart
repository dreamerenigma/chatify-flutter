import 'package:flutter/material.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../home/widgets/icons/centered_star_icon.dart';

class FavoriteMessageScreen extends StatelessWidget {
  const FavoriteMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Избранные сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        backgroundColor: ChatifyColors.blackGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              color: ChatifyColors.black,
              child: const CenteredStarIcon(),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DeviceUtils.getScreenWidth(context) * .2),
              child: Text(
                'Нажмите и удерживайте сообщение, чтобы добавить его в Избранные. Таким образом, вы сможете легко найти его позже.',
                style: TextStyle(
                  fontSize: ChatifySizes.fontSizeMd,
                  color: ChatifyColors.darkGrey
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
