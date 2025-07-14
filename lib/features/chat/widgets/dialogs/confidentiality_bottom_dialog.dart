import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../status/screens/exceptions_screen.dart';
import '../../../status/screens/share_screen.dart';

void showConfidentialityBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (context) {
      return const ConfidentialityStatusBottomSheet();
    },
  );
}

class ConfidentialityStatusBottomSheet extends StatefulWidget {
  const ConfidentialityStatusBottomSheet({super.key});

  @override
  State<ConfidentialityStatusBottomSheet> createState() => _ConfidentialityStatusBottomSheetState();
}

class _ConfidentialityStatusBottomSheetState extends State<ConfidentialityStatusBottomSheet> {
  int? _selectedValue;
  final GetStorage storage = GetStorage();
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _selectedValue = storage.read<int>('selectedRadioValue') ?? 1;
  }

  void _saveSelectedValue(int value) {
    storage.write('selectedRadioValue', value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.iconGrey, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 12),
              child: Text(S.of(context).seeStatusUpdates, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 24),
              horizontalTitleGap: 8,
              title: Text(S.of(context).myContacts, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
              leading: Transform.scale(
                scale: 1.2,
                child: Radio<int>(
                  value: 1,
                  groupValue: _selectedValue,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                      _saveSelectedValue(value);
                    });
                  },
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedValue = 1;
                  _saveSelectedValue(_selectedValue!);
                });
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 24),
              horizontalTitleGap: 8,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).contactsExcept, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  InkWell(
                    onTap: () => Navigator.push(context, createPageRoute(const ExceptionsScreen())),
                    child: Text(
                      '${S.of(context).exception} ($counter)',
                      style: TextStyle(fontSize: 15, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    ),
                  ),
                ],
              ),
              leading: Transform.scale(
                scale: 1.2,
                child: Radio<int>(
                  value: 2,
                  groupValue: _selectedValue,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                      _saveSelectedValue(value);
                    });
                  },
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedValue = 2;
                  _saveSelectedValue(_selectedValue!);
                });
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 10, right: 24),
              horizontalTitleGap: 8,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).only, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  InkWell(
                    onTap: () => Navigator.push(context, createPageRoute(const ShareScreen())),
                    child: Text(
                      '${S.of(context).on} ($counter)',
                      style: TextStyle(fontSize: 15, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    ),
                  ),
                ],
              ),
              leading: Transform.scale(
                scale: 1.2,
                child: Radio<int>(
                  value: 3,
                  groupValue: _selectedValue,
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                      _saveSelectedValue(value);
                    });
                  },
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedValue = 3;
                  _saveSelectedValue(_selectedValue!);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 4),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Dialogs.showSnackbarMargin(context, S.of(context).settingsSaved, margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0
                  ),
                  child: Text("Готово", style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
