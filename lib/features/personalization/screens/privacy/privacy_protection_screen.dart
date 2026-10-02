import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../widgets/dialogs/light_dialog.dart';

class PrivacyProtectionScreen extends StatefulWidget {
  const PrivacyProtectionScreen({super.key});

  @override
  State<PrivacyProtectionScreen> createState() => _PrivacyProtectionScreenState();
}

class _PrivacyProtectionScreenState extends State<PrivacyProtectionScreen> {
  final ScrollController scrollController = ScrollController();
  final GetStorage box = GetStorage();
  bool isNotifySecurityEnabled = false;

  @override
  void initState() {
    super.initState();
    isNotifySecurityEnabled = box.read<bool>(AppKeys.privacyProtectionKey) ?? false;
  }

  void toggleSwitch(bool value) {
    setState(() {
      isNotifySecurityEnabled = value;
    });

    box.write(AppKeys.privacyProtectionKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(color: ChatifyColors.white, boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))]),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            elevation: 0,
            title: Text('Расширенная защита конфиденциальности', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Scrollbar(
            controller: scrollController,
            thickness: 2,
            thumbVisibility: true,
            radius: Radius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChatPrivacy(
                  context,
                  title: 'Все чаты по умолчанию конфиденциальны — не зависимо от того, включили ли вы эту настройку. ',
                  actionText: 'Подробнее',
                  onActionTap: () async {},
                ),
                SizedBox(height: 20),
                Center(child: SizedBox(width: 110, height: 110, child: SvgPicture.asset(ChatifyVectors.messagePrivacy, fit: BoxFit.contain))),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Ограничьте возможность передачи сообщений и медиафайлов из этого чата за пределы Chatify.', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4)),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Если вы включите эту функцию, участники этого чата:',
                    style: TextStyle(color: ChatifyColors.lightContainer, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4),
                  ),
                ),
                const SizedBox(height: 25),
                _buildPrivacyOption(
                  context,
                  icon: Icon(Icons.image_outlined, size: 25, color: ChatifyColors.darkGrey),
                  title: 'Не смогут автоматически сохранять медиафайлы в Галерее своего устройства',
                ),
                _buildPrivacyOption(
                  context,
                  icon: SvgPicture.asset(ChatifyVectors.aiOutline, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  title: 'Не смогут задавать вопросы Chat AI, создавать изображения либо сводки',
                ),
                const SizedBox(height: 10),
                _buildPrivacyOption(
                  context,
                  icon: Icon(Icons.file_upload_outlined, size: 25, color: ChatifyColors.darkGrey),
                  title: 'Не смогут экспортировать этот чат',
                ),
                const SizedBox(height: 10),
                CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
                Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    onTap: () {
                      setState(() {
                        isNotifySecurityEnabled = !isNotifySecurityEnabled;
                        toggleSwitch;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 20, top: 16, bottom: 16),
                      child: Row(
                        children: [
                          Expanded(child: Text('Расширенная защита конфиденциальности в чате', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                          const SizedBox(width: 12),
                          CustomSwitch(
                            value: isNotifySecurityEnabled,
                            onChanged: toggleSwitch,
                            switchWidth: 55,
                            switchHeight: 33,
                            thumbSize: 25,
                            thumbPadding: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatPrivacy(BuildContext context, {required String title, required String actionText, required VoidCallback onActionTap}) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
        decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt()), borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 30, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
            SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400, height: 1.5),
                  children: [
                    TextSpan(text: title),
                    TextSpan(
                      text: actionText,
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = onActionTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(BuildContext context, {required Widget icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 32, child: Center(child: icon)),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: TextStyle(color: ChatifyColors.borderPrimary, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
        ],
      ),
    );
  }
}
