import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/reset_notification_settings_dialog.dart';
import '../../widgets/dialogs/vibration_dialog.dart';
import '../../widgets/items/settings_item.dart';
import '../../widgets/items/settings_switch_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final storage = GetStorage();
  bool isSoundEnabled = false;
  bool isRemindersEnabled = false;
  bool isPriorityMessageEnabled = false;
  bool isPriorityGroupEnabled = false;
  bool isReactionsMessagesEnabled = false;
  bool isReactionsGroupEnabled = false;
  bool isReactionsEnabled = false;
  String? vibrationOption;

  @override
  void initState() {
    super.initState();
    isSoundEnabled = storage.read('isSoundEnabled') ?? false;
    isRemindersEnabled = storage.read('isRemindersEnabled') ?? false;
    isPriorityMessageEnabled = storage.read('isPriorityMessageEnabled') ?? false;
    isPriorityGroupEnabled = storage.read('isPriorityGroupEnabled') ?? false;
    isReactionsMessagesEnabled = storage.read('isReactionsMessagesEnabled') ?? false;
    isReactionsGroupEnabled = storage.read('isReactionsGroupEnabled') ?? false;
    isReactionsEnabled = storage.read('isReactions') ?? false;
    vibrationOption = storage.read('vibrationOption') ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vibrationOption ??= S.of(context).system;
  }

  void _saveState(String key, bool value) {
    storage.write(key, value);
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
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TooltipTheme(
                data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
                child: Theme(
                  data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                  child: PopupMenuButton<int>(
                    tooltip: S.of(context).more,
                    position: PopupMenuPosition.under,
                    offset: const Offset(-8, 0),
                    menuPadding: EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints(minWidth: 0, maxWidth: 320),
                    icon: const Icon(Icons.more_vert),
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                        }
                        return ChatifyColors.transparent;
                      }),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppPopupMenuItem(
                          text: S.of(context).resetNotifySettings,
                          onTap: () {
                            Navigator.pop(context);
                            showResetNotificationSettingsDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                      SettingsSwitchItem(
                        label: S.of(context).soundsInChat,
                        description: S.of(context).playSoundsIncomingOutgoing,
                        value: isSoundEnabled,
                        onChanged: (value) {
                          setState(() {
                            isSoundEnabled = value;
                          });

                          _saveState('isSoundEnabled', value);
                        },
                      ),
                      SizedBox(height: 12),
                      SettingsSwitchItem(
                        label: S.of(context).reminders,
                        description: S.of(context).periodicRemindersStatusUpdates,
                        value: isRemindersEnabled,
                        onChanged: (value) {
                          setState(() {
                            isRemindersEnabled = value;
                          });

                          _saveState('isRemindersEnabled', value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0),
                  _buildSectionHeader(S.of(context).messages, padding: const EdgeInsets.only(left: 20, right: 10, top: 20)),
                  const SizedBox(height: 8),
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
                  SettingsItem(title: S.of(context).popPopNotify, subtitle: S.of(context).notAvailable, onTap: () {}),
                  SettingsItem(title: S.of(context).lightNotify, subtitle: S.of(context).whiteNotify, onTap: () => showLightDialog(context)),
                  SettingsSwitchItem(
                    label: S.of(context).priorityNotifications,
                    description: S.of(context).showPopUpNotify,
                    value: isPriorityMessageEnabled,
                    onChanged: (value) {
                      setState(() {
                        isPriorityMessageEnabled = value;
                      });
                      _saveState('isPriorityMessageEnabled', value);
                    },
                  ),
                  SettingsSwitchItem(
                    label: S.of(context).reactionNotify,
                    description: S.of(context).showNotifyReactionsMessagesSend,
                    value: isReactionsMessagesEnabled,
                    onChanged: (value) {
                      setState(() {
                        isReactionsMessagesEnabled = value;
                      });
                      _saveState('isReactionsMessagesEnabled', value);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0, thickness: 1),
                  _buildSectionHeader('${S.of(context).groups[0].toUpperCase()}${S.of(context).groups.substring(1)}', padding: const EdgeInsets.only(left: 20, right: 10, top: 12)),
                  const SizedBox(height: 8),
                  SettingsItem(title: S.of(context).notificationSound, subtitle: S.of(context).defaultBongo),
                  SettingsItem(title: S.of(context).vibration, subtitle: S.of(context).system, onTap: () {}),
                  SettingsItem(title: S.of(context).lightNotify, subtitle: S.of(context).whiteNotify),
                  SettingsSwitchItem(
                    label: S.of(context).priorityNotifications,
                    description: S.of(context).showPopUpNotificationsScreen,
                    value: isPriorityGroupEnabled,
                    onChanged: (value) {
                      setState(() {
                        isPriorityGroupEnabled = value;
                      });
                      _saveState('isPriorityGroupEnabled', value);
                    },
                  ),
                  SettingsSwitchItem(
                    label: S.of(context).reactionNotify,
                    description: S.of(context).showNotifyAboutReactionsSend,
                    value: isReactionsGroupEnabled,
                    onChanged: (value) {
                      setState(() {
                        isReactionsGroupEnabled = value;
                      });
                      _saveState('isReactionsGroupEnabled', value);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0, thickness: 1),
                  _buildSectionHeader(S.of(context).calls, padding: const EdgeInsets.only(left: 20, right: 10, top: 20)),
                  const SizedBox(height: 8),
                  SettingsItem(title: S.of(context).melody, subtitle: S.of(context).defaultNotify),
                  const SizedBox(height: 8),
                  SettingsItem(title: S.of(context).vibration, subtitle: S.of(context).system),
                  const SizedBox(height: 8),
                  const Divider(height: 0, thickness: 1),
                  _buildSectionHeader(S.of(context).status, padding: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 10)),
                  SettingsSwitchItem(
                    label: S.of(context).reactions,
                    description: S.of(context).showNotifyStatusLiked,
                    value: isReactionsEnabled,
                    onChanged: (value) {
                      setState(() {
                        isReactionsEnabled = value;
                      });
                      _saveState('isReactions', value);
                    },
                  ),
                  const SizedBox(height: 12),
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
