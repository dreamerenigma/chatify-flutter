import 'package:chatify/features/personalization/screens/privacy/automatic_timer_screen.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../../utils/widgets/tiles/custom_radio_list_tile.dart';
import '../../widgets/dialogs/light_dialog.dart';

class DisappearingMessagesChatScreen extends StatefulWidget {
  final List<UserModel> users;
  final int selectedDuration;

  const DisappearingMessagesChatScreen({
    super.key,
    required this.users,
    required this.selectedDuration,
  });

  @override
  State<DisappearingMessagesChatScreen> createState() => _DisappearingMessagesChatScreenState();
}

class _DisappearingMessagesChatScreenState extends State<DisappearingMessagesChatScreen> {
  late int selectedDuration;

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.selectedDuration;
  }

  @override
  Widget build(BuildContext context) {
    final usersText = widget.users.map((user) => user.id == APIs.me.id ? 'Вы' : [user.name, user.surname].where((value) => value.trim().isNotEmpty).join(' ')).join(', ');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Исчезающие сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4)),
                if (usersText.isNotEmpty)
                  Text(
                    usersText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontWeight: FontWeight.w400, height: 1.4),
                  ),
              ],
            ),
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context, selectedDuration);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(child: SvgPicture.asset(ChatifyVectors.disappearingMessage, width: 120, height: 120, fit: BoxFit.contain)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Включите исчезающие сообщения в этом чате', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                        children: [
                          const TextSpan(text: 'Новые сообщения в этом чате кроме сохраненных, будут исчезать по истечении выбранного времени у всех участников. '),
                          TextSpan(
                            text: 'Подробнее',
                            style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Таймер сообщений', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 8),
              RadioGroup<int>(
                groupValue: selectedDuration,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedDuration = value;
                  });
                },
                child: Column(
                  children: [
                    CustomRadioListTile<int>(
                      title: Text('24 часа', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      value: 0,
                      radioScale: 1.13,
                      inactiveIconColor: ChatifyColors.steelGrey,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile<int>(
                      title: Text('7 дней', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      value: 1,
                      radioScale: 1.13,
                      inactiveIconColor: ChatifyColors.steelGrey,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile<int>(
                      title: Text('90 дней', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      value: 2,
                      radioScale: 1.13,
                      inactiveIconColor: ChatifyColors.steelGrey,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                    CustomRadioListTile<int>(
                      title: Text('Выкл.', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      value: 3,
                      radioScale: 1.13,
                      inactiveIconColor: ChatifyColors.steelGrey,
                      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      radioPosition: RadioPositionType.left,
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 3, bottom: 3),
                    ),
                  ],
                ),
              ),
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                    children: [
                      TextSpan(text: 'Обновите', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4)),
                      TextSpan(
                        text: ' таймер ',
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(context, createPageRoute(AutomaticTimerScreen()));
                        },
                      ),
                      TextSpan(text: 'в Настройках', style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
