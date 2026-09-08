import 'dart:async';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/formatters/phone_formatter.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../widgets/dialog/calls_number_sheet_dialog.dart';
import '../widgets/dialog/create_new_contact_dialog.dart';

class CallPhoneNumber extends StatefulWidget {
  const CallPhoneNumber({super.key});

  @override
  CallPhoneNumberState createState() => CallPhoneNumberState();
}

class CallPhoneNumberState extends State<CallPhoneNumber> {
  final List<String> _buttons = ['1', '2 ABC', '3 DEF', '4 GHI', '5 JKL', '6 MNO', '7 PQRS', '8 TUV', '9 WXYZ', '*', '0 +', '#'];
  bool _isCheckingUser = false;
  bool _userExists = false;
  String _enteredNumber = '';
  Timer? _phoneCheckTimer;



  @override
  void dispose() {
    _phoneCheckTimer?.cancel();
    super.dispose();
  }

  void _checkUser() {
    _phoneCheckTimer?.cancel();

    _phoneCheckTimer = Timer(
      const Duration(milliseconds: 400), () async {
        final phone = PhoneFormatter.normalizePhone(_enteredNumber);

        if (phone.length != 11) {
          if (!mounted) return;

          setState(() {
            _userExists = false;
            _isCheckingUser = false;
          });

          return;
        }

        if (!mounted) return;

        setState(() {
          _isCheckingUser = true;
        });

        try {
          final snapshot = await APIs.firestore.collection('Users').where('phone', isEqualTo: phone).limit(1).get();

          if (!mounted) return;

          setState(() {
            _userExists = snapshot.docs.isNotEmpty;
            _isCheckingUser = false;
          });
        } catch (e) {
          if (!mounted) return;

          setState(() {
            _userExists = false;
            _isCheckingUser = false;
          });
        }
      },
    );
  }

  void _addNumber(String number) {
    final normalized = PhoneFormatter.normalizePhone(_enteredNumber);

    if (normalized.length >= 11) return;

    setState(() {
      if (number == '0' && _enteredNumber.isEmpty) {
        _enteredNumber = '7';
      } else {
        _enteredNumber += number;
      }
    });

    _checkUser();
  }

  void _deleteNumber() {
    if (_enteredNumber.isEmpty) return;

    setState(() {
      _enteredNumber = _enteredNumber.substring(0, _enteredNumber.length - 1);
      _userExists = false;
    });

    _checkUser();
  }

  void _addPlus() {
    if (_enteredNumber.isEmpty) {
      setState(() {
        _enteredNumber = '+';
      });
    }
  }

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToOpenSMSApp)));
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
                  icon: const Icon(Icons.arrow_back_rounded),
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
                  Text(PhoneFormatter.formatPhoneNumber(_enteredNumber), style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 36, fontWeight: FontWeight.normal, height: 1.2)),
                if (_enteredNumber.isNotEmpty && PhoneFormatter.normalizePhone(_enteredNumber).length == 11 && !_isCheckingUser && !_userExists)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Нет в Chatify', style: TextStyle(color: ChatifyColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w400)),
                        Text(' · ', style: TextStyle(color: ChatifyColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                        GestureDetector(
                          onTap: () {
                            _sendSms(
                              PhoneFormatter.normalizePhone(_enteredNumber),
                            );
                          },
                          child: Text('Пригласить', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 13, fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                  ),
                ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: _buttons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      final buttonText = _buttons[index];
                      final number = buttonText[0];
                      final letters = buttonText.length > 1 ? buttonText.substring(1) : '';
                      final isZero = number == '0';

                      return SizedBox(
                        width: 70,
                        height: 70,
                        child: GestureDetector(
                          onLongPress: isZero
                            ? () {
                                _addPlus();
                              }
                            : null,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(10), backgroundColor: ChatifyColors.popupColorDark, side: BorderSide.none),
                            onPressed: () {
                              _addNumber(number);
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
                        style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(10), backgroundColor: ChatifyColors.greenSlate, side: BorderSide.none),
                        child: Icon(Icons.phone, size: 40, color: ChatifyColors.black),
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
                          icon: SvgPicture.asset(ChatifyVectors.backspaceOutline, width: ChatifySizes.fontSizeUn, height: ChatifySizes.fontSizeUn, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
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
