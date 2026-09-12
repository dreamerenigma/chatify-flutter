import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../core/enums/new_group_dialog_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../authentication/widgets/buttons/custom_radio_button.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

Future<String?> showNewGroupBottomSheetDialog(BuildContext context, {required NewGroupDialogType type, required String selectedOption}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    barrierColor: ChatifyColors.transparent,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (_) {
      return NewGroupBottomSheet(type: type, selectedOption: selectedOption);
    },
  );
}

class NewGroupBottomSheet extends StatefulWidget {
  final NewGroupDialogType type;
  final String selectedOption;

  const NewGroupBottomSheet({
    super.key,
    required this.type,
    required this.selectedOption,
  });

  @override
  State<NewGroupBottomSheet> createState() => _NewGroupBottomSheetState();
}

class _NewGroupBottomSheetState extends State<NewGroupBottomSheet> {
  late String _selectedNewGroupOption;

  bool get isWhoCanAddMembers => widget.type == NewGroupDialogType.whoCanAddMembers;

  @override
  void initState() {
    super.initState();
    _selectedNewGroupOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.lightSoftNight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(isWhoCanAddMembers ? S.of(context).whoCanAddNewMembers : S.of(context).whoCanAddToNewGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w600, height: 1.3), textAlign: TextAlign.center),
            ),
          ),
          if (!isWhoCanAddMembers)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(text: S.of(context).membersCanAlwaysProposeGroups),
                      TextSpan(
                        text: S.of(context).readMore,
                        style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          UrlUtils.launchURL(AppLinks.helpCenter);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (isWhoCanAddMembers) ...[
            _buildRadioOption(
              context,
              title: S.of(context).all,
              description: S.of(context).allCommunityMembersAddGroups,
            ),
            _buildRadioOption(
              context,
              title: S.of(context).communityAdminsOnly,
              description: S.of(context).onlyCommunityAdminsAddGroups,
            ),
          ] else ...[
            SizedBox(height: 6),
            _buildRadioOption(
              context,
              title: S.of(context).all,
              description: S.of(context).allCommunityMembersAddGroups,
            ),
            _buildRadioOption(
              context,
              title: S.of(context).communityAdminsOnly,
              description: S.of(context).onlyCommunityAdminsAddGroups,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRadioOption(BuildContext context, {required String title, required String description}) {
    return CustomRadioButton(
      value: title,
      imagePath: '',
      title: title,
      subtitle: description,
      groupValue: _selectedNewGroupOption,
      showVerticalMargin: false,
      onChanged: (String? value) {
        if (value == null) return;

        Navigator.pop(context, value);
      },
    );
  }
}
