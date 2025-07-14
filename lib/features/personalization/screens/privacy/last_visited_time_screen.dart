import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class LastVisitedTimeScreen extends StatefulWidget {
  const LastVisitedTimeScreen({super.key});

  @override
  State<LastVisitedTimeScreen> createState() => LastVisitedTimeScreenState();
}

class LastVisitedTimeScreenState extends State<LastVisitedTimeScreen> {
  final _storage = GetStorage();
  String _selectedOption = '';
  String _selectedOnlineStatusOption = '';

  final List<Map<String, String>> _options = [
    {'value': 'everyone', 'label': 'Все'},
    {'value': 'contacts', 'label': 'Мои контакты'},
    {'value': 'favorites', 'label': 'Контакты, кроме...'},
    {'value': 'nobody', 'label': 'Никто'},
  ];

  final List<Map<String, String>> _onlineStatusOptions = [
    {'value': 'everyone', 'label': 'Все'},
    {'value': 'contacts', 'label': 'Мои контакты'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = _storage.read('selected_last_visit_privacy') ?? 'contacts';
    _selectedOnlineStatusOption = _storage.read('selected_online_status_privacy') ?? 'everyone';
  }

  void _saveSelection(String key, String value) {
    setState(() {
      if (key == 'selected_last_visit_privacy') {
        _selectedOption = value;
      } else if (key == 'selected_online_status_privacy') {
        _selectedOnlineStatusOption = value;
      }
    });
    _storage.write(key, value);
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
              'Время последнего посещения',
              style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
            ),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final result = '${_options.firstWhere((option) => option['value'] == _selectedOption)['label']}, '
                  '${_onlineStatusOptions.firstWhere((option) => option['value'] == _selectedOnlineStatusOption)['label']}';
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Кто видит время моего последнего посещения',
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
                _saveSelection('selected_online_status_privacy', value as String);
                setState(() {
                  _selectedOption = value;
                });
              },
              visualDensity: const VisualDensity(vertical: -2),
              title: Text(
                option['label']!,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
            );
          }),
          Divider(color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Кто видит, когда я в сети',
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
          ..._onlineStatusOptions.map((option) {
            return RadioListTile(
              value: option['value'],
              groupValue: _selectedOnlineStatusOption,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
              activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              contentPadding: const EdgeInsets.symmetric(horizontal: 26),
              onChanged: (value) {
                _saveSelection('selected_online_status_privacy', value as String);
                setState(() {
                  _selectedOnlineStatusOption = value;
                });
              },
              visualDensity: const VisualDensity(vertical: -2),
              title: Text(
                option['label']!,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Если вы не делитесь информацией о времени своего последнего посещения в статусе "в сети", вы не сможете видеть время последнего посещения и статус "в сети" других пользователей.',
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
        ],
      ),
    );
  }
}
