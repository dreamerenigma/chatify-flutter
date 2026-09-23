import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'configure_proxy_screen.dart';

class ProxyServerScreen extends StatelessWidget {
  const ProxyServerScreen({super.key});

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
            title: Text('Прокси-сервер', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text('Использовать прокси-сервер', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 20),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4),
                  children: [
                    const TextSpan(text: 'Используйте прокси-сервер только в том случае, если подключиться к Chatify не удается. Ваш IP-адрес может быть виден оператору прокси-сервера, который не имеет отношения к Chatify. '),
                    TextSpan(
                      text: 'Подробнее',
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
            ),
            CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
            Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.3 * 255).toInt()),
                highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.3 * 255).toInt()),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfigureProxyScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Настроить прокси-сервер', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
