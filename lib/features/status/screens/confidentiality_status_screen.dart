import 'package:chatify/features/status/screens/share_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import 'exceptions_screen.dart';

class ConfidentialityStatusScreen extends StatefulWidget {
  const ConfidentialityStatusScreen({super.key});

  @override
  ConfidentialityStatusScreenState createState() => ConfidentialityStatusScreenState();
}

class ConfidentialityStatusScreenState extends State<ConfidentialityStatusScreen> {
  int? _selectedValue;
  final GetStorage storage = GetStorage();
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedValue();
  }

  void _loadSelectedValue() {
    _selectedValue = storage.read<int>('selectedRadioValue') ?? 1;
  }

  void _saveSelectedValue(int value) {
    storage.write('selectedRadioValue', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Text(S.of(context).confidentialityStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeMg)),
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Dialogs.showSnackbarMargin(context, S.of(context).settingsSaved, margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                );
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
            padding: const EdgeInsets.all(16.0),
            child: Text(S.of(context).seeStatusUpdates, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
          ),
          Column(
            children: [
              ListTile(
                title: Text(S.of(context).myContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                leading: Radio<int>(
                  value: 1,
                  groupValue: _selectedValue,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                      _saveSelectedValue(value!);
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedValue = 1;
                    _saveSelectedValue(_selectedValue!);
                  });
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).contactsExcept,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(const ExceptionsScreen()));
                      },
                      child: Text(
                        '${S.of(context).exception} ($counter)',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      ),
                    ),
                  ],
                ),
                leading: Radio<int>(
                  value: 2,
                  groupValue: _selectedValue,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                      _saveSelectedValue(value!);
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedValue = 2;
                    _saveSelectedValue(_selectedValue!);
                  });
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).only, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(const ShareScreen()));
                      },
                      child: Row(
                        children: [
                          Text(
                            '${S.of(context).on} ($counter)',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                leading: Radio<int>(
                  value: 3,
                  groupValue: _selectedValue,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                      _saveSelectedValue(value!);
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _selectedValue = 3;
                    _saveSelectedValue(_selectedValue!);
                  });
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(S.of(context).changesAffectStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
          ),
        ],
      ),
    );
  }
}
