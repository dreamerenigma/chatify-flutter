import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/vibration_dialog.dart';
import '../../widgets/items/settings_item.dart';
import '../../widgets/items/settings_switch_item.dart';
import '../account/account_screen.dart';

class UserNotificationsScreen extends StatefulWidget {
  const UserNotificationsScreen({super.key});

  @override
  State<UserNotificationsScreen> createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  final storage = GetStorage();
  bool isMessageNotificationsDisable = false;
  bool isStatusNotificationsDisable = false;
  String? vibrationOption;

  @override
  void initState() {
    super.initState();
    isMessageNotificationsDisable = storage.read('isNotificationsDisable') ?? false;
    isStatusNotificationsDisable = storage.read('isStatusNotificationsDisable') ?? false;
    vibrationOption = storage.read('vibrationOption') ?? '';
  }

  void _saveState(String key, bool value) {
    storage.write(key, value);
  }

  void _setMessageNotificationsDisable(bool value) {
    setState(() {
      isMessageNotificationsDisable = value;
    });

    _saveState('isMessageNotificationsDisable', value);
  }

  void _setStatusNotificationsDisable(bool value) {
    setState(() {
      isStatusNotificationsDisable = value;
    });

    _saveState('isStatusNotificationsDisable', value);
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
            title: Text(S.of(context).notifications, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 5,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      _buildSectionHeader(S.of(context).message, padding: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 15)),
                      SettingsSwitchItem(
                        label: 'Выключить уведомления',
                        value: isMessageNotificationsDisable,
                        onChanged: _setMessageNotificationsDisable,
                      ),
                      SizedBox(height: 4),
                      SettingsItem(title: S.of(context).notificationSound, subtitle: S.of(context).defaultBongo, onTap: () {}),
                      SettingsItem(
                        title: S.of(context).vibration,
                        subtitle: vibrationOption ?? S.of(context).system,
                        onTap: () {
                          showVibrationDialog(context, (selectedText) {
                            setState(() {
                              vibrationOption = selectedText;
                              storage.write('vibrationOption', vibrationOption);
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, bottom: 0),
                  SettingsItem(
                    title: 'Расширенные настройки',
                    onTap: () {
                      Navigator.push(context, createPageRoute(AccountScreen(user: APIs.me)));
                    },
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                  CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0),
                  _buildSectionHeader('Звонок', padding: const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 10)),
                  SettingsItem(
                    title: 'Рингтон',
                    subtitle: 'По умолчанию (Huawei Tune Living)',
                    onTap: () {
                      showVibrationDialog(context, (selectedText) {
                        setState(() {
                          vibrationOption = selectedText;
                          storage.write('vibrationOption', vibrationOption);
                        });
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  SettingsItem(
                    title: S.of(context).vibration,
                    subtitle: vibrationOption ?? S.of(context).system,
                    onTap: () {
                      showVibrationDialog(context, (selectedText) {
                        setState(() {
                          vibrationOption = selectedText;
                          storage.write('vibrationOption', vibrationOption);
                        });
                      });
                    },
                  ),
                  CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 6),
                  _buildSectionHeader('Статус', padding: const EdgeInsets.only(left: 20, right: 10, top: 15)),
                  SettingsSwitchItem(
                    label: 'Выключить уведомления',
                    value: isStatusNotificationsDisable,
                    onChanged: _setStatusNotificationsDisable,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {EdgeInsetsGeometry padding = EdgeInsets.zero}) {
    return Padding(
      padding: padding,
      child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
    );
  }
}
