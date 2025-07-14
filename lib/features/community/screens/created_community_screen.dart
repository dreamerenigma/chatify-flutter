import 'package:chatify/features/community/screens/new_community_screen.dart';
import 'package:chatify/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../models/community_model.dart';

class CreatedCommunityScreen extends StatelessWidget {
  final ValueChanged<CommunityModel> onCommunitySelected;

  const CreatedCommunityScreen({super.key, required this.onCommunitySelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(height: DeviceUtils.getScreenHeight(context) * .15),
                Center(
                  child: Image.asset(
                    ChatifyImages.createdCommunity,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Создайте новое сообщество', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Организуйте общение для своего района, учебного заведения или других коллективов. Создавайте тематические группы и пользуйтесь удобной функцией рассылки объявлений от админа.',
                    style: TextStyle(fontSize: 16, color: ChatifyColors.darkGrey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).communityExamples, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.blue)),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios_rounded, color: ChatifyColors.blue, size: 13),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, createPageRoute(NewCommunityScreen(onCommunitySelected: onCommunitySelected)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide.none,
                      ),
                      child: Text('Начать', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
