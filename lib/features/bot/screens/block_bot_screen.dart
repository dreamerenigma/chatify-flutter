import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../core/enums/radio_position_type.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../utils/widgets/buttons/custom_bottom_button.dart';
import '../../utils/widgets/tiles/custom_radio_list_tile.dart';

class BlockBotScreen extends StatefulWidget {
  const BlockBotScreen({super.key});

  @override
  State<BlockBotScreen> createState() => _BlockBotScreenState();
}

class _BlockBotScreenState extends State<BlockBotScreen> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Заблокировать компанию', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        backgroundColor: ChatifyColors.blackGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Chatify Support больше не сможет отправлять вам сообщения или звонить.',
                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'По какой причине вы блокируете эту компанию?',
                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            CustomRadioListTile(
              title: Text('Оскорбительные сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              value: '',
              iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
              inactiveIconColor: ChatifyColors.darkGrey,
              radioPosition: RadioPositionType.left,
              radioScale: 1.13,
              padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 3),
            ),
            CustomRadioListTile(
              title: Text('Спам', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              value: '',
              iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
              inactiveIconColor: ChatifyColors.darkGrey,
              radioPosition: RadioPositionType.left,
              radioScale: 1.13,
              padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 3),
            ),
            CustomRadioListTile(
              title: Text('Не давал(а) согласия', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              value: '',
              iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
              inactiveIconColor: ChatifyColors.darkGrey,
              radioPosition: RadioPositionType.left,
              radioScale: 1.13,
              padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 3),
            ),
            CustomRadioListTile(
              title: Text('Больше не нужно', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              value: '',
              iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
              inactiveIconColor: ChatifyColors.darkGrey,
              radioPosition: RadioPositionType.left,
              radioScale: 1.13,
              padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 3),
            ),
            CustomRadioListTile(
              title: Text('Другое', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              value: '',
              iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
              inactiveIconColor: ChatifyColors.darkGrey,
              radioPosition: RadioPositionType.left,
              radioScale: 1.13,
              padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 3),
            ),
            const Spacer(),
            CustomBottomButton(
              text: 'Заблокировать',
              onTap: selectedValue == null ? null : () {},
            ),
          ],
        ),
      ),
    );
  }
}
