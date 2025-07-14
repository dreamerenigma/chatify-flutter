import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class PrivacyBlockedAppScreen extends StatefulWidget {
  const PrivacyBlockedAppScreen({super.key});

  @override
  State<PrivacyBlockedAppScreen> createState() => PrivacyBlockedAppScreenState();
}

class PrivacyBlockedAppScreenState extends State<PrivacyBlockedAppScreen> {
  bool isBiometricEnabled = false;
  final storage = GetStorage();
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    isBiometricEnabled = storage.read('isBiometricEnabled') ?? false;
  }

  Future<void> toggleSwitch(bool value) async {
    if (value) {
      bool authenticated = await authenticate();
      if (!authenticated) return;
    }

    setState(() {
      isBiometricEnabled = value;
    });

    storage.write('isBiometricEnabled', isBiometricEnabled);
  }

  Future<bool> authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        log('Биометрия не поддерживается на этом устройстве');
        return false;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Пожалуйста, подтвердите свою личность',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );

      return authenticated;
    } catch (e) {
      log('Ошибка биометрической аутентификации: $e');
      return false;
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
            title: Text(
              'Блокировка приложения',
              style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
            ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  toggleSwitch(!isBiometricEnabled);
                },
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Биометрическая',
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                  'Если этот параметр включён, \n'
                                  'Chatify нужно будет \n'
                                  'разблокировать с помощью лица \n'
                                  'отпечатка пальца или другого \n'
                                  'уникального идентификатора. Вы \n'
                                  'можете принимать звонки, даже \n'
                                  'если Chatify заблокирован. \n',
                                style: TextStyle(
                                  fontSize: ChatifySizes.fontSizeSm,
                                  color: ChatifyColors.darkGrey,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Switch(
                          value: isBiometricEnabled,
                          activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
                          onChanged: (value) {
                            toggleSwitch(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 0, thickness: 1, color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.grey),
        ],
      ),
    );
  }
}
