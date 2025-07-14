import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class StatusPrivacyScreen extends StatefulWidget {
  const StatusPrivacyScreen({super.key});

  @override
  State<StatusPrivacyScreen> createState() => StatusPrivacyScreenState();
}

class StatusPrivacyScreenState extends State<StatusPrivacyScreen> {
  final _storage = GetStorage();
  String _selectedOption = '';

  final List<Map<String, String>> _options = [
    {'value': 'contacts', 'label': 'Мои контакты'},
    {'value': 'favorites', 'label': 'Контакты, кроме...'},
    {'value': 'nobody', 'label': 'Только...'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = _storage.read('selected_intelligence_privacy') ?? 'contacts';
  }

  void _saveSelection(String value) {
    setState(() {
      _selectedOption = value;
    });
    _storage.write('selected_intelligence_privacy', value);
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
            title: Text(
              'Конфиденциальность статуса',
              style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal),
            ),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Кто жет видеть обновления моего статуса',
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
          ..._options.map((option) {
            return RadioListTile(
              value: option['value'],
              groupValue: _selectedOption,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
              activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              contentPadding: const EdgeInsets.symmetric(horizontal: 26),
              onChanged: (value) {
                _saveSelection(value as String);
              },
              visualDensity: const VisualDensity(vertical: -2),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    option['label']!,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
                  ),
                  if (option['value'] == 'favorites' || option['value'] == 'nobody')
                    Text(
                      option['value'] == 'favorites' ? 'Искл. 0' : 'Вкл. 0',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    ),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Изменения в настройках конфиденциальности не затронут уже отправленные ваши обновления статуса',
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
        ],
      ),
    );
  }
}
