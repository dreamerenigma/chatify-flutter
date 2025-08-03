import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class PrivacyPhotoProfileScreen extends StatefulWidget {
  const PrivacyPhotoProfileScreen({super.key});

  @override
  State<PrivacyPhotoProfileScreen> createState() => PrivacyPhotoProfileScreenState();
}

class PrivacyPhotoProfileScreenState extends State<PrivacyPhotoProfileScreen> {
  final _storage = GetStorage();
  String _selectedOption = '';

  final List<Map<String, String>> _options = [
    {'value': 'everyone', 'label': 'Все'},
    {'value': 'contacts', 'label': 'Мои контакты'},
    {'value': 'favorites', 'label': 'Контакты, кроме...'},
    {'value': 'nobody', 'label': 'Никто'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = _storage.read('selected_photo_privacy') ?? 'contacts';
  }

  void _saveSelection(String value) {
    setState(() {
      _selectedOption = value;
    });
    _storage.write('selected_photo_privacy', value);
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
            title: Text(S.of(context).profilePhoto, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
              S.of(context).seesMyProfilePicture,
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
              title: Text(option['label']!, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
            );
          }),
        ],
      ),
    );
  }
}
