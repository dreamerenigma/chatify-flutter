import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_links.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/urls/url_utils.dart';

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
            boxShadow: [
              BoxShadow(
                color: context.isDarkMode ? ChatifyColors.white.withAlpha((0.1 * 255).toInt()) : ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 0,
                blurRadius: 0.5,
                offset: const Offset(0, 0.5),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            title: Text(S.of(context).communitySettings, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
            elevation: 1,
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
          child: Text(S.of(context).communityPermissions, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            _showBottomSheetDialogNewUser(context);
          },
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).whoCanAddNewMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  const SizedBox(height: 4),
                  Text(_selectedNewUserOption, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            _showBottomSheetDialogNewGroups(context);
          },
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).whoCanAddToNewGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  const SizedBox(height: 4),
                  Text(_selectedNewGroupOption, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheetDialogNewUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16.0),
                  child: Text(S.of(context).whoCanAddNewMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              ),
              _buildRadioOption(
                context,
                title: S.of(context).all,
                description: S.of(context).allCommunityMembersAddOtherMembers,
                groupValue: _selectedNewUserOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewUserOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildRadioOption(
                context,
                title: S.of(context).onlyAdmins,
                description: S.of(context).onlyAdminsGroupAndCommunitiesOtherMembers,
                groupValue: _selectedNewUserOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewUserOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheetDialogNewGroups(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Text(
                    S.of(context).addNewGroups,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                      children: [
                        TextSpan(text: S.of(context).membersCanAlwaysProposeGroups),
                        TextSpan(
                          text: S.of(context).more,
                          style: const TextStyle(color: ChatifyColors.blue, decoration: TextDecoration.none),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            UrlUtils.launchURL(AppLinks.helpCenter);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildRadioOption(
                context,
                title: S.of(context).all,
                description: S.of(context).allCommunityMembersAddGroups,
                groupValue: _selectedNewGroupOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewGroupOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildRadioOption(
                context,
                title: S.of(context).communityAdminsOnly,
                description: S.of(context).onlyCommunityAdminsAddGroups,
                groupValue: _selectedNewGroupOption,
                onChanged: (value) {
                  setState(() {
                    _selectedNewGroupOption = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioOption(
    BuildContext context, {
      required String title,
      required String description,
      required String groupValue,
      required ValueChanged<String?> onChanged,
    }) {
    return InkWell(
      onTap: () {
        onChanged(title);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<String>(
            value: title,
            groupValue: groupValue,
            activeColor: ChatifyColors.blue,
            onChanged: onChanged,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                Text(description, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
