import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
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
            padding: const EdgeInsets.all(16),
            child: Text(
              S.of(context).timerDisappearingMessagesNewChats,
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
          ..._options.map((option) {
            return RadioListTile(
              value: option['value'],
              groupValue: _selectedOption,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
              activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              onChanged: (value) {
                _saveSelection(value as String);
              },
              visualDensity: const VisualDensity(vertical: -2),
              title: Text(
                  option['label']!,
                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
                children: _selectedOption == 'off' ?
                  [
                    TextSpan(text: S.of(context).modeEnabledMessagesNewIndividualChats),
                    TextSpan(
                      text: S.of(context).readMore,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ]
                  : [
                      TextSpan(text: S.of(context).notAffectApplyMessageTimerExistingChats),
                  TextSpan(
                    text: S.of(context).selectThem,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  TextSpan(
                    text: S.of(context).readMore,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, color: ChatifyColors.blue),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  const WidgetSpan(child: SizedBox(height: 30)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
