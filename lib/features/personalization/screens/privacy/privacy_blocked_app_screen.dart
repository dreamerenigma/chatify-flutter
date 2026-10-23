import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';

class PrivacyBlockedAppScreen extends StatefulWidget {
  const PrivacyBlockedAppScreen({super.key});

  @override
  State<PrivacyBlockedAppScreen> createState() => PrivacyBlockedAppScreenState();
}

class PrivacyBlockedAppScreenState extends State<PrivacyBlockedAppScreen> {
  final storage = GetStorage();
  final LocalAuthentication auth = LocalAuthentication();
  bool isBiometricEnabled = false;

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
      final LocalAuthentication auth = LocalAuthentication();

      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        return false;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: S.of(context).pleaseConfirmYourIdentity,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
        sensitiveTransaction: true,
      );

      return authenticated;
    } catch (e) {
      log('${S.of(context).biometricAuthError}: $e');
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
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text(S.of(context).blockingApp, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            elevation: 0,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  onTap: () {
                    toggleSwitch(!isBiometricEnabled);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).biometric, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                              RichText(
                                text: TextSpan(
                                  text: S.of(context).enabledAppUnlockedFingerprint,
                                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: CustomSwitch(
                            value: isBiometricEnabled,
                            onChanged: (value) {
                              toggleSwitch(value);
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
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, bottom: 15),
        ],
      ),
    );
  }
}
