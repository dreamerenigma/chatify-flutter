import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/dialog/calls_number_sheet_dialog.dart';
import '../widgets/dialog/create_new_contact_dialog.dart';

class CallPhoneNumber extends StatefulWidget {
  const CallPhoneNumber({super.key});

  @override
  CallPhoneNumberState createState() => CallPhoneNumberState();
}

class CallPhoneNumberState extends State<CallPhoneNumber> {
  final List<String> _buttons = [
    '1', '2 ABC', '3 DEF',
    '4 GHI', '5 JKL', '6 MNO',
    '7 PQRS', '8 TUV', '9 WXYZ',
    '*', '0 +', '#'
  ];

  String _enteredNumber = '';

  Future<void> _sendSms(String phoneNumber) async {
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'sms:$phoneNumber',
      arguments: {
        'sms_body':
        'Давай будем общаться в Chatify! Это быстрое, удобное и безопасное приложение для бесплатного общения друг с другом. Скачать: https://inputstudios.vercel.app/chatify'
      },
    );

    try {
      await intent.launch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToOpenSMSApp)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                if (_enteredNumber.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.person_add_alt),
                    onPressed: () {
                      const CreateNewContactDialog().showCreateNewContactDialog(context);
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_enteredNumber.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _enteredNumber,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeGl, fontWeight: FontWeight.normal),
                    ),
                  ),
                ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: _buttons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final buttonText = _buttons[index];
                      final number = buttonText[0];
                      final letters = buttonText.length > 1 ? buttonText.substring(1) : '';

                      return SizedBox(
                        width: 70,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: ChatifyColors.popupColorDark,
                            side: BorderSide.none,
                          ),
                          onPressed: () {
                            setState(() {
                              _enteredNumber += number;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(number, style: TextStyle(fontSize: ChatifySizes.fontSizeUn, fontWeight: FontWeight.normal)),
                              if (letters.isNotEmpty)
                              Text(letters, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_enteredNumber.isNotEmpty)
                      IconButton(
                        highlightColor: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey,
                        padding: const EdgeInsets.all(30),
                        icon: Icon(MdiIcons.messageTextOutline, size: ChatifySizes.fontSizeUn),
                        onPressed: () {
                          setState(() {
                            _sendSms(_enteredNumber);
                          });
                        },
                      ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 85,
                      height: 85,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_enteredNumber.isNotEmpty) {
                            showCallsNumberBottomSheet(context, _enteredNumber);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: ChatifyColors.success,
                          side: BorderSide.none,
                        ),
                        child: const Icon(Icons.phone, size: 40),
                      ),
                    ),
                    const SizedBox(width: 9),
                    if (_enteredNumber.isNotEmpty)
                      InkWell(
                        onLongPress: () {
                          setState(() {
                            _enteredNumber = '';
                          });
                        },
                        child: IconButton(
                          highlightColor: context.isDarkMode ? ChatifyColors.popupColor : ChatifyColors.grey,
                          padding: const EdgeInsets.all(30),
                          icon: Icon(Ionicons.backspace_outline, size: ChatifySizes.fontSizeUn),
                          onPressed: () {
                            setState(() {
                              _enteredNumber = _enteredNumber.substring(0, _enteredNumber.length - 1);
                            });
                          },
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
