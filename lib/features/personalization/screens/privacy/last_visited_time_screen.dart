import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
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
    final List<Map<String, String>> options = [
      {'value': 'everyone', 'label': S.of(context).all},
      {'value': 'contacts', 'label': S.of(context).myContacts},
      {'value': 'favorites', 'label': S.of(context).contactsOtherThan},
      {'value': 'nobody', 'label': S.of(context).nobody},
    ];
    final List<Map<String, String>> onlineStatusOptions = [
      {'value': 'everyone', 'label': S.of(context).all},
      {'value': 'contacts', 'label': S.of(context).myContacts},
    ];

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
            title: Text(S.of(context).lastVisitedTime, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final result = '${options.firstWhere((option) => option['value'] == _selectedOption)['label']}, '
                  '${onlineStatusOptions.firstWhere((option) => option['value'] == _selectedOnlineStatusOption)['label']}';
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
            child: Text(S.of(context).whoSeesMyLastVisitTime, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey)),
          ),
          ...options.map((option) {
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
              S.of(context).whoSeesOnline,
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
          ...onlineStatusOptions.map((option) {
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
              S.of(context).shareYourLastSeenTimeOnlineStatus,
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey),
            ),
          ),
        ],
      ),
    );
  }
}
