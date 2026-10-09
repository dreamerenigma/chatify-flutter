import 'package:chatify/features/personalization/screens/privacy/blocked_users_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_storage/get_storage.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';

class ContactsScreen extends StatefulWidget {
  final UserModel user;

  const ContactsScreen({
    super.key,
    required this.user,
  });

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final storage = GetStorage();
  bool isContactsAppEnabled = false;

  void _toggleEffectCamera(bool value) async {
    setState(() {
      isContactsAppEnabled = value;
    });

    storage.write('isEffectCameraEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(S.of(context).contacts, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        backgroundColor: ChatifyColors.blackGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BlockedUsersScreen(blockedUser: const [], user: widget.user)));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Заблокированные аккаунты',
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    ),
                    Text('Нет', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
          ),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
              onTap: () {
                _toggleEffectCamera(!isContactsAppEnabled);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 25, right: 20, top: 16, bottom: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Контакы Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: RichText(
                              text: TextSpan(
                                text: 'Контакты сохраняются в вашем аккаунте Chatify для управления имя на других устройствах. ',
                                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
                                children: [
                                  TextSpan(
                                    text: S.of(context).readMore,
                                    style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold, height: 1.5),
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: CustomSwitch(
                        value: isContactsAppEnabled,
                        onChanged: (value) {
                          _toggleEffectCamera(value);
                        },
                        switchWidth: 55,
                        switchHeight: 33,
                        thumbSize: 25,
                        thumbPadding: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
