import 'package:chatify/features/personalization/screens/privacy/privacy_blocked_app_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/privacy_calls_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/privacy_check_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/privacy_extended_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/privacy_groups_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/privacy_photo_profile_screen.dart';
import 'package:chatify/features/personalization/screens/privacy/status_privacy_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'automatic_timer_screen.dart';
import 'blocked_users_screen.dart';
import 'closing_chat_screen.dart';
import 'geolocation_screen.dart';
import 'intelligence_screen.dart';
import 'last_visited_time_screen.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => PrivacyScreenState();
}

class PrivacyScreenState extends State<PrivacyScreen> {
  bool isReadingReportsEnabled = false;
  bool isEffectCameraEnabled = false;
  bool isLoading = false;
  String privacySubtitleOption = '';
  String selectedPrivacyOption = '';
  String selectedIntelligenceOption = '';
  String selectedTimerOption = '';
  String selectedGroupsOption = '';
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
    privacySubtitleOption = storage.read('selected_last_visit_option_label') ?? 'Мои контакты, Все';
    selectedPrivacyOption = storage.read('selected_photo_privacy_label') ?? 'Мои контакты';
    selectedIntelligenceOption = storage.read('selected_intelligence_privacy_label') ?? 'Мои контакты';
    selectedTimerOption = storage.read('selected_automatic_timer_label') ?? 'Выкл.';
    selectedGroupsOption = storage.read('selected_groups_privacy_label') ?? 'Мои контакты';
  }

  Future<void> _loadSwitchState() async {
    final readingReportsValue = storage.read('isReadingReportsEnabled');
    final effectCameraValue = storage.read('isEffectCameraEnabled');

    setState(() {
      isReadingReportsEnabled = readingReportsValue ?? false;
      isEffectCameraEnabled = effectCameraValue ?? false;
    });
  }

  void _toggleSwitch(bool value) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isReadingReportsEnabled = value;
      isLoading = false;
    });

    storage.write('isReadingReportsEnabled', value);
  }

  void _toggleEffectCamera(bool value) async {
    setState(() {
      isEffectCameraEnabled = value;
    });

    storage.write('isEffectCameraEnabled', value);
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
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(S.of(context).privacy, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal)),
            titleSpacing: 0,
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
                      _buildSectionHeader('Видимость персональных даннных', padding: const EdgeInsets.only(left: 25, right: 20, top: 25)),
                      const SizedBox(height: 10),
                      _buildPrivacyItem('Время последнего посещения и статус "в сети"', privacySubtitleOption,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            createPageRoute(const LastVisitedTimeScreen()),
                          );
                          if (result != null && mounted) {
                            setState(() {
                              privacySubtitleOption = result;
                              storage.write('selected_last_visit_option_label', result);
                            });
                          }
                        },
                      ),
                      _buildPrivacyItem('Фото профиля', selectedPrivacyOption,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            createPageRoute(const PrivacyPhotoProfileScreen()),
                          );
                          if (result != null && result is String) {
                            setState(() {
                              selectedPrivacyOption = result;
                              storage.write('selected_photo_privacy_label', result);
                            });
                          }
                        },
                      ),
                      _buildPrivacyItem('Сведения', selectedIntelligenceOption,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            createPageRoute(const IntelligenceScreen()),
                          );
                          if (result != null && result is String) {
                            setState(() {
                              selectedIntelligenceOption = result;
                              storage.write('selected_intelligence_privacy_label', result);
                            });
                          }
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, createPageRoute(const StatusPrivacyScreen()));
                        },
                        splashColor: context.isDarkMode ? ChatifyColors.darkSlate.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkSlate.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                          child: Text('Статус', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _toggleSwitch(!isReadingReportsEnabled);
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
                                    Text(
                                      'Отчёты о прочтении',
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                                    ),
                                    Text(
                                      'Если вы отключите отчёты \n'
                                      'о прочтении, то не сможете \n'
                                      'отправлять и получать эти отчёты. \n'
                                      'Данные уведомления нельзя \n'
                                      'отключить для групповых чатов.',
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: isLoading ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    strokeWidth: 3,
                                  ),
                                )
                                    : Switch(
                                  value: isReadingReportsEnabled,
                                  onChanged: (value) {
                                    _toggleSwitch(value);
                                  },
                                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 0, thickness: 1),
                      _buildSectionHeader('Исчезающие сообщения', padding: const EdgeInsets.only(left: 25, right: 25, top: 20)),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            createPageRoute(const AutomaticTimerScreen()),
                          );
                          if (result != null && result is String) {
                            setState(() {
                              selectedTimerOption = result;
                              storage.write('selected_automatic_timer_label', result);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 25, right: 20, top: 16, bottom: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Автоматический таймер сообщений',
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd), maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Начинайте новые чаты \n'
                                      'с сообщениями, которые будут \n'
                                      'исчезать в соответствии с заданным \n'
                                      'таймером.',
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                                    ),
                                  ),
                                  Text(selectedTimerOption, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 0, thickness: 1),
                      _buildPrivacyItem('Группы', selectedGroupsOption,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            createPageRoute(const PrivacyGroupsScreen()),
                          );
                          if (result != null && result is String) {
                            setState(() {
                              selectedGroupsOption = result;
                              storage.write('selected_groups_privacy_label', result);
                            });
                          }
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, createPageRoute(const GeolocationScreen()));
                        },
                        splashColor: context.isDarkMode ? ChatifyColors.darkSlate.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkSlate.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                          child: Text('Геоданные', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                      ),
                      _buildPrivacyItem('Звонки', 'Отключить звук для неизвестных номеров',
                        onTap: () {
                          Navigator.push(
                            context,
                            createPageRoute(const PrivacyCallsScreen()),
                          );
                        },
                      ),
                      _buildPrivacyItem('Заблокированные', '2', onTap: () {
                        Navigator.push(
                          context,
                          createPageRoute(BlockedUsersScreen(user: APIs.me, blockedUser: const [])),
                        );
                      }),
                      _buildPrivacyItem('Блокировка приложения', 'Отключено', onTap: () {
                        Navigator.push(
                          context,
                          createPageRoute(const PrivacyBlockedAppScreen()),
                        );
                      }),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            createPageRoute(const ClosingChatScreen()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                          child: Text(
                            'Закрытие чата',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _toggleEffectCamera(!isEffectCameraEnabled);
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
                                    Text('Разрешить эффекты камеры', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                          'Используйте эффекты во время \n'
                                          'съемки и видеозвонков. ',
                                        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                                        children: [
                                          TextSpan(
                                            text: 'Подробнее',
                                            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                            recognizer: TapGestureRecognizer()..onTap = () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Switch(
                                  value: isEffectCameraEnabled,
                                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
                                  onChanged: (value) {
                                    _toggleEffectCamera(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildPrivacyItem('Расширенные', 'Защитить IP-адрес во время звонков, отключить предпросмотр ссылок',
                        onTap: () {
                          Navigator.push(
                            context,
                            createPageRoute(const PrivacyExtendedScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
                      const SizedBox(height: 5),
                      _buildPrivacyItem('Проверка конфиденциальности', 'Управляйте конфиденциальностью и выбирайте необходимые для себя настройки.',
                        onTap: () {
                          Navigator.push(
                            context,
                            createPageRoute(const PrivacyCheckScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
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
      child: Text(
        title,
        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
      ),
    );
  }

  Widget _buildPrivacyItem(String title, String subtitle, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      splashColor: context.isDarkMode ? ChatifyColors.darkSlate.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkSlate.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 25, right: 40, top: 16, bottom: 16),
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
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
