import 'package:chatify/features/personalization/screens/help/help_center_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class NotificationsSecurityScreen extends StatefulWidget {
  const NotificationsSecurityScreen({super.key});

  @override
  State<NotificationsSecurityScreen> createState() => _NotificationsSecurityScreenState();
}

class _NotificationsSecurityScreenState extends State<NotificationsSecurityScreen> {
  bool isNotifySecurityEnabled = false;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    isNotifySecurityEnabled = storage.read('notifySecurity') ?? false;
  }

  void toggleSwitch(bool value) {
    setState(() {
      isNotifySecurityEnabled = value;
    });
    storage.write('notifySecurity', value);
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
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
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            title: Text('Уведомления безопасности', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.dragged)) {
                  return ChatifyColors.darkerGrey;
                }
                return ChatifyColors.darkerGrey;
              },
            ),
          ),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: SvgPicture.asset(
                      colorsController.getImagePath(),
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text('Ваши чаты и звонки конфиденциальны',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Благодаря сквозному шифрованию ваши личные сообщения остаются только между вами и людьми, с которыми вы общаетесь. Даже Chatify не может получить к ним доступ. К ним относятся:',
                      style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icon(Icons.message, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)), 'Текстовые и голосовые сообщения'),
                  _buildInfoRow(Icon(Icons.call, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)), 'Аудио- и видеозвонки'),
                  _buildInfoRow(Icon(Icons.attach_file, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)), 'Фото, видео и документы'),
                  _buildInfoRow(Icon(Icons.location_on, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)), 'Ваше местоположение'),
                  _buildInfoRow(SvgPicture.asset(ChatifyVectors.status), 'Обновление статуса'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(ChatifyVectors.status, width: 22, height: 22, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        const SizedBox(width: 16),
                        Text('Обновления статуса', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _launchURL('https://chatify.inputstudios.ru/security'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Подробнее',
                        style: TextStyle(fontSize: 14, color: colorsController.getColor(colorsController.selectedColorScheme.value), decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        toggleSwitch(!isNotifySecurityEnabled);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 10, top: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Показывать уведомления \n безопасности на этом \n устройстве', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Switch(
                                value: isNotifySecurityEnabled,
                                onChanged: toggleSwitch,
                                activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, height: 1.5),
                              children: [
                                const TextSpan(
                                  text: 'Получайте уведомления в случае \n изменений кода безопасности \n на вашем телефоне и телефоне \n контакта в чате со сквозным \n шифрованием. Если у вас несколько \n устройств, этот параметр необходимо \n включить отдельно на каждом \n устройстве, на котором вы хотите \n получать уведомления. ',
                                ),
                                TextSpan(
                                  text: 'Подробнее',
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value), decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Navigator.push(context, createPageRoute(const HelpCenterScreen()));
                                  },
                                ),
                              ],
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
        ),
      ),
    );
  }

  Widget _buildInfoRow(Widget icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey))),
        ],
      ),
    );
  }
}
