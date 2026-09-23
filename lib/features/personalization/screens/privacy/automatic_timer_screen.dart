import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/custom_radio_list_tile.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AutomaticTimerScreen extends StatefulWidget {
  const AutomaticTimerScreen({super.key});

  @override
  State<AutomaticTimerScreen> createState() => AutomaticTimerScreenState();
}

class AutomaticTimerScreenState extends State<AutomaticTimerScreen> {
  final _storage = GetStorage();
  String _selectedOption = '';
  final List<Map<String, String>> _options = [
    {'value': 'day', 'label': '24 часа'},
    {'value': 'week', 'label': '7 дней'},
    {'value': 'month', 'label': '90 дней'},
    {'value': 'off', 'label': 'Выкл.'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = _storage.read('selected_automatic_timer') ?? 'off';
  }

  void _saveSelection(String value) {
    setState(() {
      _selectedOption = value;
    });
    _storage.write('selected_automatic_timer', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text(S.of(context).automaticTimer, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final result = _options.firstWhere((option) => option['value'] == _selectedOption)['label'] ?? S.of(context).off;

                Navigator.pop(context, result);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: Text(
              S.of(context).timerDisappearingMessagesNewChats,
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
            ),
          ),
          RadioGroup<String>(
            groupValue: _selectedOption,
            onChanged: (value) {
              if (value != null) {
                _saveSelection(value);
              }
            },
            child: Column(
              children: _options.map((option) {
                return CustomRadioListTile<String>(
                  value: option['value']!,
                  isSelected: _selectedOption == option['value'],
                  title: Text(option['label']!, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  inactiveIconColor: ChatifyColors.lightSoftNight,
                  radioPosition: RadioPositionType.left,
                  radioScale: 1.13,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 16),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                children: _selectedOption == 'off'
                  ? [
                      TextSpan(text: S.of(context).modeEnabledMessagesNewIndividualChats, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4)),
                      TextSpan(
                        text: S.of(context).readMore,
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, height: 1.4),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ]
                  : [
                      TextSpan(text: S.of(context).notAffectApplyMessageTimerExistingChats, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4)),
                      TextSpan(
                        text: S.of(context).selectThem,
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, height: 1.4),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(
                        text: S.of(context).readMore,
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, height: 1.4),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
