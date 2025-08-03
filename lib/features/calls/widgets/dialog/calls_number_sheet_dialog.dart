import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showCallsNumberBottomSheet(BuildContext context, String enteredNumber) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder( borderRadius: BorderRadius.only( topLeft: Radius.circular(16), topRight: Radius.circular(16))),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _editPhoneNumber(context, enteredNumber);
          },
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(S.of(context).callsNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                              Text(enteredNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal)),
                            ],
                          ),
                          Text(S.of(context).callViaMobileOperator, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                        ],
                      ),
                      Icon( Icons.phone, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _editPhoneNumber(BuildContext context, String phoneNumber) async {
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    status = await Permission.phone.request();
  }
  if (status.isGranted) {
    final intent = AndroidIntent(
      action: 'android.intent.action.DIAL',
      data: 'tel:$phoneNumber', );
    try {
      await intent.launch();
    } catch (e) {
      throw '${S.of(context).couldNotLaunch} $phoneNumber';
    }
  } else {
    throw S.of(context).phoneCallPermissionNotGranted;
  }
}
