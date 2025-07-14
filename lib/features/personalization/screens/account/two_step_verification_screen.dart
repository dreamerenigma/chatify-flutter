import 'package:chatify/features/personalization/screens/help/help_center_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'enable_two_step_verification_screen.dart';

class TwoStepVerificationScreen extends StatelessWidget {
  const TwoStepVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            title: Text('Двухшаговая проверка', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Center(
                    child: Container(
                      width: 80,
                      height: 35,
                      decoration: BoxDecoration(
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          ChatifyVectors.hiddenPinCode,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: ChatifySizes.fontSizeSm,
                          fontWeight: FontWeight.normal,
                          color: ChatifyColors.darkGrey,
                        ),
                        children: [
                          TextSpan(
                            text: 'Чтобы обеспечить дополнительный уровень безопасности, включите двухшаговую проверку, которая будет требовать PIN при повторной регистрации вашего номера в Chatify. ',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                          ),
                          TextSpan(
                            text: 'Подробнее',
                            style: TextStyle(fontWeight: FontWeight.bold, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.push(context, createPageRoute(const HelpCenterScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  createPageRoute(const EnableTwoStepVerificationScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: ChatifyColors.white,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Включить', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: ChatifyColors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
