import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/reset_notification_settings_dialog.dart';
import '../../widgets/dialogs/vibration_dialog.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isSoundEnabled = false;
  bool isRemindersEnabled = false;
  bool isPriorityMessageEnabled = false;
  bool isPriorityGroupEnabled = false;
  bool isReactionsMessagesEnabled = false;
  bool isReactionsGroupEnabled = false;
  bool isReactionsEnabled = false;
  final storage = GetStorage();
  String vibrationOption = 'По умолчанию';

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
    vibrationOption = storage.read('vibrationOption') ?? 'По умолчанию';
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
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
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
              PopupMenuButton<int>(
                position: PopupMenuPosition.under,
                color: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.white,
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 1) {
                    showResetNotificationSettingsDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Сбросить настройки уведомлений',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
              if (states.contains(WidgetState.dragged)) {
                return ChatifyColors.darkerGrey;
              }
              return ChatifyColors.darkerGrey;
            }),
          ),
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
                      _buildSwitchWithLabel(
                        'Звуки в чате',
                        'Воспроизводить звуки для \nвходящих и исходящих \n'
                        'сообщений',
                        isSoundEnabled,
                            (value) {
                          setState(() {
                            isSoundEnabled = value;
                          });
                          _saveState('isSoundEnabled', value);
                        },
                      ),
                      _buildSwitchWithLabel(
                        'Напоминания',
                        'Получайте периодические \nнапоминания об обновлениях \nстатуса, которых вы не видели',
                        isRemindersEnabled,
                            (value) {
                          setState(() {
                            isRemindersEnabled = value;
                          });
                          _saveState('isRemindersEnabled', value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  _buildSectionHeader('Сообщения', padding: const EdgeInsets.only(left: 20, right: 10, top: 12)),
                  const SizedBox(height: 8),
                  _buildSettingsItem('Звук уведомления', 'По умолчанию (Bongo)', onTap: () {

                  }),
                  _buildSettingsItem('Вибрация', vibrationOption,
                    onTap: () {
                      showVibrationDialog(context, (selectedText) {
                        setState(() {
                          vibrationOption = selectedText;
                          storage.write('vibrationOption', vibrationOption);
                        });
                      });
                    },
                  ),
                  _buildSettingsItem('Всплывающее уведомление', 'Недоступно', onTap: () {

                  }),
                  _buildSettingsItem('Свет', 'Белый', onTap: () {
                    showLightDialog(context);
                  }),
                  _buildNotificationItem(
                    title: 'Приоритетные уведомления',
                    description: 'Показывать всплывающие \nуведомления в верхней части \nэкрана',
                    value: isPriorityMessageEnabled,
                    onChanged: (value) {
                      setState(() {
                        isPriorityMessageEnabled = value;
                      });
                      _saveState('isPriorityMessageEnabled', value);
                    },
                  ),
                  _buildNotificationItem(
                    title: 'Уведомления о реакциях',
                    description:
                      'Показывать уведомления \n'
                      'о реакциях на отправленные вами \n'
                      'сообщения',
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
                  _buildSectionHeader('Группы', padding: const EdgeInsets.only(left: 20, right: 10, top: 12)),
                  const SizedBox(height: 8),
                  _buildSettingsItem('Звук уведомления', 'По умолчанию (Bongo)'),
                  _buildSettingsItem('Вибрация', 'По умолчанию', onTap: () {

                  }),
                  _buildSettingsItem('Свет', 'Белый'),
                  _buildNotificationItem(
                    title: 'Приоритетные уведомления',
                    description: 'Показывать всплывающие \nуведомления в верхней части \nэкрана',
                    value: isPriorityGroupEnabled,
                    onChanged: (value) {
                      setState(() {
                        isPriorityGroupEnabled = value;
                      });
                      _saveState('isPriorityGroupEnabled', value);
                    },
                  ),
                  _buildNotificationItem(
                    title: 'Уведомления о реакциях',
                    description:
                      'Показывать уведомления \n'
                      'о реакциях на отправленные вами \n'
                      'сообщения',
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
                  _buildSectionHeader('Звонки', padding: const EdgeInsets.only(left: 20, right: 10, top: 20)),
                  const SizedBox(height: 8),
                  _buildSettingsItem(
                    'Мелодия',
                    'По умолчанию (Huawei Tune Living)',
                  ),
                  const SizedBox(height: 8),
                  _buildSettingsItem(
                    'Вибрация',
                    'По умолчанию',
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0, thickness: 1),
                  _buildSectionHeader('Статус', padding: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 10)),
                  _buildNotificationItem(
                    title: 'Реакции',
                    description:
                      'Показывать уведомления при\n'
                      'отметках "нравиться" к статусу',
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

  Widget _buildSwitchWithLabel(String label, String description, bool value, ValueChanged<bool> onChanged) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 16, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, String subtitle, {void Function()? onTap}) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {EdgeInsetsGeometry padding = EdgeInsets.zero}) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
      ),
    );
  }

  Widget _buildNotificationItem({required String title, required String description, required bool value, required ValueChanged<bool> onChanged}) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          onChanged(!value);
          _saveState(title, !value);
        },
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 12, bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: (newValue) {
                  onChanged(newValue);
                  _saveState(title, newValue);
                },
                activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
