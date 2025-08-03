import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../checkboxes/custom_checkbox.dart';

class StorageOptionWidget extends StatefulWidget {
  const StorageOptionWidget({super.key});

  @override
  State<StorageOptionWidget> createState() => _StorageOptionWidgetState();
}

class _StorageOptionWidgetState extends State<StorageOptionWidget> {
  final GetStorage _storage = GetStorage();
  final RxList<bool> selectedOptions = List.generate(4, (index) => true).obs;
  late List<String> options;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    options = [S.of(context).photo, S.of(context).audio, S.of(context).video, S.of(context).documents];
  }

  void _loadCheckboxState() {
    List? storedState = _storage.read('checkboxState');
    if (storedState != null) {
      selectedOptions.assignAll(List<bool>.from(storedState));
    }
  }

  void _saveCheckboxState() {
    _storage.write('checkboxState', selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).storage, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
          const SizedBox(height: 25),
          Text(S.of(context).autoload, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
          const SizedBox(height: 10),
          Text(
            S.of(context).chooseMediaFilesDownloadedAutoMessages,
            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 12),
          _buildCheckbox(context),
        ],
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return Column(
      children: List.generate(options.length, (index) {
        if (selectedOptions.length <= index) {
          selectedOptions.add(false);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CustomCheckbox(
                index: index,
                selectedOptions: selectedOptions,
                onChanged: (bool newValue) {
                  _saveCheckboxState();
                },
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  selectedOptions[index] = !selectedOptions[index];
                  _saveCheckboxState();
                },
                child: Text(options[index], style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
