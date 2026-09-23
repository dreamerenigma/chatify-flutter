import 'package:chatify/features/personalization/screens/profile/username_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';

class CongratulationUsernameScreen extends StatelessWidget {
  final UserModel user;

  const CongratulationUsernameScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(ChatifyVectors.reservedUsername, width: 130, height: 130),
                      const SizedBox(height: 30),
                      Text(
                        'Вы зарезервировали имя пользователя @${user.username}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Чтобы клиенты могли связаться с вами впервые, вы скоро сможете поделиться с ними своим именем пользователя, а не номером телефона.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Мы сообщим, когда ваше ммя пользователя будет готово.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomBottomButton(
              text: 'Готово',
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UsernameScreen(user: user)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
