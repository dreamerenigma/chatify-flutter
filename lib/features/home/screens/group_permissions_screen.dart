import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class GroupPermissionsScreen extends StatefulWidget {
  const GroupPermissionsScreen({super.key});

  @override
  State<GroupPermissionsScreen> createState() => _GroupPermissionsScreenState();
}

class _GroupPermissionsScreenState extends State<GroupPermissionsScreen> {
  final box = GetStorage();
  bool isEditSettingsGroup = false;
  bool isSendMessages = false;
  bool isAddOtherParticipant = false;
  bool isVerifyNewParticipant = false;

  @override
  void initState() {
    super.initState();
    isEditSettingsGroup = box.read('isEditSettingsGroup') ?? false;
    isSendMessages = box.read('isSendMessages') ?? false;
    isAddOtherParticipant = box.read('isAddOtherParticipant') ?? false;
    isVerifyNewParticipant = box.read('isVerifyNewParticipant') ?? false;
  }

  void _saveSwitchState(String key, bool value) {
    box.write(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.isDarkMode ? ChatifyColors.white.withAlpha((0.1 * 255).toInt()) : ChatifyColors.black.withAlpha((0.1* 255).toInt());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 0,
                blurRadius: 0.5,
                offset: const Offset(0, 0.5),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(S.of(context).groupPermissions, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
            titleSpacing: 0,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 12, top: 12),
            child: Text(S.of(context).participantsCan, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
            )),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              setState(() {
                isEditSettingsGroup = !isEditSettingsGroup;
                _saveSwitchState('isEditSettingsGroup', isEditSettingsGroup);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(EvilIcons.pencil, color: ChatifyColors.darkGrey),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).changeSettings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                          Text(S.of(context).groups, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Switch(
                      value: isEditSettingsGroup,
                      onChanged: (bool value) {
                        setState(() {
                          isEditSettingsGroup = value;
                          _saveSwitchState('isEditSettingsGroup', value);
                        });
                      },
                      activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                    ),
                  ],
                ),
                subtitle: Text(
                  S.of(context).groupIncludes,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isSendMessages = !isSendMessages;
                _saveSwitchState('isSendMessages', isSendMessages);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.message, color: ChatifyColors.darkGrey),
                title: Text(S.of(context).sendMessages, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                trailing: Switch(
                  value: isSendMessages,
                  onChanged: (bool value) {
                    setState(() {
                      isSendMessages = value;
                      _saveSwitchState('isSendMessages', value);
                    });
                  },
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isAddOtherParticipant = !isAddOtherParticipant;
                _saveSwitchState('isAddOtherParticipant', isAddOtherParticipant);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_add_alt_outlined, color: ChatifyColors.darkGrey),
                title: Text(S.of(context).addOtherParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                trailing: Switch(
                  value: isAddOtherParticipant,
                  onChanged: (bool value) {
                    setState(() {
                      isAddOtherParticipant = value;
                      _saveSwitchState('isAddOtherParticipant', value);
                    });
                  },
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Text(S.of(context).adminsCan, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
            )),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              setState(() {
                isVerifyNewParticipant = !isVerifyNewParticipant;
                _saveSwitchState('isVerifyNewParticipant', isVerifyNewParticipant);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(BootstrapIcons.person_fill_lock, color: ChatifyColors.darkGrey),
                title: Text(S.of(context).confirmNewMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                trailing: Switch(
                  value: isVerifyNewParticipant,
                  onChanged: (bool value) {
                    setState(() {
                      isVerifyNewParticipant = value;
                      _saveSwitchState('isVerifyNewParticipant', value);
                    });
                  },
                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, height: 1.5),
                    children: [
                      TextSpan(
                        text: S.of(context).enabledAdminsJoinGroup,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                      ),
                      TextSpan(text: S.of(context).readMore, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), decoration: TextDecoration.none),
                        recognizer: TapGestureRecognizer()..onTap = () {
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
