import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../widgets/dialogs/light_dialog.dart';

class TransferringChatsScreen extends StatefulWidget {
  const TransferringChatsScreen({super.key});

  @override
  State<TransferringChatsScreen> createState() => TransferringChatsScreenState();
}

class TransferringChatsScreenState extends State<TransferringChatsScreen> {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: SvgPicture.asset(ChatifyVectors.simCard, width: 70, height: 70),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: Text('Перенос истории чатов на устройства Android', style: TextStyle(fontSize: ChatifySizes.fontSizeMg), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text('Конфиденциадльно экспортируйте свою историю чатов и сохраните недавние сообщения без использования хранилища Input Studios. Для подключения к новому устройству необходимо предоставить соответствующие разрешения.',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.4), textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ChatifyColors.white,
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Начать',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: ChatifyColors.black),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(ChatifyColors.black),
                    backgroundColor: WidgetStateProperty.all(ChatifyColors.transparent),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    side: WidgetStateProperty.all(const BorderSide(color: ChatifyColors.darkSlate, width: 1)),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 11)),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(WidgetState.pressed)) {
                          return colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt());
                        }
                        return null;
                      },
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Отмена', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}