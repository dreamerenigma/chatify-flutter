import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/tiles/custom_list_tile.dart';

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
  bool isInviteLinkQR = false;
  bool isVerifyNewParticipant = false;

  @override
  void initState() {
    super.initState();
    isEditSettingsGroup = box.read('isEditSettingsGroup') ?? false;
    isSendMessages = box.read('isSendMessages') ?? false;
    isAddOtherParticipant = box.read('isAddOtherParticipant') ?? false;
    isInviteLinkQR = box.read('isInviteLinkQR') ?? false;
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
          decoration: BoxDecoration(color: ChatifyColors.white, boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 0, blurRadius: 0.5, offset: const Offset(0, 0.5))]),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            title: Text(S.of(context).groupPermissions, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
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
            padding: const EdgeInsets.only(left: 16, right: 12, top: 12),
            child: Text(S.of(context).participantsCan, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 5),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  isEditSettingsGroup = !isEditSettingsGroup;
                  _saveSwitchState('isEditSettingsGroup', isEditSettingsGroup);
                });
              },
              child: CustomListTile(
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(ChatifyVectors.editPencil, width: 26, height: 26, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(S.of(context).changeSettingsGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                    CustomSwitch(
                      value: isEditSettingsGroup,
                      onChanged: (bool value) {
                        setState(() {
                          isEditSettingsGroup = value;
                          _saveSwitchState('isEditSettingsGroup', value);
                        });
                      },
                      switchWidth: 55,
                      switchHeight: 33,
                      thumbSize: 25,
                      thumbPadding: 3,
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Text(S.of(context).groupIncludes, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
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
                  leading: SvgPicture.asset(ChatifyVectors.messageOutline, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text('Отправлять новые сообщения', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ),
                  trailing: CustomSwitch(
                    value: isSendMessages,
                    onChanged: (bool value) {
                      setState(() {
                        isSendMessages = value;
                        _saveSwitchState('isSendMessages', value);
                      });
                    },
                    switchWidth: 55,
                    switchHeight: 33,
                    thumbSize: 25,
                    thumbPadding: 3,
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
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
                  title: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(S.of(context).addOtherParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ),
                  trailing: CustomSwitch(
                    value: isAddOtherParticipant,
                    onChanged: (bool value) {
                      setState(() {
                        isAddOtherParticipant = value;
                        _saveSwitchState('isAddOtherParticipant', value);
                      });
                    },
                    switchWidth: 55,
                    switchHeight: 33,
                    thumbSize: 25,
                    thumbPadding: 3,
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                setState(() {
                  isInviteLinkQR = !isInviteLinkQR;
                  _saveSwitchState('isInviteLinkQR', isInviteLinkQR);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.link, color: ChatifyColors.darkGrey),
                  title: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text('Приглашать по ссылке или QR-коду', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ),
                  trailing: CustomSwitch(
                    value: isInviteLinkQR,
                    onChanged: (bool value) {
                      setState(() {
                        isInviteLinkQR = value;
                        _saveSwitchState('isInviteLinkQR', value);
                      });
                    },
                    switchWidth: 55,
                    switchHeight: 33,
                    thumbSize: 25,
                    thumbPadding: 3,
                  ),
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
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
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
                  leading: SvgPicture.asset(ChatifyVectors.personTime, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: Text(S.of(context).confirmNewMembers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  trailing: CustomSwitch(
                    value: isVerifyNewParticipant,
                    onChanged: (bool value) {
                      setState(() {
                        isVerifyNewParticipant = value;
                        _saveSwitchState('isVerifyNewParticipant', value);
                      });
                    },
                    switchWidth: 55,
                    switchHeight: 33,
                    thumbSize: 25,
                    thumbPadding: 3,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
                        children: [
                          TextSpan(
                            text: S.of(context).enabledAdminsJoinGroup,
                            style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontWeight: FontWeight.w400),
                          ),
                          TextSpan(text: S.of(context).readMore, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
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
