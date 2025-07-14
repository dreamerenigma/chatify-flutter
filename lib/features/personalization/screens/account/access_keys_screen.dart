import 'dart:developer';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/services/android/passkey_service.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AccessKeysScreen extends StatelessWidget {
  const AccessKeysScreen({super.key});

  static const Map<String, int> _schemeMap = {
    'blue': 0,
    'red': 1,
    'green': 2,
    'orange': 3,
  };

  String getAsset(int schemeIndex) {
    switch (schemeIndex) {
      case 0:
        return ChatifyVectors.accessKeysBlue;
      case 1:
        return ChatifyVectors.accessKeysRed;
      case 2:
        return ChatifyVectors.accessKeysGreen;
      case 3:
        return ChatifyVectors.accessKeysOrange;
      default:
        return ChatifyVectors.accessKeysBlue;
    }
  }

  int mapSchemeToIndex(String scheme) {
    return _schemeMap[scheme.toLowerCase().trim()] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Color dynamicIconColor = colorsController.getColor(colorsController.selectedColorScheme.value);
    String scheme = colorsController.selectedColorScheme.value.toString();
    int schemeIndex = mapSchemeToIndex(scheme);

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
            title: Text('Ключи доступа', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: SvgPicture.asset(
                      getAsset(schemeIndex),
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      'Обеспечте безопасный вход и защитите свой аккаунт',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildItemInfo(icon: BootstrapIcons.shield_check, text: 'Создайте ключ достпа, чтобы у вас был надежный и простой способ войти в свой аккаунт.', iconColor: dynamicIconColor, iconSize: 22, iconWidth: 28),
                  _buildItemInfo(icon: Icons.fingerprint_rounded, text: 'Войдите в Chatify с помощью функции распознавания лица или отпечатка либо при помощи функции блокировки экрана.', iconColor: dynamicIconColor, iconSize: 24, iconWidth: 28),
                  _buildItemInfo(icon: Icons.devices_rounded, text: 'Ваш ключ доступа надежно сохранен в менеджере паролей.', iconColor: dynamicIconColor, iconSize: 22, iconWidth: 30),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: ElevatedButton(
              onPressed: () async {
                Dialogs.showCustomDialog(context: context, message: S.of(context).connected, duration: const Duration(seconds: 4));
                await Future.delayed(const Duration(seconds: 4));
                final responseJson = await PasskeyService.createPasskey();
                if (responseJson != null) {
                  log('Passkey created: $responseJson');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: ChatifyColors.white,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Создать ключ доступа', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo({required IconData icon, required String text, required Color iconColor, double iconSize = 24, double? iconWidth}) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 40, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(alignment: Alignment.center, height: 24, child: Icon(icon, size: iconSize, color: iconColor)),
          SizedBox(width: iconWidth),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 15, height: 1.3), softWrap: true, overflow: TextOverflow.visible),
          ),
        ],
      ),
    );
  }
}
