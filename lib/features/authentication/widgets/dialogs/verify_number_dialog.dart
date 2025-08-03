import 'dart:io';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/verify_phone_number_screen.dart';

void showVerifyNumberAlertDialog(BuildContext context, String phoneNumber, UserModel user) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.light,
            child: Container(
              width: Platform.isWindows ? DeviceUtils.getScreenWidth(context) < 600 ? DeviceUtils.getScreenWidth(context) * 0.5 : DeviceUtils.getScreenWidth(context) < 900 ? DeviceUtils.getScreenWidth(context) * 0.40 : DeviceUtils.getScreenWidth(context) * 0.25 : double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.light, borderRadius: BorderRadius.circular(25)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).isCorrectNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      Text(phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(S.of(context).change, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd)),
                          ),
                          SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              _sendOtp(context, phoneNumber, user);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(S.of(context).yes, style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: -15,
                    top: -12,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _sendOtp(BuildContext context, String phoneNumber, UserModel user) {
  FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: const Duration(seconds: 60),

    verificationCompleted: (PhoneAuthCredential credential) async {
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.of(context).pop();

        Navigator.push(context, createPageRoute(VerifyPhoneNumberScreen(verificationId: '', phoneNumber: phoneNumber, user: user)));
      } catch (e) {
        Navigator.of(context).pop();
      }
    },

    verificationFailed: (FirebaseAuthException e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).verificationError}: ${e.message}'), backgroundColor: ChatifyColors.red),
      );
      Navigator.of(context).pop();
    },

    codeSent: (String verificationId, int? resendToken) async {
      Navigator.of(context).pop();

      Navigator.push(context, createPageRoute(VerifyPhoneNumberScreen(verificationId: verificationId, phoneNumber: phoneNumber, user: user)));
    },

    codeAutoRetrievalTimeout: (String verificationId) {
      Navigator.of(context).pop();
    },
  );
}
