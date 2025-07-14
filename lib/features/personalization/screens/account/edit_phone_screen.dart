import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'add_edit_phone_screen.dart';

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({super.key});

  @override
  State<EditPhoneScreen> createState() => EditPhoneScreenState();
}

class EditPhoneScreenState extends State<EditPhoneScreen> {
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
            title: Text('Изменить номер', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: SvgPicture.asset(
                      ChatifyVectors.simCard,
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    child: Text('Изменение вашего номера телефона приведёт, к перемещению ваших групп, настроек и данных вашего аккаунта.',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Прежде чем продолжить, убедитесь, что вы сможете принимать SMS или звонки на свой новый номер.',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Если у вас сменился и телефон, и номер, сначала измените свой номер на старом телефоне.',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, createPageRoute(const AddEditPhoneScreen()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: ChatifyColors.white,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
              child: Text('Далее', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: ChatifyColors.black)),
            ),
          ),
        ],
      ),
    );
  }
}