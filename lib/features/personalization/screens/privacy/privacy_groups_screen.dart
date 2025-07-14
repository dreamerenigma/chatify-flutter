import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class PrivacyGroupsScreen extends StatefulWidget {
  const PrivacyGroupsScreen({super.key});

  @override
  State<PrivacyGroupsScreen> createState() => PrivacyGroupsScreenState();
}

class PrivacyGroupsScreenState extends State<PrivacyGroupsScreen> {
  final _storage = GetStorage();
  String _selectedOption = '';

  final List<Map<String, String>> _options = [
    {'value': 'everyone', 'label': 'Все'},
    {'value': 'contacts', 'label': 'Мои контакты'},
    {'value': 'favorites', 'label': 'Контакты, кроме...'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = _storage.read('selected_groups_privacy') ?? 'contacts';
  }

  void _saveSelection(String value) {
    setState(() {
      _selectedOption = value;
    });
    _storage.write('selected_groups_privacy', value);
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
              'Группы',
              style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
            ),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final result = _options.firstWhere((option) => option['value'] == _selectedOption)['label'] ?? 'Мои контакты';
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
              'Кто может добавлять меня в группы',
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
              title: Text(
                option['label']!,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'У админов, которые не могут добавить вас в группу, будет возможность отправить вам личное приглашение.',
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Эта настройка не применяется к группам объявлений сообщества. При добавлении в сообщество вы автоматически добавляетесь в группу объявлений сообщества.',
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
        ],
      ),
    );
  }
}
