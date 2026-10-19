import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../calls/widgets/contents/edit_new_contact_screen_content.dart';
import '../../../calls/widgets/dialog/save_contact_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/buttons/custom_scale_button.dart';
import '../../models/user_model.dart';

void showEditNewContactBottomSheetDialog(BuildContext context, UserModel user) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: false,
    backgroundColor: ChatifyColors.transparent,
    builder: (sheetContext) {
      return EditNewContactBottomSheet(user: user);
    },
  );
}

class EditNewContactBottomSheet extends StatefulWidget {
  final UserModel user;

  const EditNewContactBottomSheet({
    super.key,
    required this.user,
  });

  @override
  State<EditNewContactBottomSheet> createState() => EditNewContactBottomSheetState();
}

class EditNewContactBottomSheetState extends State<EditNewContactBottomSheet> {
  final SaveContactController saveContactController = SaveContactController.instance;
  late final int selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = saveContactController.getOption();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softGrey,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Spacer(),
                        Text(
                          'Новый контакт',
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.close_rounded, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                      child: EditNewContactScreenContent(selectedOption: selectedOption, user: widget.user),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softGrey),
              child: CustomScaleButton(
                onPressed: () {},
                label: Text(
                  S.of(context).save,
                  style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                ),
                style: OutlinedButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  foregroundColor: ChatifyColors.mildNight.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
