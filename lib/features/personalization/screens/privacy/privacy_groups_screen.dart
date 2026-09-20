import 'package:chatify/features/personalization/widgets/dialogs/custom_radio_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/enums/radio_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
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
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text(S.of(context).groups, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final result = _options.firstWhere((option) => option['value'] == _selectedOption)['label'] ?? S.of(context).myContacts;

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
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 4),
            child: Text(S.of(context).whoCanAddGroups, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
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
                  title: Text(option['label']!, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  inactiveIconColor: ChatifyColors.red,
                  radioPosition: RadioPositionType.left,
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  radioScale: 1.15,
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              S.of(context).adminsCannotAddGroupOptionSend,
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              S.of(context).settingApplyCommunityAdSets,
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
