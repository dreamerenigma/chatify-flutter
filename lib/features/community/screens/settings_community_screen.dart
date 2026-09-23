import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/enums/new_group_dialog_type.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/dialogs/new_groups_bottom_sheet_dialog.dart';

class SettingsCommunityScreen extends StatefulWidget {
  const SettingsCommunityScreen({super.key});

  @override
  SettingsCommunityScreenState createState() => SettingsCommunityScreenState();
}

class SettingsCommunityScreenState extends State<SettingsCommunityScreen> {
  late String _selectedNewUserOption;
  late String _selectedNewGroupOption;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedNewUserOption = S.of(context).onlyAdmins;
    _selectedNewGroupOption = S.of(context).all;
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
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(S.of(context).communitySettings, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
            iconTheme: IconThemeData(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          ),
        ),
      ),
      body: _permissionsCommunity(context),
    );
  }

  Widget _permissionsCommunity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(S.of(context).communityPermissions, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
        ),
        const SizedBox(height: 10),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
            onTap: () async {
              final result = await showNewGroupBottomSheetDialog(context, type: NewGroupDialogType.whoCanAddMembers, selectedOption: _selectedNewUserOption);

              if (result != null) {
                setState(() {
                  _selectedNewUserOption = result;
                });
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).whoCanAddNewMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 4),
                    Text(_selectedNewUserOption, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
            onTap: () async {
              final result = await showNewGroupBottomSheetDialog(context, type: NewGroupDialogType.whoCanAddGroups, selectedOption: _selectedNewGroupOption);

              if (result != null) {
                setState(() {
                  _selectedNewGroupOption = result;
                });
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).whoCanAddToNewGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 4),
                    Text(_selectedNewGroupOption, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
