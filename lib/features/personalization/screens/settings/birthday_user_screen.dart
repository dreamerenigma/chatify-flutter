import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';
import '../../../utils/widgets/buttons/text_action_button.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/fields/birthday_dropdown_field.dart';
import 'link_guardian_phone_screen.dart';

class BirthdayUserScreen extends StatefulWidget {
  final UserModel user;

  const BirthdayUserScreen({
    super.key,
    required this.user,
  });

  @override
  State<BirthdayUserScreen> createState() => _BirthdayUserScreenState();
}

class _BirthdayUserScreenState extends State<BirthdayUserScreen> {
  int? selectedYear;
  DateTime? selectedBirthday;

  bool get isChildUnderFive {
    if (selectedYear == null) return false;

    final currentYear = DateTime.now().year;

    return selectedYear! >= currentYear - 5;
  }

  bool get needsBirthdayDate {
    if (selectedYear == null || selectedYear == 0) {
      return false;
    }

    final currentYear = DateTime.now().year;

    return selectedYear! >= currentYear - 18;
  }

  int get age {
    if (selectedBirthday == null) {
      return 0;
    }

    final now = DateTime.now();

    int result = now.year - selectedBirthday!.year;

    final birthdayThisYear = DateTime(now.year, selectedBirthday!.month, selectedBirthday!.day);

    if (birthdayThisYear.isAfter(now)) {
      result--;
    }

    return result;
  }

  String _ageWord(int age) {
    if (age % 10 == 1 && age % 100 != 11) {
      return 'год';
    }

    if (age % 10 >= 2 && age % 10 <= 4 && (age % 100 < 10 || age % 100 >= 20)) {
      return 'года';
    }

    return 'лет';
  }

  String _monthName(int month) {
    const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];

    return months[month - 1];
  }

  List<DateTime> get _birthDates {
    if (selectedYear == null || selectedYear == 0) {
      return [];
    }

    final year = selectedYear!;
    final firstDay = DateTime(year, 1, 1);
    final nextYear = DateTime(year + 1, 1, 1);
    final days = nextYear.difference(firstDay).inDays;

    return List.generate(days, (index) => firstDay.add(Duration(days: index)));
  }

  List<int> get _years {
    final currentYear = DateTime.now().year;

    return List.generate(100, (index) => currentYear - index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      SvgPicture.asset(ChatifyVectors.birthdayUser, width: 70, height: 70),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Когда родился пользователь ${widget.user.name}?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 25, fontWeight: FontWeight.w400,  height: 1.3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Это необходимо для настройки родительского контроля. Другие пользователи Chatify не увидят возраст вашего ребёнка. ',
                                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400, height: 1.4),
                              ),
                              TextSpan(
                                text: 'Почему мы запрашиваем эту информацию?',
                                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      BirthdayDropdownField<int>(
                        label: 'Выберите год',
                        value: selectedYear,
                        items: _years,
                        itemBuilder: (year) => '$year',
                        valueBuilder: (year) => '$year',
                        onChanged: (year) {
                          setState(() {
                            selectedYear = year;
                            selectedBirthday = null;
                          });
                        },
                      ),
                      if (selectedYear != null && selectedYear != 0 && needsBirthdayDate) ...[
                        const SizedBox(height: 12),
                        BirthdayDropdownField<DateTime>(
                          label: 'Выбрать день/месяц',
                          value: selectedBirthday,
                          items: _birthDates,
                          placeholder: 'День/месяц',
                          itemBuilder: (date) {
                            return '${date.day.toString().padLeft(2, '0')}/''${date.month.toString().padLeft(2, '0')}';
                          },
                          valueBuilder: (date) {
                            return '${date.day.toString().padLeft(2, '0')}/''${date.month.toString().padLeft(2, '0')} ''${_monthName(date.month)}';
                          },
                          onChanged: (date) {
                            setState(() {
                              selectedBirthday = date;
                            });
                          },
                        ),
                        if (selectedBirthday != null) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$age ${_ageWord(age)}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey)),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                CustomBottomButton(
                  text: 'Далее',
                  onTap: () {
                    if (selectedYear == null) {
                      return;
                    }

                    if (needsBirthdayDate && selectedBirthday == null) {
                      return;
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (_) => LinkGuardianPhoneScreen(user: widget.user, birthday: selectedBirthday!)));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                  child: TextActionButton(
                    text: 'Не сейчас',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
